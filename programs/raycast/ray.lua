function mo.sphere(p,d,s)
local m = p - s.c
local b = dot(m,d)
local c = dot(m,m) - s.r^2

if c > 0 and b > 0 then return nil end

discr = b^2 - c

if discr < 0 then return nil end

local t = -b - math.sqrt(discr)

if t < 0 then t = 0 end
local q = p + t * b

return t,q,q - s.c
end
