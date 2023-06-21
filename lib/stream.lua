--handles ios stderr, stdout and stdin
local stream = {}
function stream.new(onWrite,onRead)
local strm = {}
strm.onWrite = onWrite
strm.onRead = onRead
strm.buffer = ""
function strm.write(data)
if strm.onWrite then
return strm.onWrite(data)
else
strm.buffer = strm.buffer..data
end
end
function strm.read(pointer,size)
if strm.onRead then
return strm.onRead(pointer,size)
end
local newPos = pointer.pos + (size or 1)
local data = strm.buffer:sub(pointer.pos,newPos)
pointer.pos = newPos
return data
end
function strm.readAll()
return strm.buffer
end
function strm.clear()
strm.buffer = ""
end
function strm.readLine(pointer)
local lne = strm.buffer:sub(pointer.pos + 1,strm:len()):find("\n")
local data = strm.buffer:sub(pointer.pos,lne)
pointer.pos = lne
return data
end
return strm
end
return stream