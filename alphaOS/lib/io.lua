--the in out system
local streams = require("stream")
local graphics = require("graphics")
local gpu = grpahics.gpu
local io = {}
io.stdout = stream.new()
io.stdin = stream.new()
io.stderr = stream.new()
--bind functions to streams
function io.stderr.onWrite(msg,level)
local w,h = gpu.getResolution()
if level == 2 then
gpu.setForeground(0xFFFFFF)
gpu.setBackfround(0x0000FF)
gpu.fill(1,1,w,h," ")
gpu.set((w / 2) - 14,(h / 2) - 1,"error detected")
graphics.write(math.min(1,(w / 2) - msg:len()),h / 2,msg,true)
end
end
return io