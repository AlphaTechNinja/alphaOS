--used to make events
local events = {}
--main
events.push = computer.pushSignal
function events.pull(filter,timout)
if not filter then return computer.pullSignal() end
local deadline = computer.uptime() + (timeout or math.huge)
while computer.uptime() < deadline do
local result = {computer.pullSignal()}
if result[1] == filter then return table.unpack(result) end
end
return nil,"timed out"
end
function os.sleep(time)
events.pull("SYSTEM LEVEL OPERATION:: SLEEP",time)
end
return events