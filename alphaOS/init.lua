
local function boot_invoke(address, method, ...)
    local result = table.pack(pcall(component.invoke, address, method, ...))
    if not result[1] then
      return nil, result[2]
    else
      return table.unpack(result, 2, result.n)
    end
  end
--setup component
setmetatable(component,
{__index = function (t,k)
 return component.list(k)() 
end})
--boot file
do
  local addr, invoke = computer.getBootAddress(), component.invoke
  function loadfile(file)
    local handle = assert(invoke(addr, "open", file))
    local buffer = ""
    repeat
      local data = invoke(addr, "read", handle, math.maxinteger or math.huge)
      buffer = buffer .. (data or "")
    until not data
    invoke(addr, "close", handle)
    return load(buffer, "=" .. file, "bt", _G)
  end
end
--run boot
loadfile("boot.lua")(loadfile)