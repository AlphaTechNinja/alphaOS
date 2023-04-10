if not require then
io.stdout:write("a fatal error has accured please reboot")
end
local term = require("term")
local commands = require("settings").commands
local shell = {}
local function run(command,...)
if commands[command] then
return commands[command](...)
else
term.error("invalid command tryed to run command '%s' which does not exist":format(command))
end
end
shell.state = "stopped"
local cor
function shell.resume()
shell.state = "running"
coroutine.resume(cor)
end
function shell.pause()
shell.state = "stopped"
end
cor = coroutine.create(function ()
while true do
if shell.state == "stopped" then
coroutine.yield()
end
os.sleep()
local command = term.input()
local tokens = {}
for token in command:gmatch("[^%w]+") do
table.insert(tokens,token)
end
local result = {run(table.unpack(tokens))}
if result[1] ~= nil then
print(table.unpack(result))
end
end)

return shell

