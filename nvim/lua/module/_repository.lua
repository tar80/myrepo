-- Credit:This code based on vim-g(https://github.com/kana/vim-g)
local M = {}
local branch_cache = {}
local naming_rules = {
  { "Rebase", "file", "/rabase-apply/rebasing", "/HEAD" },
  { "Am", "file", "/rabase-apply/applying", "/HEAD" },
  { "Am/Rebase", "dir", "/rebase-apply", "/HEAD" },
  { "Rebase-i", "file", "/rebase-merge/interactive", "/rebase-merge/head-name" },
  { "Rebase-m", "dir", "/rebase-merge", "/rebase-merge/head-name" },
  { "Merging", "file", "/MERGE_HEAD", "/HEAD" },
}
local function file_exist(path)
  local handle = io.open(path, "r")
  if handle ~= nil then
    io.close(handle)
  end
  return handle ~= nil
end
local function get_stdout(cmd)
  local handle = io.popen(cmd, "r")
  if not handle then
    return ""
  end
  local content = handle:read("*all")
  --NOTE:Cui status-line is buggy when an error is returned.
  if #content == 0 then
    local height = vim.go.cmdheight
    vim.go.cmdheight = 6
    vim.go.cmdheight = height
  end
  handle:close()
  return content
end
local function branch_cache_key(dir)
  return vim.fn.getftime(dir .. "/.git/HEAD") + vim.fn.getftime(dir .. "/.git/MERGE_HEAD")
end
local function branch_head_name(root, filepath)
  local branch_name = "(unknown)"
  local line = io.lines(filepath)()
  if line ~= nil then
    branch_name = string.match(line, "refs/heads/(.+)")
    if branch_name == nil then
      branch_name = "(unknown)"
      for l in io.lines(root .. "/logs/HEAD") do
        if string.find(l, "checkout: moving from", 1, true) ~= nil then
          branch_name = string.match(l, "to%s([^%s]+)")
          break
        end
      end
    end
  end
  return branch_name
end
local function branch_cache_key_and_name(root)
  local git_dir = root .. "/.git"
  local add_info = ""
  local head_info
  if vim.fn.isdirectory(git_dir) == 0 then
    return nil
  end
  (function()
    local head_spec, head_file
    for _, v in ipairs(naming_rules) do
      head_spec = git_dir .. v[3]
      if v[2] == "file" and file_exist(head_spec) then
        head_file = git_dir .. v[4]
        if file_exist(head_file) then
          add_info = "(" .. v[1] .. ")"
          head_info = branch_head_name(root, head_file)
          return
        end
      elseif v[2] == "dir" and vim.fn.isdirectory(head_spec) == 1 then
        head_file = git_dir .. v[4]
        if file_exist(head_file) then
          add_info = "(" .. v[1] .. ")"
          head_info = branch_head_name(root, head_file)
          return
        end
      end
    end
    head_info = branch_head_name(git_dir, git_dir .. "/HEAD")
  end)()
  return head_info .. add_info
end
M.get_branch_name = function(root)
  local key = branch_cache_key(root)
  if branch_cache[root] == nil or branch_cache[root][2] ~= key then
    branch_cache[root] = { branch_cache_key_and_name(root), key }
  end
  vim.b.branch_name = branch_cache[root][1] or "---"
end
M.get_branch_stats = function(root)
  if vim.fn.isdirectory(root) == 0 then
    return
  end
  if vim.b.branch_name == nil then
    return
  end
  local stats = get_stdout("git -C " .. root .. " status -b --porcelain")
  local lines = {}
  for line in string.gmatch(stats, "[^\n]+") do
    table.insert(lines, line)
  end
  local stage, unstage = 0, 0
  for i = 2, #lines do
    if string.find(string.sub(lines[i], 1, 1), "[MADRC]") then
      stage = stage + 1
    end
    if string.find(string.sub(lines[i], 1, 1), "[%sU]") then
      unstage = unstage + 1
    end
  end
  vim.b.branch_stats = { s = stage, u = unstage }
end
M.git_diff = function(path, mods, treeish)
  if vim.b.mug_branch_name == nil then
    return vim.notify("Not repository.No difference to compare.", 3, {})
  end

  local mods_ = mods == nil and { false, "" }
    or ({
      top = { false, "aboveleft" },
      bottom = { false, "belowright" },
      left = { true, "aboveleft" },
      right = { true, "belowright" },
    })[mods]

  local cwd = vim.fn.getcwd()
  local path_ = string.gsub(string.sub(vim.fn.resolve(vim.fn.expand(path)), #cwd + 2), "\\", "/")
  local treeish_ = (treeish and treeish ~= "") and treeish .. ":" or ":"
  local filename = treeish_ .. vim.fn.expand("%:t")
  local refs = treeish_ .. path_
  local contents = vim.fn.systemlist("git cat-file -p " .. refs)

  if #contents == 1 and string.find(contents[1], "fatal:", 1, true) then
    return vim.notify("No changes.", 3, {})
  end

  vim.api.nvim_cmd(
    { cmd = "new", args = { filename }, mods = { silent = true, vertical = mods_[1], split = mods_[2] } },
    {}
  )
  vim.api.nvim_buf_set_option(0, "buftype", "nofile")
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(0, "filetype", "diff")
  vim.fn.setline(1, contents)
  vim.api.nvim_command("windo diffthis|wincmd p")
end
return M
