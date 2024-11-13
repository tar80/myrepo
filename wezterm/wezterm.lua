local Config = require('config')
require('events')

local color_scheme = 'MaterialDarker'
local default_directory = 'C:/bin/repository/ppmdev'
local profiles = {
  'general',
  'bindings',
}

return Config.init(color_scheme, default_directory, profiles)
