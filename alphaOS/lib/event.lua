--used to make events
local events = {}
events.listeners = {}
--main
events.push = computer.pushSignal
function events.stepListeners(event)
    for i,v in ipairs(events.listeners) do
        if v.e == event[1] or v.e == "*" then
            v.c(unpack(event))
        end
    end
end
function events.pull(filter,timout)
if not filter then return computer.pullSignal() end
local deadline = computer.uptime() + (timeout or math.huge)
while computer.uptime() < deadline do
local result = {computer.pullSignal()}
events.stepListeners(result)
if result[1] == filter then return table.unpack(result) end
end
return nil,"timed out"
end
function os.sleep(time)
    local deadline = computer.uptime() + time
    while computer.uptime() < deadline do
        events.stepListeners({computer.pullSignal(0.05)})
    end
    return computer.uptime() - deadline
end
function events.attachListener(event,callback)
    local l = setmetatable({},{metadata = "events.listener"})
    if event and callback then
        l.e,l.c = event,callback
    else
        l.e,l.c = "*",event
    end
    table.insert(events.listeners,l)
    return l
end
function events.detachListener(obj)
    assert(typeof(obj) == "events.listener","must be a event listener")
    for i,listener in ipairs(events.listeners) do
        if obj == listener then
            table.remove(events.listeners,i)
        end
    end
end
return setmetatable(events,{metadata = "events"})