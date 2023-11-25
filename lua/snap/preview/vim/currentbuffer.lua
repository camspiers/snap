local _2afile_2a = "fnl/snap/preview/vim/currentbuffer.fnl"
local snap = require("snap")
local file = require("snap.preview.common.file")
local function _3_(_1_)
  local _arg_2_ = _1_
  local filename = _arg_2_["filename"]
  local line = _arg_2_["row"]
  local function _4_(...)
    return vim.fn.fnamemodify(filename, ":p", ...)
  end
  return {path = snap.sync(_4_), line = line, column = 1}
end
return file(_3_)