local vector3 = {}
local props = {}
local get,set,eql = rawget,rawset,rawequal
function props.__ipairs(t,i)
return t[i]
end
function props.__index(t,k)

--return math.sqrt(self.x^2 + self.y^2 + self.z^2)
if get(t,k) then
return t[k]
elseif k == "mag" then
return math.sqrt(get(t,"x")^2 + get(t,"y")^2 + get(t,"z")^2)

else
error("try to get index "..k.." which does not exist",1)
end
end
function props.__tostring(a)
return "{"..a.x..","..a.y..","..a.z.."}"
end
--math
function props.__add(a,b)
if type(b) == "number" then
return vector3.new(a.x + b,a.y + b,a.z + b)
else
return vector3.new(a.x + b.x,a.y + b.y,a.z + b.z)
end
end
function props.__sub(a,b)
if type(b) == "number" then
return vector3.new(a.x - b,a.y - b,a.z - b)
else
return vector3.new(a.x - b.x,a.y - b.y,a.z - b.z)
end
end
function props.__mul(a,b)
if type(b) == "number" then
return vector3.new(a.x * b,a.y * b,a.z * b)
else
return vector3.new(a.x * b.x,a.y * b.y,a.z * b.z)
end
end
function props.__div(a,b)
if type(b) == "number" then
return vector3.new(a.x / b,a.y / b,a.z / b)
else
return vector3.new(a.x / b.x,a.y / b.y,a.z / b.z)
end
end
function props.__pow(a,b)
if type(b) == "number" then
return vector3.new(a.x^b,a.y^b,a.z^b)
else
return vector3.new(a.x^b.x,a.y^b.y,a.z^b.z)
end
end
function props.__unm(a)
return a * -1
end
--logic
function props.__eq(a,b)
if type(b) == "number" then
return eql(a.mag,b)
else
return eql(a,b)
end
end
function props.__lt(a,b)
if type(b) == "number" then
return a.mag < b
else
return a.mag < b.mag
end
end
function props.__le(a,b)
return a < b or a == b
end
function props.__gt(a,b)
if type(b) == "number" then
return a.mag > b
else
return a.mag > b.mag
end
end
function props.__ge(a,b)
return a > b or a == b
end
--etc
function props.__call(a,...)
return a.mag
end
--define
function vector3.set(o)
setmetatable(o,props)
return o
end
function vector3.new(px,py,pz)
local vector = {}
vector.x = px
vector.y = py
vector.z = pz
function vector:set(x,y,z)
vector = vector3.new(x,y,z)
end
function vector:abs()
return vector3.new(math.abs(self.x),math.abs(self.y),math.abs(self.z))
end
return vector3.set(vector)
end
function vector3.ensure(unknown)
if type(unknown) == "number" then
return vector3.new(unknown,unknown,unknown),false
else
return unknown,true
end
end
function vector3.distance(a,b)
return (a - b):abs().mag
end
function vector3.unit(a)
local total = a.x + a.y + a.z
return vector3.new(a.x / total,a.y / total,a.z / total)
end
local function angle(a,b)
return math.atan(a/b)
end
function vector3.angles(a)
return vector3.new(angle(a.x,a.y),angle(a.y,a.z),angle(a.z,a.x))
end
function vector3.todeg(a)
return vector3.new(math.deg(a.x),math.deg(a.y),math.deg(a.z))
end
function vector3.torad(a)
return vector3.new(math.rad(a.x),math.rad(a.y),math.rad(a.z))
end
--consts
vector3.huge = vector3.new(1,1,1) * math.huge
vector3.zero = vector3.new(0,0,0)
return setmetatable(vector3,{__setindex = function () error("try to write to a read only table",2) end})

--print(vector3.angles(vector3.new(1,90,1)))
