--handles doing require
local package = {}
package.loaded = {}
package.loaded["_G"] = _G
package.loaded["string"] = string
package.loaded["bit32"] = bit32
package.loaded["coroutine"] = coroutine
package.loaded["debug"] = debug
package.loaded["math"] = math
package.loaded["os"] = os
package.loaded["component"] = component
package.loaded["computer"] = computer
package.loaded["unicode"] = unicode
package.loaded["table"] = table
package.loaded["package"] = package
package.path = "/?.lua;/lib/?.lua;/lib/core/?.lua"
--main
local function getName(path)
local segments = {}
for seg in path:gmatch("[^/]+") do
segments[#segments + 1] = seg
end
return table.remove(segments):gsub("%.(%w)","")
end
function package.require(name)
if package.loaded[getName(name:gsub(".","/"))] then return package.loaded[getName(name:gsub(".","/"))] end
local paths = {}
for path in package.path:gmatch("[^;]+") do
table.insert(paths,path:gsub("?",name:gsub(".","/")))
end
for i,v in ipairs(paths) do
if component.filesystem.exists(v) then
package.loaded[getName(name)] = dofile(v)
return package.loaded[getName(name)]
end
end
error(("couldn't find %s in "..table.concat(paths," or ")):format(name:gsub(".","/")))
end
return package