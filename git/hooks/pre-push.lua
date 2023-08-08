#!/usr/bin/lua

-- I think technically this will only work if we're on that branch?
-- gotta RTFM.
local CMD_GIT_BRANCH = 'git rev-parse --abbrev-ref HEAD'

-- Could use regex instead of basename here but I'm lazy like that
local CMD_GIT_REPO = 'git rev-parse --show-toplevel'

local PROTECTED_BRANCHES = {['main'] = true, ['master'] = true, ['add-git-hook'] = true}

local PROTECTED_REPOS = {['linkerd2'] = true, ['linkerd2-proxy'] = true, ['dotfiles'] = true, ['*'] = true}

local ANSI_RED = "\27[31m"
local ANSI_RESET = "\27[0m"
local ANSI_WHITE_BOLD = "\27[37;1;4m" -- 4 is for underline
local ANSI_BOLD = "\27[1m"
local ANSI_GREEN = "\27[32m"
local HOOK_NAME = "\27[96;4m[git-push-hook-check]\27[0m "

-- Execute takes in a command as a string and calls out into the shell to
-- execute it. We start a sub process using `io.popen` and then use the handle
-- to read the output from the command.
local function execute(command)
  local handle = assert(io.popen(command))
  -- `*a` reads it all
  -- https://www.lua.org/manual/5.1/manual.html#pdf-file:read
  local output = handle:read("*a")
  handle:close()
  return output
end

local function try_execute(command)
  local success, data = pcall(execute, command)
  if not success then
    os.exit(2)
  end
  return data
end

local repo_path = try_execute(CMD_GIT_REPO)
local repo_name = string.match(repo_path, "/%a+/.+/(%a+)")
if not PROTECTED_REPOS[repo_name] and not PROTECTED_REPOS['*'] then
  os.exit()
end

local branch_name = try_execute(CMD_GIT_BRANCH)
branch_name = string.gsub(branch_name, '\n', '')
if PROTECTED_BRANCHES[branch_name] then
  local push_msg = HOOK_NAME..ANSI_GREEN.."\27[4;1mSure\27[0;32m you want to push to ["..ANSI_WHITE_BOLD..branch_name..ANSI_RESET..ANSI_GREEN.."]?"..ANSI_RESET..ANSI_BOLD.." (Y/n)"..ANSI_RESET
  local confirm
  repeat
    print(push_msg)
    local tty_handle = io.open("/dev/tty")
    confirm = tty_handle:read(1)
    if not confirm then return end   -- no input
    confirm = confirm:lower()
  until confirm == "y" or confirm == "n"
  if confirm ~= "y" then
    print(HOOK_NAME..ANSI_RED.."Push to ["..ANSI_WHITE_BOLD..branch_name..ANSI_RESET..ANSI_RED.."] aborted"..ANSI_RESET)
    os.exit(1)
  end
  return
end
os.exit()
