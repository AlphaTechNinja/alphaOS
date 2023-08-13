if _G.package then return _G.package end
package = {}
package.loaded = {}
package.loaded._G = _G
for n,v in pairs(_G) do
if type(v) == "table" then
package.loaded[n] = v
end
end
package.loaded.package = package
package.path = "/?.lua;/lib/?.lua;/bin/?.lua;/?.mod;/lib/?.mod"
--internal calls
local function segments(path)
local tab = {}
for segment in path:gmatch("[^/]+") do
table.insert(tab,segment)
end
return tab
end
local function getName(path)
local segs = segments(path)
return segs[#segs]:gsub("%.(%w)","")
end
local function getDict(path)
local segs = segments(path)
table.remove(segs)
return table.concat(segs,"/")
end
--main
function package.require(path)
local name = getName(path)
path = path:gsub("%.","/")
if package.loaded[name] then return package.loaded[name] end
if path == package.loading then
error("detected a recursive require",2)
end
package.loading = path
--look for a valid path
local errors = {}
local valid = "" 
for tpath in package.path:gmatch("[^;]+") do
if fs.exists(tpath:gsub("?",path)) then
valid = tpath:gsub("?",path)
break
else
table.insert(errors,("File not found in %s"):format(tpath:gsub("?",path)))
end
end
if valid == "" then return nil,"\n"..table.concat(errors,"\n") end
package.loaded[name] = dofile(valid)
package.loading = nil
return package.loaded[name]
end
--simple path api
function package.addCheck(path)
package.path = package.path..path
end
function package.setPath(path)
package.path = path
end
return setmetatable(package,{metadata = "package",sysFlag = true})