# Storage Migration Plan
## T480 → New NVMe, Full Disk Encryption + btrfs

---

## Overview

Fresh NixOS install on a new NVMe replacing the current T480 drive.

**Goals:**
- LUKS2 full disk encryption (Argon2id KDF)
- btrfs with subvolumes (snapshots, compression, flexible layout)
- Hibernate support (32GB swapfile — T480 has 31GB RAM)
- zram as primary swap
- Hardened kernel + SSH + firewall
- Fully declarative config: disk layout lives in `disko.nix`

**Deferred (TODO post-stabilisation):**
- Secure Boot with lanzaboote + sbctl
- Snapshot automation (snapper or btrbk)

---

## Phase 1: Prep Dotfiles (before touching hardware)

All files except `hardware-configuration.nix` can be written and committed before install day.

### 1.1 Add disko to flake.nix

```nix
inputs = {
  # ... existing inputs ...
  disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

In the `nixosSystem` modules list:

```nix
modules = [
  disko.nixosModules.disko
  ./disko.nix
  # ... rest of existing modules ...
];
```

---

### 1.2 Create disko.nix

New file at root of dotfiles. Defines the full disk layout declaratively.

**Partition layout:**
```
/dev/nvme0n1
├── p1: ESP       1GB   fat32   /boot
└── p2: LUKS2     rest
    └── btrfs
        ├── @          →  /            compress=zstd:3, noatime
        ├── @home      →  /home        compress=zstd:3, noatime
        ├── @nix       →  /nix         compress=zstd:1, noatime
        ├── @games     →  /games       nodatacow, noatime
        ├── @swap      →  /swap        nodatacow         (hibernate target)
        └── @snapshots →  /.snapshots
