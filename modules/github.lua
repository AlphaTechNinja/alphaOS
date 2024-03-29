--a simple github api
local github = {}
function github.getFile(user,repo,branch,path)
local fixed = string.format("raw.githubusercontent.com/%s/%s/%s/%s",user,repo,branch,path)
print(fixed)
if not http.checkURL(fixed) then
error("file does not exist")
end
return http.get(fixed).readAll()
end
function github.sort(objects)
local folders = {}
local files = {}
for i,v in ipairs(objects) do
if v.mode == "100644" then
table.insert(files,v.path)
else
table.insert(folders,v.path)
end
end
return files,folders
end
function github.getFiles(user,repo,branch)
local json = http.get(("https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1"):format(user,repo,branch)).readAll()
json = textutils.unserializeJSON(json)
local files = github.sort(json.tree)
return files
end
--[[
function github.sortTree(files,folders)
local paths = {}
local function getPath(tab,path)
local new = tab
local fixed = {}
for s in path:gmatch("[^/]+") do
table.insert(fixed,s)
end
for i,v in ipairs(fixed) do
new = new[v]
end
return new
end
--intalise paths
for i,v in ipairs(folders) do
local last = ""
for segment in v:gmatch("[^/]+") do
last = last..segment
if not getPath(paths,last) then
rawset(getPath(paths,last),{})
end
end
end
for  i,v in ipairs(files) do
local segments = {}
for segment in v:gmatch("[^/]+") do
table.insert(segments,segment)
end
end
return paths
end
--]]
--installer uses
function github.copyRepo(dest,user,repo,branch)
for i,v in ipairs(github.getFiles(user,repo,branch)) do
print(repo.."/"..v.."->"..fs.combine(dest,v))
end
end
function github.listBranches(user,repo)
local request = http.get(("https://api.github.com/repos/%s/%s/branches"):format(user,repo)).readAll()
local data = textutils.unserializeJSON(request)
local names = {}
for i,v in ipairs(data) do
table.insert(names,v.name)
end
return names
end
--test
--github.copyRepo("wip/","AlphaTechNinja","wip-Coding","main")
return github
