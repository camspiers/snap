local _2afile_2a = "fnl/snap/select/lsp.fnl"
local file = require("snap.select.common.file")
local select
local function _3_(_1_)
  local _arg_2_ = _1_
  local filename = _arg_2_["filename"]
  local line = _arg_2_["lnum"]
  local column = _arg_2_["col"]
  return {filename = filename, line = line, column = column}
end
select = file(_3_)
local function autoselect(_4_)
  local _arg_5_ = _4_
  local user_data = _arg_5_["user_data"]
  local offset_encoding = _arg_5_["offset_encoding"]
  return vim.lsp.util.jump_to_location(user_data, offset_encoding, true)
end
return {select = select, autoselect = autoselect}