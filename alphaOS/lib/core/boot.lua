local raw_loadfile = ...
local error = raw_loadfile("lib/error.lua").error
local shell = raw_loadfile("lib/core/shell.lua").new()
function raw_dofile(file)
local result,err = pcall(raw_loadfile,file)
if not result and err then
error(err,2)
return
end
return result
end
raw_dofile("lib/load.lua")
shell.resume()
