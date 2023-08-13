--handles files
local component = require("component")
local filesystem = component.filesystem
local fs = {}
fs.mounts = {}
function fs.open(path,mode)
    local file = setmetatable(file,{metadata = "fs.file"})
    file._handle = filesystem.open(path,mode)
    function file.read(length)
        return filesystem.read(file._handle,length or 1)
    end
    function file.write(byte)
        return filesystem.write(file._handle,byte)
    end
    function file.close()
        return filesystem.close(file._handle)
    end
    function file.readAll()
        local buffer = ""
        repeat
            local data = file.read(math.huge)
            buffer = buffer..(data or "")
        until not data
        return buffer
    end
    function file.readLine()
        local buffer = ""
        repeat
            local data = file.read()
            if data ~= "\n" then
                buffer = buffer..("" or data)
            end
        until data == "\n" or not data
        return buffer
    end
    function file.seek(whence,offset)
        return filesystem.seek(file._handle,whence,offset)
    end
    return file
end
--standared file system functions
function fs.segment(path)
    local segs = {}
    for seg in path:gmatch("[^/]+") do
        table.insert(segs,seg)
    end
    return segs
end
function fs.absoulutePath(path)
    local stepped = {}
    local system = filesystem
    for i,step in ipairs(fs.segment(path)) do
        if step == ".." then
            table.remove(stepped)
        else
            for i,v in ipairs(fs.mounts) do
                if v[2] == step then
                    
            table.insert(stepped,step)
        end
    end
    return table.concat(stepped,"/"),system
end
function fs.getName(path)
    local segs = fs.segment(path)
    return segs[#segs]
end
function fs.getPath(path)
    local segs = fs.segment(path)
    table.remove(segs)
    return table.concat(segs,"/").."/"
end
function fs.getParts(path)
    local pathTo = fs.absoulutePath(path)
    local fileName = fs.getName(path)
    local name,extension = fileName:find("(%w+)%.(%w+)")
    return name,extension
end
        
function fs.exists(path)
    return filesytem.exists(fs.absoulutePath(path))
end
function fs.realPath(link)
    local pathTo = fs.absoulutePath(link)
    local name,extension = fs.getParts(pathTo)
    if fs.exists(path) and extension == "lnk" then
        local file = fs.open(pathTo)
        local data = file.readAll()
        file.close()
        return data
    else
        return pathTo
    end
end
function fs.isDir(path)
    return filesystem.isDirectory(fs.absoulutePath(path))
end
function fs.list(path)
    return filesystem.list(fs.absoulutePath(path))
end
function fs.move(from,to)
    local absFrom = fs.absoulutePath(from)
    local absTo = fs.absoulutePath(to)
    local name = fs.getName(absFrom)
    filesystem.rename(absFrom,fs.absoulutePath(absTo.."/"..name))
end
function fs.copy(from,to)
    local file = fs.open(from,"r")
    local data = file.readAll()
    file.close()
    local dest = fs.open(to,"w")
    dest.write(data)
    dest.close()
end
function fs.rename(path,newName)
    local oldPath = fs.getPath(path)
    filesystem.rename(path,oldPath..newName)
end
function fs.mkdir(path)
    return filesystem.makeDirectory(path)
end
function fs.rm(path)
    return filesystem.remove(path)
end
function fs.size(path)
    return filesystem.size(path)
end
function fs.lastModified(path)
    return filesystem.lastModified(path)
end
function fs.mount(filesys,path)
    table.insert(fs.mounts,setmetatable({filesys,path},{metadata = "fs.mount"}))
end
function fs.unmount(unkown)
    if type(unkown) == "string" then
        for i,v in ipairs(fs.mounts) do
            if v[2] == unkown then
                table.remove(fs.mounts,i)
                return true
            end
        end
    else
        for i,v in ipairs(fs.mounts) do
            if v[1] == unkown then
                table.remove(fs.mounts,i)
                return true
            end
        end
    end
    return false
end
return setmetatable(fs,{metadata = "fs"})