```

```nix
# disko.nix
{ ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;    # TRIM for NVMe health
                  bypassWorkqueues = true; # perf: reduce latency on NVMe
                };
                extraFormatArgs = [
                  "--type" "luks2"
                  "--cipher" "aes-xts-plain64"
                  "--key-size" "512"
                  "--hash" "sha512"
                  "--pbkdf" "argon2id"
                  "--pbkdf-memory" "1048576"  # 1GB RAM for KDF
                  "--iter-time" "5000"
                ];
                passwordFile = "/tmp/disk-password"; # echo -n "passphrase" > /tmp/disk-password before running disko
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd:3" "noatime" ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd:3" "noatime" ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                    };
                    "@games" = {
                      mountpoint = "/games";
                      mountOptions = [ "nodatacow" "noatime" ];
                    };
                    # nodatacow + no compression required for btrfs swapfiles.
                    # disko creates the swapfile via `btrfs filesystem mkswapfile`.
                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions = [ "nodatacow" "noatime" ];
                      swap.swapfile.size = "32G";
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
```

---

### 1.3 Create system/security.nix

New file. All hardening lives here, imported from `system/default.nix`.

```nix
# system/security.nix
{ ... }:
{
  # AppArmor — mandatory access control (MAC).
  # Normal Unix permissions are discretionary (you own a file, you control access).
  # AppArmor adds a second enforcement layer: per-program profiles define exactly
  # what files, sockets, and capabilities each program may access — even if normal
  # permissions would allow more. E.g. Firefox can be confined so it cannot read ~/.ssh/
  # even though you (the owner) are running it.
  # killUnconfinedConfinables: if a program has a profile but is somehow running outside
  # it (unconfined), kill the process rather than let it run unrestricted.
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  # auditd — kernel audit subsystem daemon. Receives audit events from the kernel
  # and writes them to a log (/var/log/audit/audit.log). Required for the rules below.
  # audit.rules: "-a exit,always -F arch=b64 -S execve" logs every program execution
  # (execve syscall) on 64-bit processes. Lets you reconstruct "what ran, when, as whom"
  # after an incident. High-volume on a desktop but invaluable forensically.
  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];

  # execWheelOnly: only binaries owned by root and in the wheel group can be used
  # as sudo targets. Prevents a compromised user binary from being sudo'd into root.
  security.sudo.execWheelOnly = true;

  # "!" as a hashed password means the root account is locked — no password will
  # ever match, so direct root login (console or SSH) is impossible.
  # You still get root via sudo from your wheel user.
  users.users.root.hashedPassword = "!";

  # Prevents the running kernel image from being replaced or tampered with at runtime.
  # Blocks tools like kexec (load a new kernel without rebooting) and /dev/mem writes
  # that could be used to patch the kernel in memory.
  security.protectKernelImage = true;

  boot.kernelParams = [
    # Zero all memory pages when allocated. Prevents a process from reading
    # leftover data from a previous process that used the same memory pages.
    "init_on_alloc=1"

    # Zero memory pages when freed. Mitigates use-after-free information leaks
    # where an attacker reads a freed page before it gets reused.
    "init_on_free=1"

    # Randomise the order of the page allocator freelist. Makes heap layout
    # less predictable, raising the bar for heap exploitation techniques.
    "page_alloc.shuffle=1"

    # Kernel Page Table Isolation. Mitigates Meltdown (CVE-2017-5754): keeps
    # kernel memory mappings out of user-space page tables so speculative
    # execution cannot leak kernel memory to user processes.
    "pti=on"

    # Disable the legacy vsyscall interface (a fixed kernel memory region that
    # user-space could call directly). It's a known ROP gadget source and no
    # modern software needs it.
    "vsyscall=none"

    # Disable the debugfs filesystem. Exposes kernel internals useful for
    # driver development but an unnecessary attack surface on a production machine.
    "debugfs=off"

    # NOTE: lockdown=confidentiality is intentionally omitted.
    # Both lockdown=integrity and lockdown=confidentiality explicitly block
    # hibernation (kernel image saved to disk is considered an information leak).
    # Since hibernate is a goal of this config, lockdown cannot be used.
    # Physical security is provided by LUKS2 + TPM2 instead.

    # NOTE: i915.enable_guc=2 stays in system/default.nix (GPU-specific)
  ];

  boot.kernel.sysctl = {
    # Reverse path filtering: drop incoming packets whose source address has no
    # route back out the interface it arrived on. Defeats IP spoofing attacks.
    "net.ipv4.conf.all.rp_filter"        = 1;

    # Refuse ICMP redirect messages. Redirects tell your machine to use a
    # different gateway — an attacker on the LAN could use these to redirect
    # your traffic through a machine they control (MITM).
    "net.ipv4.conf.all.accept_redirects" = 0;

    # Do not send ICMP redirects. Your machine should not be acting as a router,
    # so there is no reason to tell other hosts to change their routes.
    "net.ipv4.conf.all.send_redirects"   = 0;

    # SYN cookies: when the SYN backlog is full (SYN flood attack), respond with
    # a cryptographic cookie instead of allocating state. Legitimate clients
    # complete the handshake; flooded connections are dropped without resource exhaustion.
    "net.ipv4.tcp_syncookies"            = 1;

    # Do not accept IPv6 Router Advertisements. A rogue device on the network
    # could send RAs to redirect IPv6 traffic through itself.
    "net.ipv6.conf.all.accept_ra"        = 0;

    # Full ASLR (Address Space Layout Randomisation): randomise the base addresses
    # of stack, heap, and mapped libraries on every execution. Makes it much harder
    # to exploit memory corruption bugs because the attacker cannot know where
    # code or data lives.
    "kernel.randomize_va_space"          = 2;

    # Hide kernel symbol addresses (/proc/kallsyms, /proc/modules) from all users
    # including root. Kernel pointers showing up in logs would give an attacker
    # the addresses needed to defeat KASLR.
    "kernel.kptr_restrict"               = 2;

    # Restrict dmesg (kernel log) to privileged users. Kernel messages often
    # contain pointer values and hardware details useful for exploit development.
    "kernel.dmesg_restrict"              = 1;

    # Restrict access to perf_event_open syscall. The performance monitoring
    # subsystem has historically been a vector for side-channel attacks (Spectre
    # variants). Level 3 = only root can use it.
    "kernel.perf_event_paranoid"         = 3;

    # Prevent setuid/setgid programs from producing core dumps. A core dump of
    # a privileged process could contain secrets (passwords, keys) readable by
    # the user who triggered the crash.
    "fs.suid_dumpable"                   = 0;

    # Route core dumps to /bin/false (discard them) instead of writing to disk.
    # Belt-and-suspenders with suid_dumpable: even non-suid processes won't
    # leave core files that could expose sensitive memory contents.
    "kernel.core_pattern"                = "|/bin/false";
  };
}
```

---

### 1.4 Update system/nixos.nix

Switch from GRUB to systemd-boot (cleaner, no GRUB config file, better UEFI native):

```nix
# Replace GRUB block with:
boot.loader.systemd-boot.enable = true;
boot.loader.systemd-boot.configurationLimit = 10;
boot.loader.efi.canTouchEfiVariables = true;
# Remove: boot.loader.grub.*
```

Add LUKS boot config:

```nix
boot.initrd.systemd.enable = true;   # required for TPM2 unlock later

