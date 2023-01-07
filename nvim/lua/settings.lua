-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

local util = require("module.util")

-- #Variables
vim.env.myvimrc = vim.loop.fs_realpath(vim.env.myvimrc)
vim.g.repo = "c:\\bin\\repository\\tar80"
vim.g.update_time = 700

vim.api.nvim_cmd({ cmd = "language", args = { "message", "C" } }, {})

-- ##Unload {{{2
vim.g.loaded_2html_plugin = true
vim.g.loaded_gzip = true
vim.g.loaded_man = true
vim.g.loaded_matchit = true
vim.g.loaded_matchparen = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_spellfile_plugin = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_zipPlugin = true
--}}}2

-- #Options
-- ##Global {{{2
vim.api.nvim_set_option("termguicolors", true)
vim.api.nvim_set_option("foldcolumn", "1")
vim.api.nvim_set_option("fileformats", "unix,dos,mac")

-- ##Local {{{2
--vim.api.nvim_buf_set_option(0, "name", value)

-- ##Both {{{2
vim.o.t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"
vim.o.t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"
vim.o.t_Cs = "\\e[4:3m"
vim.o.t_Ce = "\\e[4:0m"
vim.o.fileencodings = "utf-8,utf-16le,cp932,euc-jp,sjis"
-- vim.o.timeoutlen = 1000
vim.o.updatetime = vim.g.update_time
-- vim.o.autochdir = true
-- vim.opt.diffopt:append({"iwhite"})
vim.o.diffopt = "vertical,filler,iwhite,iwhiteeol,closeoff,indent-heuristic,algorithm:histogram"
-- vim.o.backup= false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.history = 300
-- vim.o.ambiwidth = 'single'
vim.o.gdefault = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.formatoptions = "mMjql"
vim.o.wrap = false
vim.o.wrapscan = false
vim.o.whichwrap = "<,>,[,],h,l"
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = ">>"
vim.o.scrolloff = 1
vim.o.sidescroll = 6
vim.o.sidescrolloff = 3
vim.o.lazyredraw = true
vim.o.list = true
vim.opt.listchars = { tab = "| ", extends = "<", precedes = ">", trail = "_" }
vim.o.confirm = true
-- vim.o.display = 'lastline'
vim.o.showmode = false
vim.o.showtabline = 2
vim.o.laststatus = 3
vim.o.cmdheight = 1
vim.o.number = true
-- vim.o.numberwidth = 4
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
-- vim.o.backspace = { indent = true,eol = true, start = true }
vim.o.complete = ".,w"
vim.opt.completeopt = { menu = true, menuone = true, noselect = true }
vim.o.winblend = 6
vim.o.pumblend = 6
vim.o.pumheight = 10
vim.o.pumwidth = 20
vim.o.matchtime = 2
vim.opt.matchpairs:append({ "【:】", "[:]", "<:>" })
-- vim.cmd[[set tabstop<]]
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.virtualedit = "block"
-- vim.o.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildoptions:remove({ "tagfile" })
vim.opt.spelllang:append({ "cjk" })
vim.opt.shortmess:append("cs")
vim.opt.shortmess:remove({ "F" })
-- vim.opt.fillchars = { vert = "█", vertleft = "█", vertright = "█", verthoriz = "█", horiz = "█", horizup = "█", horizdown = "█", }
-- vim.opt.fillchars = { vert = "│" }
vim.o.keywordprg = ":help"
vim.o.helplang = "ja"
vim.o.helpheight = 10
vim.o.previewheight = 8
vim.opt.path = { ".", "" }
--}}}2

-- #Autogroup
vim.api.nvim_create_augroup("rcSettings", {})

