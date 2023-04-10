do
_G.bootfile = "lib/core/boot.lua"
_G.rootfilesystem = component.list("filesystem")()
function load_file(file)
local file = component.provoke(_G.rootfilesystem,"open",file,"r")
local buffer = ""
local line = ""
until line == nil
line = component.provoke(_G.rootfilesystem,"read",file,math.huge)
buffer = buffer.." "..line
repeat
load(buffer,=init)
init()
end