boot.initrd.luks.devices."cryptroot" = {
  device = "/dev/disk/by-partlabel/luks"; # disko uses partlabel
  allowDiscards = true;
  # After TPM2 enrolment, add:
  # crypttabExtraOpts = [ "tpm2-device=auto" ];
};
```

---

### 1.5 Update system/default.nix

Add imports and zram. Hibernate resume config is filled in post-install.

```nix
imports = [
  ./hardware-configuration.nix
  ./nixos.nix
  ./services.nix
  ./security.nix    # ADD
  ./desktop
];

# ADD: zram
zramSwap = {
  enable = true;
  algorithm = "zstd";
  memoryPercent = 50;
};

# ADD: hibernate resume — fill in AFTER install (see Phase 3)
# boot.resumeDevice = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
# boot.kernelParams = [ "resume_offset=XXXXXXXXXX" ];

# KEEP: existing i915, kyber scheduler, swappiness settings
# NOTE: vm.swappiness can be lowered further to 5 with zram (zram is preferred anyway)
boot.kernel.sysctl."vm.swappiness" = 5;
```

---

### 1.6 Update system/services.nix

Harden SSH and enable firewall:

```nix
# Firewall
# Note: services.openssh.openFirewall defaults to true, so port 22 is opened
# automatically. The explicit allowedTCPPorts entry is kept for auditability.
networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 22 ];
  logRefusedConnections = true;
};

# SSH hardening (replace bare enable = true)
services.openssh = {
  enable = true;
  settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    X11Forwarding = false;
    MaxAuthTries = 3;
    ClientAliveInterval = 300;
  };
  extraConfig = ''
    KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
  '';
};
```

---

## Phase 2: Install Day

### 2.1 Boot NixOS minimal ISO

Flash the latest NixOS minimal ISO to a USB. Boot into it on the T480.
Plug in ethernet — simpler than configuring wifi in the ISO environment.

### 2.2 Get your dotfiles onto the ISO

```bash
# ISO ships with git and nix
git clone <your-dotfiles-repo> ~/dotfiles
cd ~/dotfiles
```

### 2.3 Set LUKS passphrase for disko

```bash
# disko reads the passphrase from a file during formatting
echo -n "your-passphrase" > /tmp/disk-password
chmod 600 /tmp/disk-password
```

Choose a strong passphrase. This is your fallback if TPM2 unlock ever fails (firmware update, hardware change). Store it in 1Password + written copy in a safe place.

### 2.4 Run disko

```bash
sudo nix run github:nix-community/disko -- \
  --mode disko \
  ~/dotfiles/disko.nix