-- #Autocommands
-- ##AutoProjectRootDir {{{2
-- Credit:This code compiles vim-findroot(https://github.com/mattn/vim-findroot) to lua
-- function _G.auto_project_root_dir()
--   local patterns = require("module.tables").project_root_patterns
--   local parentdir = util.buf_parent_dir(vim.fn.expand("%:p"))
--   if parentdir == "" then
--     return
--   end
--   local workspace = util.detect_workspace(parentdir, patterns)
--   if workspace ~= nil and workspace ~= vim.fn.getcwd() then
--     parentdir = workspace
--     if vim.v.vim_did_enter ~= 0 then
--       require("module.repository").get_branch_stats(workspace)
--     end
--     if workspace:lower() == vim.fs.normalize(vim.fn.getcwd()):lower() then
--       return
--     end
--   end
--   vim.api.nvim_cmd({ cmd = "lchdir", args = { parentdir } }, {})
-- end
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   group = "rcSettings",
--   command = "lua auto_project_root_dir()",
-- })

-- ##Editing line highlighting rules {{{2
vim.api.nvim_create_autocmd("CursorHoldI", {
  group = "rcSettings",
  callback = function()
    if vim.bo.filetype ~= "TelescopePrompt" then
      vim.api.nvim_win_set_option(0, "cursorline", true)
    end
  end,
})
-- NOTE: FocusLost does not work mounted in the WindowsTereminal.
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = "rcSettings",
  callback = function()
    if vim.fn.mode() == "i" and vim.bo.filetype ~= "TelescopePrompt" then
      vim.api.nvim_win_set_option(0, "cursorline", true)
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "CursorMovedI", "InsertLeave" }, {
  group = "rcSettings",
  command = "setl nocursorline",
})
-- ##In Insert-Mode, we want a longer updatetime {{{2
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "rcSettings",
  command = "set updatetime=4000",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "rcSettings",
  command = 'setl iminsert=0|execute "set updatetime=" . g:update_time',
})
-- ##Filetype rules {{{2
vim.api.nvim_create_autocmd("FileType", {
  group = "rcSettings",
  pattern = "qf",
  command = "setl nowrap",
})
-- ##Yanked, it shines {{{2
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "rcSettings",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "PmenuSel", on_visual = false, timeout = 150 })
  end,
})
--}}}2

