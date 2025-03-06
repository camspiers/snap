local _2afile_2a = "fnl/snap/preview/common/read-file.fnl"
local snap = require("snap")
local snap_io = snap.get("common.io")
local function get_encoding(path)
  local handle = io.popen(string.format("file -n -b --mime-encoding '%s'", path))
  local encoding = string.gsub(handle:read("*a"), "^%s*(.-)%s*$", "%1")
  handle:close()
  return encoding
end
local max_size = (1024 * 500)
local function _1_(path, on_resume)
  local preview = nil
  if not snap_io.exists(path) then
    preview = {"File does not exist"}
  elseif (get_encoding(path) == "binary") then
    preview = {"Binary file"}
  elseif (snap_io.size(path) > max_size) then
    preview = {"File too large to preview"}
  else
    local databuffer = ""
    local reader = coroutine.create(snap_io.read)
    local function free(cancel)
      if cancel then
        cancel()
      else
      end
      databuffer = ""
      reader = nil
      return nil
    end
    while (coroutine.status(reader) ~= "dead") do
      if on_resume then
        on_resume()
      else
      end
      local _, cancel, data = coroutine.resume(reader, path)
      if (data ~= nil) then
        databuffer = (databuffer .. data)
      else
      end
      local function _5_(...)
        return free(cancel, ...)
      end
      snap.continue(_5_)
    end
    preview = {}
    for line in databuffer:gmatch("([^\13\n]*)(\13?\n?)") do
      if not ((line == "") and (__fnl_global___252 == "")) then
        table.insert(preview, line)
      else
      end
    end
    free()
  end
  return preview
end
return _1_