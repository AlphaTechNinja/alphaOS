--handles loading everything
local loadfile = ...
function dofile(path)
local result = {pcall(loadfile(path))}
if not result[1] and result[2] then
error(path..":"..result[2])
else
return table.unpack(result)
end
end
require = dofile("lib/package.lua").require
--test
local io = require("io")
io.stderr:write("im a fart",2)