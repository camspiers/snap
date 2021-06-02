local _2afile_2a = "fnl/snap/preview/get.fnl"
local snap = require("snap")
local snap_io = snap.get("io")
local function _1_(path)
  local handle = io.popen(string.format("file -n -b --mime-encoding %s", path))
  local encoding = string.gsub(handle:read("*a"), "^%s*(.-)%s*$", "%1")
  handle:close()
  local preview = nil
  if (encoding == "binary") then
    preview = {"Binary file"}
  else
    local databuffer = ""
    local reader = coroutine.create(snap_io.read)
    local function free(cancel)
      if cancel then
        cancel()
      end
      databuffer = ""
      reader = nil
      return nil
    end
    while (coroutine.status(reader) ~= "dead") do
      local _, cancel, data = coroutine.resume(reader, path)
      if (data ~= nil) then
        databuffer = (databuffer .. data)
      end
      local function _3_(...)
        return free(cancel, ...)
      end
      snap.continue(_3_)
    end
    preview = {}
    for line in databuffer:gmatch("([^\13\n]*)[\13\n]?") do
      table.insert(preview, line)
    end
    free()
  end
  return preview
end
return _1_