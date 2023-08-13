--the in out system
local streams = require("stream")
local term = require("term")
local fs = require("fs")
local keys = require("keyboard")
local io = {}
io.std = stream.new()
io.stderr = stream.new()
io._open = io.stdout
local natives = {io.stdout,io.stdin,io.stderr,io.stdout}
--bind functions to streams
function io.stderr.onWrite(msg)
    term.setTextColor(0xFF0000)
    term.print(msg)
end
function io.std.onWrite(text)
    term.setTextColor(0xFFFFFF)
    term.print(text)
end
function io.open(path,mode)
    io._open = fs.open(path,mode or "r")
    function io._open:lines()
        local data = self.readAll()
        local lines = {}
        for line in data:gmatch("[^\n]+") do
            table.insert(lines,line)
        end
        self.close()
        local place = 0
        return setmetatable(lines,{__call = function (t,...)
                    place = place + 1
                    return lines[place]
                end
                })
    end
    local oldClose = io._open.close
    function io._open.close()
        oldClose()
        io._open = io.std
    end
    io.write = io._open.write or io._open.onWrite
    io.read = io._open.read or io._open.onRead
    return io._open
end
function io.close()
    io._open.close()
end
--the hardest function for std
function io.std.onRead()
    local x,y = term.getCursor()
    keys.setBlink(true)
    local buffer = ""
    repeat
        if keys.check() then
            buffer = buffer..(keys.getChar() or "")
            term.setCursor(x,y)
            term.write(buffer)
        end
        if keys.getName() == "backspace" then
            buffer = buffer:sub(1,-2)
            term.backspace()
        end
        local isEntered = keys.isDown("enter")
        keys.cycle()
        sleep(0.1)
    until isEntered
    keys.setBlink(false)
    return buffer
end
return setmetatable(io,{metadata = "io"})