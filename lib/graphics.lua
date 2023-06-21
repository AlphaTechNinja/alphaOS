--handles graphics
local gpu = component.gpu
local w,h = gpu.getResolution()
local graphics = {}
graphics.gpu = gpu
function graphics.wordWrap(str,w,offset)
local lines = {}
--wrap string around overrun
local run = offset or 1
local line = ""
for char in str:gmatch(".") do
if run > w then
run = run - w
table.insert(lines,line)
line = ""
end
if char == "\n" then
run = w
else
line = line..char
end
run = run + 1
end
if line ~= "" then table.insert(lines,line) end
return lines
end
--main
function graphics.write(x,y,str,wrap)
local lines = {str}
if wrap then
lines = graphics.wordWrap(str,w,x)
end
for i,v in ipairs(lines) do
if i == 1 then
gpu.set(x,y,v)
else
gpu.set(1,y + i - 1,v)
end
end
end
return graphics