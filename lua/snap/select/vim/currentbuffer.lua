local _2afile_2a = "fnl/snap/select/vim/currentbuffer.fnl"
local file = require("snap.select.common.file")
local function _3_(_1_)
  local _arg_2_ = _1_
  local filename = _arg_2_["filename"]
  local line = _arg_2_["row"]
  return {filename = filename, line = line}
end
return {select = file(_3_)}