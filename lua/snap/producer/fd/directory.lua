local _2afile_2a = "fnl/snap/producer/fd/directory.fnl"
local snap = require("snap")
local general = snap.get("producer.fd.general")
local function _1_(request)
  return general({"-H", "-I", "-t", "d"}, request)
end
return _1_