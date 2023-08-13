--Allows multiple screen frames
local component = require("component")
local gpu = component.gpu
--tools
local function box(width,height,fill)
    local created = {}
    for y=1,height do
        created[y] = {}
        for x=1,width do
            created[y][x] = fill
        end
    end
    return created
end
--main
local multi = {}
multi.frames = {}
function multi.new(x,y,w,h)
    local frame = setmetatable({},{metadata = "multi.frame"})
    frame.x,frame.y,frame.w,frame.h = x,y,w,h
    frame.bg = {}
    frame.fg = {}
    frame.chars = {}
    frame._compat = {_bg = 0,_fg = 0xFFFFFF}
    function frame:init()
        self.bg = box(self.w,self.h,0)
        self.fg = box(self.w,self.h,0)
        self.chars = box(self.w,self.h," ")
    end
    function frame:_set(x,y,bg,fg,char)
        assert(type(x) == "number","x must be a number")
        assert(type(y) == "number","y must be a number")
        assert(type(char) == "string" and char:len() == 1,"char must be a single charactor string")
        self.bg[y][x] = math.floor(bg)
        self.fg[y][x] = math.floor(fg)
        self.chars[y][x] = char
    end
    --contains almost every GPU function
    function frame.getBackground()
        return frame._compat._bg
    end
    function frame.setBackground(color)
        assert(type(color) == "number","color must be a number")
        frame._compat._bg = math.floor(color)
    end
    function frame.getForeground()
        return frame._compat._fg
    end
    function frame.setForeground(color)
        assert(type(color) == "number","color must be a number")
        frame._compat._fg = math.floor(color)
    end
    function frame.maxDepth()
        return gpu.maxDepth()
    end
    function frame.getDepth()
        return gpu.getDepth()
    end
    function frame.maxResolution()
        return gpu.maxResolution()
    end
    function frame.getResolution()
        return frame.w,frame.h
    end
    function frame.setResolution(width,height)
        frame.w,frame.h = width,height
        frame:init()
    end
    function frame.getAspectRatio()
        return frame.w,frame.h
    end
    function frame.get(x,y)
        return frame.chars[y][x],frame.bg[y][x],frame.fg[y][x]
    end
    function frame.set(x,y,str,vert)
        local i = 0
        for char in str:gmatch(".") do
            if not vert then
                frame:_set(x + i,y,frame._compat._bg,frame._compat._fg,char)
            else
                frame:_set(x,y + i,frame._compat._bg,frame._compat._fg,char)
            end
            i = i + 1
        end
    end
    function frame.copy(fx,fy,w,h,tx,ty)
        for x=1,w do
            for y=1,h do
                frame:_set(tx + x - 1,ty + y - 1,frame.bg[y + fy - 1][x + fx - 1],frame.fg[y + fy - 1][x + fx - 1],frame.chars[y + fy - 1][x + fx - 1])
            end
        end
    end
    function frame.fill(x,y,w,h,char)
        for px=x,x + w do
            for py=y,y + h do
                frame:_set(px,py,frame._compat._bg,frame._compat._fg,char)
            end
        end
    end
    --draw and remove
    function frame:flush()
        for y,col in ipairs(self.chars) do
            for x,char in ipairs(col) do
                local bg = self.bg[y][x]
                local fg = self.fg[y][x]
                gpu.setBackground(bg)
                gpu.setForeground(fg)
                gpu.fill(x,y,1,1,char)
            end
        end
    end
    function frame:remove()
        for i,frm in ipairs(multi.frames) do
            if frm == self then
                table.remove(multi.frames,i)
            end
        end
    end
    table.insert(multi.frames,frame)
    return frame
end
function multi:render()
    for i,v in ipairs(self.frames) do
        v:flush()
    end
end
return setmetatable(multi,{metadata = "multi"})