-- #Functions
_G.Simple_fold = function() -- {{{2
  -- Credits:This code is based on https://github.com/tamton-aquib/essentials.nvim
  local fs, fe = vim.v.foldstart, vim.v.foldend
  local start_line = vim.fn.getline(fs):gsub("\t", ("\t"):rep(vim.opt.ts:get()))
  local end_line = vim.trim(vim.fn.getline(fe))
  local nol = fe - fs .. ": "
  local sep = " » "
  local spaces = (" "):rep(vim.o.columns - start_line:len() - end_line:len() - nol:len() - sep:len())

  return nol .. start_line .. sep .. end_line .. spaces
end
vim.o.foldtext = "v:lua.Simple_fold()"

local toggleShellslash = function() -- {{{2
  if vim.o.shellslash then
    vim.opt_local.shellslash = false
    print("\\noshellslash\\")
  else
    vim.opt_local.shellslash = true
    print("/shellslash/")
  end
end --}}}2
local search_star = function(g, mode) -- {{{2
  local word
  if mode ~= "v" then
    word = vim.fn.expand("<cword>")
    word = g == "g" and word or "\\<" .. word .. "\\>"
  else
    local first = vim.fn.getpos("v")
    local last = vim.fn.getpos(".")
    local lines = vim.fn.getline(first[2], last[2])
    if #lines > 1 then
      -- word = table.concat(vim.api.nvim_buf_get_text(0, first[2] - 1, first[3] - 1, last[2] - 1, last[3], {}))
      return util.feedkey("*", "n")
    else
      word = lines[1]:sub(first[3], last[3])
    end
    util.feedkey("<ESC>", "n")
  end
  if vim.v.count > 0 then
    return "*"
  else
    vim.fn.setreg("/", word)
    return vim.cmd("set hlsearch")
  end
end --}}}2
local ppcust_load = function() -- {{{2
  if vim.bo.filetype ~= "PPxcfg" then
    vim.notify("Not PPxcfg", 1, {})
    return
  end

  vim.fn.system({ os.getenv("PPX_DIR") .. "\\ppcustw.exe", "CA", vim.fn.expand("%:p") })
  print("PPcust CA " .. vim.fn.expand("%:t"))
end --}}}2
-- #Keymaps
vim.g.mapleader = ";"

-- ##Normal {{{2
vim.keymap.set("n", "<leader>t", function()
  -- NOTE:This code excerpt from essentials.nvim(https://github.com/tamton-aquib/essentials.nvim)
  local c = vim.api.nvim_get_current_line()
  local subs = c:match("true") and c:gsub("true", "false") or c:gsub("false", "true")
  vim.api.nvim_set_current_line(subs)
end)
vim.keymap.set("n", "<F1>", function()
  return os.execute("c:/bin/cltc/cltc.exe")
end)
vim.keymap.set("n", "<F5>", function()
  if vim.o.diff == true then
    vim.api.nvim_command("diffupdate")
  end
end)
vim.keymap.set({ "n", "c" }, "<F4>", function()
  toggleShellslash()
end)
vim.keymap.set("n", "<C-F9>", function()
  ppcust_load()
end)
vim.keymap.set("n", "<F12>", function()
  -- local wrap = vim.o.wrap ~= true and "wrap" or "nowrap"
  if vim.o.diff == true then
    local cur = vim.fn.winnr()
    vim.api.nvim_command("windo setlocal wrap!|" .. cur .. "wincmd w")
  else
    vim.api.nvim_command("setl wrap! wrap?")
  end
  return ""
end)
vim.keymap.set("n", "<C-Z>", "<NOP>")
vim.keymap.set("n", ",", "<Cmd>setlocal nohlsearch<CR>")
vim.keymap.set("n", "<C-J>", "i<C-M><ESC>")
vim.keymap.set("n", "/", function()
  vim.o.hlsearch = true
  return "/"
end, { expr = true })
---- Move buffer use <SPACE>
vim.keymap.set("n", "<SPACE>", "<C-W>")
vim.keymap.set("n", "<SPACE><SPACE>", "<C-W><C-W>")
vim.keymap.set("n", "<SPACE>n", function()
  local i = 1
  while vim.fn.bufnr("Scratch" .. i) ~= -1 do
    i = i + 1
  end

  vim.api.nvim_cmd({ cmd = "new", args = { "Scratch" .. i } }, {})
  vim.api.nvim_buf_set_option(0, "buftype", "nofile")
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
end)
vim.keymap.set("n", "<SPACE>c", "<Cmd>tabclose<CR>")
---- close diff window
vim.keymap.set("n", "<SPACE>@", function()
  if vim.fn.bufexists(0) == 0 then
    return
  end
  local buf = vim.fn.bufnr("#")
  print(buf)
  if vim.api.nvim_buf_get_option(buf, "filetype") == "diff" then
    return vim.api.nvim_buf_delete(buf, {})
  end
  local difforg = vim.fn.bufnr("difforg")
  if difforg then
    return vim.api.nvim_buf_delete(difforg, {})
  end
end)

-- ##Insert & Command {{{2
vim.keymap.set("i", "<C-J>", "<DOWN>")
vim.keymap.set("i", "<C-K>", "<UP>")
vim.keymap.set("i", "<C-L>", "<DELETE>")
vim.keymap.set("i", "<C-F>", "<RIGHT>")
vim.keymap.set("i", "<S-DELETE>", "<C-O>D")
vim.keymap.set("!", "<C-B>", "<LEFT>")
vim.keymap.set("!", "<C-V>u", "<C-R>=nr2char(0x)<LEFT>")
vim.keymap.set("c", "<C-A>", "<HOME>")

-- ##Visual {{{2
---- Clipbord yank
vim.keymap.set("v", "<C-insert>", '"*y')
vim.keymap.set("v", "<C-delete>", '"*ygvd')

-- Do not release after range indentation process
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
-- Search for cursor under string without moving cursor
vim.keymap.set("n", "*", function()
  search_star()
end, { expr = true })
vim.keymap.set("n", "g*", function()
  search_star("g")
end, { expr = true })
vim.keymap.set("x", "*", function()
  search_star(_, "v")
end, { expr = true })

-- ##Commands
-- #"Gitdiff <path> <position> <treeish>" {{{2
-- vim.api.nvim_create_user_command("Gitdiff", 'lua require("module.repository").git_diff(<f-args>)', { nargs = "+" })
-- #"Busted" {{{2
vim.api.nvim_create_user_command("Busted",function ()
  local path = string.gsub(vim.fn.expand("%"), "\\", "/")
  require("module.busted").run(path)
end, {})

-- #"Z <filepath>" zoxide query {{{2
vim.api.nvim_create_user_command("Z", 'execute "tcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

-- #"L <cmd>" Display results on buffer {{{2
vim.api.nvim_create_user_command(
  "L",
  '<mods> new|setl buftype=nofile bufhidden=wipe noswapfile|call setline(1, split(execute(<q-args>), "\n"))',
  { nargs = 1, complete = "command" }
)

-- -- #"E <filepath>" Edit the file in parent directory {{{2
-- vim.api.nvim_create_user_command("E", "edit %:p:h\\<args>", {
--   nargs = 1,
--   complete = "file",
-- })

-- -- #"F <filename>" Rename editing file {{{2
-- vim.api.nvim_create_user_command("F", "file %:p:h\\<args>", {
--   nargs = 1,
-- })

-- #"W" stage editing file {{{2
-- vim.api.nvim_create_user_command("W", function()
--   vim.api.nvim_command("silent update")
--   local result = { "", 1 }
--   if vim.b.branch_name ~= nil then
--     local path = vim.fn.expand("%")
--     vim.fn.jobstart({ "git", "add", "-v", path }, {
--       on_stdout = function(id, data)
--         if data[1] ~= "" then
--           result = { data[1], 3 }
--           vim.fn.jobstop(id)
--         end
--       end,
--       on_stderr = function(id, data)
--         if data[1] ~= "" then
--           result = { data[1], 4 }
--           vim.fn.jobstop(id)
--         end
--       end,
--       on_exit = function()
--         if result[1] == "" then
--           result[1] = "No changes"
--         end
--         vim.notify(result[1], result[2])
--       end,
--     })
--   end
-- end, {})

-- #"UTSetup" Unit-test compose multi-panel {{{2
vim.api.nvim_create_user_command("UTSetup", function()
  if vim.b.branch_name == nil then
    return print("Not repository")
  end

  os.execute("wt -w 1 sp -V --size 0.4 " .. os.getenv("PPX_DIR") .. "/ppbw.exe -bootid:t -k @wt -w 1 mf left")

  local path = vim.fs.normalize(vim.fn.getcwd() .. "/t")
  local name = vim.fs.normalize("t/utp_" .. vim.fn.expand("%:t"))

  if vim.fn.isdirectory(path) ~= 1 then
    vim.fn.mkdir(path)
  end

  vim.api.nvim_command("bot split " .. name .. "|set fenc=utf-8|set ff=unix")
  -- vim.api.nvim_cmd({ cmd = "split", args = { name }, mods = { split = "botright" } }, {})
end, {})

-- #"UTDo <arguments>" Unit-test doing {{{2
vim.api.nvim_create_user_command("UTDo", function(...)
  local args = table.concat((...).fargs, ",")
  os.execute(
    os.getenv("PPX_DIR")
      .. "/pptrayw.exe -c *set unit_test_ppm="
      .. vim.fn.expand("%:p")
      .. '%:*cd %*extract(C,"%%1")%:*script %*getcust(S_ppm#plugins:ppm-test)/script/jscript/ppmtest_run.js,'
      .. args
  )
end, { nargs = "*" })
