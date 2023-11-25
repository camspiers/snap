local _2afile_2a = "fnl/snap/preview/lsp.fnl"
local file = require("snap.preview.common.file")
local function _3_(_1_)
  local _arg_2_ = _1_
  local path = _arg_2_["filename"]
  local column = _arg_2_["col"]
  local line = _arg_2_["lnum"]
  return {path = path, column = column, line = line}
end
return file(_3_)