-- Auto-sync vimwiki notes with the git remote.
--
-- Delegates all git work to ~/scripts/wiki-sync, which holds a lock shared with
-- the wiki-sync systemd timer. This file only decides *when* to call it:
--
--   opening a wiki file  -> pull remote changes in the background
--   30s idle after :w    -> commit + push the session so far
--   quitting nvim        -> commit + push, detached so it survives exit
--
-- One commit per editing session rather than per write, so the log stays useful.

local SYNC_CMD = vim.fn.expand("~/scripts/wiki-sync")

-- Wiki root, taken from vimwiki's own config so the two can't drift apart.
local wiki_dir = vim.fn.expand("~/documents/notes")
if vim.g.vimwiki_list and vim.g.vimwiki_list[1] and vim.g.vimwiki_list[1].path then
  wiki_dir = vim.fn.expand(vim.g.vimwiki_list[1].path)
end
wiki_dir = vim.fn.resolve(wiki_dir):gsub("/$", "")

if vim.fn.executable(SYNC_CMD) == 0 then
  return
end

local IDLE_MS = 30000

local dirty = false      -- a wiki file was written this session
local pulled = false     -- pull once per session, on first wiki file opened
local timer = nil

-- Is this buffer an actual file inside the wiki?
local function in_wiki(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" or vim.bo[bufnr].buftype ~= "" then
    return false
  end
  local path = vim.fn.resolve(vim.fn.fnamemodify(name, ":p"))
  return path:sub(1, #wiki_dir + 1) == wiki_dir .. "/"
end

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

-- Full sync. `detach` keeps the process alive past nvim's exit, which is the
-- only way a push on quit can reliably finish.
local function sync(detach)
  dirty = false
  vim.fn.jobstart({ SYNC_CMD }, { detach = detach or false })
end

local group = vim.api.nvim_create_augroup("VimwikiSync", { clear = true })

-- Pull once, when the first wiki file of the session is opened. Reload buffers
-- afterwards so remote edits show up without a manual :e.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    if pulled or not in_wiki(args.buf) then
      return
    end
    pulled = true
    vim.fn.jobstart({ SYNC_CMD, "--pull" }, {
      on_exit = function()
        vim.schedule(function()
          vim.cmd("checktime")
        end)
      end,
    })
  end,
})

-- Debounce: each write pushes the commit back by IDLE_MS, so a burst of saves
-- collapses into one commit once you stop typing.
vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  callback = function(args)
    if not in_wiki(args.buf) then
      return
    end
    dirty = true
    stop_timer()
    timer = vim.uv.new_timer()
    timer:start(IDLE_MS, 0, function()
      stop_timer()
      vim.schedule(function()
        sync(false)
      end)
    end)
  end,
})

-- Quitting is the definitive end of a session: sync whatever is left.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    stop_timer()
    if dirty then
      sync(true)
    end
  end,
})

-- Manual escape hatch.
vim.api.nvim_create_user_command("WikiSync", function()
  stop_timer()
  sync(false)
  vim.notify("wiki-sync started", vim.log.levels.INFO)
end, { desc = "Sync vimwiki notes with the git remote now" })
