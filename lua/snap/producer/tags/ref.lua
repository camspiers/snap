local _2afile_2a = "fnl/snap/producer/tags/ref.fnl"
local snap = require("snap")
local general = snap.get("producer.tags.general")
local function _1_(request)
  return general(request, {args = {"-r", request.filter}})
end
return _1_