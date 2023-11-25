local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local file = require("snap.preview.common.file")
local function _1_(selection)
  local function _3_()
    local _2_ = tostring(selection)
    local function _4_(...)
      return vim.fn.fnamemodify(_2_, ":p", ...)
    end
    return _4_
  end
  return {path = snap.sync(_3_()), line = nil, column = nil}
end
return file(_1_)