```

This partitions, formats, and mounts everything under `/mnt`. Verify:

```bash
mount | grep /mnt
lsblk -f
```

### 2.5 Create swapfile

**No manual step needed.** The `disko.nix` config declares `swap.swapfile.size = "32G"` on the `@swap` subvolume. Disko creates the swapfile via `btrfs filesystem mkswapfile` during the disko run in step 2.4, with CoW and compression handled correctly.

### 2.6 Generate hardware-configuration.nix

```bash
nixos-generate-config --no-filesystems --root /mnt
# This generates /mnt/etc/nixos/hardware-configuration.nix
# Copy it into your dotfiles:
cp /mnt/etc/nixos/hardware-configuration.nix ~/dotfiles/system/hardware-configuration.nix
```

Review it — confirm it has your NVMe kernel modules (`nvme`, `xhci_pci` etc.) and no filesystem entries (disko handles those).

### 2.7 Commit hardware-configuration.nix

Commit the updated `hardware-configuration.nix`. The swapfile is already declared in `disko.nix` — no separate `swapDevices` entry needed.

### 2.8 Install

```bash
nixos-install --flake ~/dotfiles#rewot-smibmuhb --root /mnt
```

Set root password when prompted (even though root login is locked, nixos-install requires it).

### 2.9 Reboot

```bash
umount -R /mnt
reboot
```

Remove USB. System should boot, prompt for LUKS passphrase, and come up normally.

---

## Phase 3: Post-Install (on running system)

### 3.1 Get hibernate resume offset

```bash
sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
# Outputs a number like: 533248
```

Add to `system/default.nix`:

```nix
# Use the UUID of the *decrypted* btrfs filesystem, NOT the raw LUKS partition.
# Get it with: lsblk -f /dev/mapper/cryptroot
boot.resumeDevice = "/dev/disk/by-uuid/XXXX";
boot.kernelParams = [ "resume_offset=533248" ]; # number from above command
```

Then:

```bash
sudo nixos-rebuild switch --flake .#rewot-smibmuhb
```

Test hibernate:

```bash
systemctl hibernate
# Should power off, then on resume restore your session
```

### 3.2 Enroll TPM2 key

Bind LUKS to TPM2 PCRs so the disk auto-unlocks on normal boot (passphrase only needed if firmware changes or tamper detected):

```bash
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-pcrs=0+7 \
  /dev/nvme0n1p2
```
# PCR 0 = firmware, PCR 7 = Secure Boot state.
# PCR 11 is only populated with Unified Kernel Images (UKI via systemd-stub)
# and would cause unlock failures after every kernel update with standard
# systemd-boot. Add PCR 11 only after migrating to lanzaboote (see TODO).

Enable TPM2 unlock in `system/nixos.nix`:

```nix
boot.initrd.luks.devices."cryptroot" = {
  device = "/dev/disk/by-partlabel/luks";
  allowDiscards = true;
  crypttabExtraOpts = [ "tpm2-device=auto" ];
};
```

### 3.3 Backup LUKS header

**Do not skip this.** A corrupted LUKS header = all data unrecoverable.

```bash
sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 \
  --header-backup-file ~/luks-header-backup.img

# Encrypt the backup before storing it
gpg --symmetric --cipher-algo AES256 ~/luks-header-backup.img
# Store luks-header-backup.img.gpg:
#   - 1Password (or other password manager)
#   - Encrypted USB drive kept offsite
rm ~/luks-header-backup.img  # remove unencrypted copy
```

### 3.4 Verify everything

```bash
# Encryption
lsblk -f                        # should show crypto_LUKS on nvme0n1p2
cryptsetup status cryptroot     # cipher, key size

# btrfs
btrfs filesystem show /
btrfs subvolume list /          # should list all @ subvolumes

# zram
zramctl                         # should show /dev/zram0, ~15GB, zstd

# Compression ratio (after some use)
btrfs filesystem df /
compsize /                      # shows actual compression savings

# Swappiness
cat /proc/sys/vm/swappiness     # should be 5

# AppArmor
sudo aa-status

# Firewall
sudo nft list ruleset
```

---

## TODO (post-stabilisation)

- [ ] **Secure Boot** — lanzaboote + sbctl, enroll own keys in UEFI
  - Prevents Evil Maid: someone with physical access can't swap your bootloader
  - Guide: https://github.com/nix-community/lanzaboote
- [ ] **Snapshot automation** — snapper or btrbk
  - Auto-snapshot before each `nixos-rebuild switch`
  - Retention policy (keep 7 daily, 4 weekly)
- [ ] **nixos-anywhere** — for future installs, can run disko + nixos-install over SSH to a bare machine

---

## File Change Summary

| File | Action | Key changes |
|------|--------|-------------|
| `flake.nix` | Edit | Add disko input + module |
| `disko.nix` | Create | Full disk layout |
| `system/security.nix` | Create | Kernel hardening, AppArmor, auditd |
| `system/nixos.nix` | Edit | GRUB → systemd-boot, LUKS boot config |
| `system/services.nix` | Edit | SSH hardening, firewall |
| `system/default.nix` | Edit | Import security.nix, zram, swapfile, hibernate resume |
| `system/hardware-configuration.nix` | Regenerate | New UUIDs from new NVMe |
