local _2afile_2a = "fnl/snap/preview/grep.fnl"
local snap = require("snap")
local file = require("snap.preview.common.file")
local parse = require("snap.common.grep.parse")
local function _1_(selection)
  local _local_2_ = parse(tostring(selection))
  local filename = _local_2_["filename"]
  local line = _local_2_["lnum"]
  local function _3_(...)
    return vim.fn.fnamemodify(filename, ":p", ...)
  end
  return {path = snap.sync(_3_), line = line, column = 0}
end
return file(_1_)