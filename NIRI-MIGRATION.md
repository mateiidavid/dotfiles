# GNOME to Niri Migration Plan

## Overview

Transition from GNOME desktop to **Niri** (scrollable tiling Wayland compositor) with a curated set of Wayland-native utilities. No hyprland ecosystem dependencies.

### Theme: Alpine Dusk

Blue-green tones inspired by high mountain forests at dusk. Teal and dark cyan with warm wood accents.

```
Background:  #141c1f  (mountain night)
Surface:     #1e2d30  (dark spruce)
Border:      #2e4548  (alpine stone)
Text:        #d0dce0  (snow mist)
Accent 1:    #5aada8  (glacier teal)
Accent 2:    #408a70  (alpine meadow)
Warning:     #c9a84c  (sunset amber)
Urgent:      #c45858  (alpine rose)
Info:        #5888b0  (twilight sky)
```

---

## Utility Stack

| GNOME Feature | Niri Replacement | Notes |
|---|---|---|
| GNOME Shell | **Niri** | Scrollable tiling compositor |
| Top bar | **Waybar** | Transparent bar, Alpine Dusk themed |
| App launcher | **Fuzzel** | Wayland-native, `Mod+D` |
| Notifications | **Mako** | Lightweight, urgency-based styling |
| Lock screen | **swaylock-effects** | Blur + clock overlay, uses `cool-lockscreen-v1.jpg` |
| Idle management | **swayidle** | 5min lock, 10min screen off |
| Wallpaper | **swaybg** | Uses `cool-wallpaper-v1.jpg` |
| Power menu | **Custom fuzzel script** | Lock/Suspend/Logout/Reboot/Shutdown |
| System tray | **Waybar tray module** | Replaces appindicator extension |
| Media controls | **Waybar mpris module** | Replaces media-controls extension |
| System monitor | **Waybar cpu/memory/temp** | Replaces TopHat extension |
| Rounded corners | **Niri native** | 12px radius, replaces rounded-window-corners-reborn |
| Window shadows | **Niri native** | Soft shadows with Alpine Dusk tint |
| Blur | **swaylock-effects** | Lock screen only (niri doesn't do shell blur) |
| Bluetooth | **Blueman** | Click BT icon in waybar to open |
| Network config | **nmtui** | Click network icon in waybar to open |

### GNOME Extensions No Longer Needed

- `dash-to-dock` — Niri is keyboard-driven, no dock needed
- `blur-my-shell` — No shell to blur; lock screen has blur via swaylock-effects
- `media-controls` — Replaced by waybar mpris module
- `appindicator` — Replaced by waybar tray module
- `color-picker` — Can add `grim` + `slurp` + a script if needed later
- `rounded-window-corners-reborn` — Niri does this natively
- `pop-shell` — Niri is a tiling compositor by default
- `tophat` — Replaced by waybar cpu/memory/temperature modules

---

## Files Changed

### Modified

| File | Change |
|---|---|
| `system/desktop/niri/default.nix` | Added packages: waybar, fuzzel, mako, swaylock-effects, swayidle, swaybg, playerctl, brightnessctl, pamixer, blueman, font-awesome. Added bluetooth service, PAM config for swaylock. Added "niri" to desktop enum. |
| `pkgs/desktop/niri.kdl` | Alpine Dusk focus ring gradient. Enabled shadows, rounded corners (12px), prefer-no-csd. spawn-at-startup for waybar, swaybg, mako, swayidle. |
| `pkgs/desktop/default.nix` | Wired up xdg.configFile entries for waybar, fuzzel, mako, swaylock, and the power menu script. Added `home.file` entries to copy wallpaper and lockscreen images into Nix store (`~/.local/share/wallpapers/`). |

### Created

| File | Purpose |
|---|---|
| `pkgs/desktop/waybar/config.jsonc` | Waybar module layout and configuration |
| `pkgs/desktop/waybar/style.css` | Alpine Dusk waybar CSS theme |
| `pkgs/desktop/fuzzel.ini` | Fuzzel launcher appearance and colors |
| `pkgs/desktop/mako.conf` | Mako notification daemon config |
| `pkgs/desktop/swaylock.conf` | swaylock-effects config with lockscreen image |
| `pkgs/desktop/power-menu.sh` | Fuzzel-based power menu script |

---

## Waybar Layout

```
[workspaces]        [media player | clock]        [weather | cpu mem temp | net bt vol bright bat | tray power]
```

**Style: Three Pills** (Style A) — transparent bar background, three separate pill groups with surface-color backgrounds and rounded corners.

- **Left**: Niri workspaces (dot indicators)
- **Center**: MPRIS media player + clock
- **Right**: Weather + system modules + power button
- **Power button**: Click opens fuzzel menu with Lock/Suspend/Log Out/Reboot/Shutdown
- **Network icon**: Click opens `nmtui` in ghostty
- **Bluetooth icon**: Click opens `blueman-manager`
- **Volume icon**: Click toggles mute, right-click opens `pavucontrol`
- **Weather**: wttrbar, updates every 10 minutes via wttr.in

### Alternative: Style D — Floating Rounded Bar

To switch to a single floating rounded bar instead of three pills, replace the `.modules-left/.modules-center/.modules-right` CSS block with:

```css
window#waybar > box {
    margin: 4px 8px 0 8px;
    background: rgba(20, 28, 31, 0.85);
    border: 1px solid rgba(46, 69, 72, 0.5);
    border-radius: 12px;
    padding: 0 6px;
}

.modules-left,
.modules-center,
.modules-right {
    background: transparent;
    border: none;
    border-radius: 0;
    padding: 0;
    margin: 0;
}
```

---

## Keybinding Reference

### Layer Architecture

```
Super (Mod)     → Niri compositor (windows, workspaces, layout)
Alt             → Zellij multiplexer + Ghostty splits (terminal layer)
Ctrl+Shift      → Ghostty tabs
Space (leader)  → Neovim commands
```

### Niri Keybindings (Super)

#### Window Navigation
| Binding | Action |
|---|---|
| `Super+H/J/K/L` | Focus left/down/up/right |
| `Super+Ctrl+H/J/K/L` | Move window left/down/up/right |
| `Super+Shift+H/J/K/L` | Focus monitor left/down/up/right |
| `Super+Shift+Ctrl+H/J/K/L` | Move window to monitor |

#### Workspaces
| Binding | Action |
|---|---|
| `Super+1-9` | Focus workspace 1-9 |
| `Super+Ctrl+1-9` | Move window to workspace 1-9 |
| `Super+U/I` | Focus workspace down/up |
| `Super+Ctrl+U/I` | Move window to workspace down/up |

#### Window Layout
| Binding | Action |
|---|---|
| `Super+R` | Cycle preset widths (1/3, 1/2, 2/3) |
| `Super+F` | Maximize column |
| `Super+Shift+F` | Fullscreen window |
| `Super+C` | Center column |
| `Super+V` | Toggle floating |
| `Super+W` | Toggle tabbed column |
| `Super+Q` | Close window |
| `Super+Minus/Equal` | Adjust width +/-10% |
| `Super+[/]` | Consume/expel window |

#### System
| Binding | Action |
|---|---|
| `Super+T` | Open ghostty terminal |
| `Super+D` | Open fuzzel launcher |
| `Super+O` | Toggle overview |
| `Super+Alt+L` | Lock screen |
| `Super+Shift+E` | Quit niri (with confirmation) |
| `Print` | Screenshot |
| `Ctrl+Print` | Screenshot current screen |
| `Alt+Print` | Screenshot current window |

### Zellij Keybindings (Alt)
| Binding | Action |
|---|---|
| `Alt+P` | Pane mode |
| `Alt+T` | Tab mode |
| `Alt+N` | Resize mode |
| `Alt+S` | Scroll mode |
| `Alt+O` | Session mode |
| `Alt+H` | Move mode |
| `Alt+G` | Lock/unlock |
| `Alt+C` | New pane |
| `Alt+X` | Close pane |
| `Alt+F` | Toggle fullscreen |
| `Alt+W` | Toggle floating panes |
| `Alt+arrows` | Move focus |
| `Alt+=/-` | Resize |

### Ghostty Keybindings
| Binding | Action |
|---|---|
| `Alt+H/J/K/L` | Create split (when not in zellij) |
| `Alt+arrows` | Navigate splits |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab |
| `Ctrl+Shift+1-9` | Go to tab |
| `Alt+Z` | Toggle split zoom |

### Neovim Keybindings (Space leader)
| Binding | Action |
|---|---|
| `Ctrl+P` | Find files |
| `Space+/` | Live grep |
| `Space+B` | Switch buffers |
| `Space+A` | Code actions |
| `Space+RN` | Rename |
| `gd/gD/gr/gi` | Go to def/decl/refs/impl |
| `K` | Hover |
| `[g/]g` | Prev/next diagnostic |

---

## Switching

### To run Niri alongside GNOME (current: `desktop.enable = "multi"`)

Both GNOME and Niri sessions are available at the GDM login screen. Select "niri" from the session picker (gear icon).

### To switch to Niri only

In `system/default.nix`, change:
```nix
desktop.enable = "niri";
```

This will:
- Keep GDM as the display manager
- Stop loading GNOME desktop and extensions
- Keep gnome-keyring for credential storage

Then rebuild:
```bash
nswitch
```

### To go back to GNOME

```nix
desktop.enable = "multi";  # or "gnome" for gnome-only
```

---

## Post-Switch Checklist

- [ ] Log out of GNOME, select "niri" session at GDM
- [ ] Verify waybar appears at the top
- [ ] Check `Super+D` opens fuzzel
- [ ] Check `Super+T` opens ghostty
- [ ] Test lock screen: `Super+Alt+L`
- [ ] Verify media keys (volume, brightness, play/pause)
- [ ] Check notifications: `notify-send "test" "hello from mako"`
- [ ] Check bluetooth: click BT icon in waybar
- [ ] Check power menu: click power icon in waybar
- [ ] Verify wallpaper loads correctly
- [ ] Test workspace switching: `Super+1-9`
- [ ] Test window tiling: open multiple windows, use `Super+HJKL`
- [ ] If satisfied, switch `desktop.enable` from `"multi"` to `"niri"`

---

## Known Differences from GNOME

1. **No app grid** — Use fuzzel (`Super+D`) to launch apps by typing
2. **No dock** — Workspaces are in waybar; switch with `Super+1-9` or `Super+U/I`
3. **No window overview thumbnails** — `Super+O` shows niri's built-in overview
4. **No blur on desktop** — Only on lock screen (via swaylock-effects)
5. **Tiling by default** — Windows tile automatically; use `Super+V` to float
6. **Scrolling layout** — Niri's unique feature: workspaces scroll horizontally, windows are columns
