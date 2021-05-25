local _2afile_2a = "fnl/snap/producer/ripgrep/vimgrep.fnl"
local general = require("snap.producer.ripgrep.general")
local function _1_(request)
  return general({"--vimgrep", "--hidden", request.filter}, request)
end
return _1_