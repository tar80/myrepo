local M = {}

local SCOOP = os.getenv('scoop'):gsub('\\', '/')

M.scoop_apps = function(name, dir)
  if not dir then
    dir = name
  end
  return string.format('%s/apps/%s/current/%s.exe', SCOOP, dir, name)
end

return M
