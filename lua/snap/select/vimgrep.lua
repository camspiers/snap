local _2afile_2a = "fnl/snap/select/vimgrep.fnl"
local parse = require("snap.common.vimgrep.parse")
local file = require("snap.select.common.file")
local function multiselect(selections, winnr)
  vim.fn.setqflist(vim.tbl_map(parse, selections))
  vim.api.nvim_command("copen")
  return vim.api.nvim_command("cfirst")
end
local select
local function _1_(selection)
  local _local_2_ = parse(selection)
  local filename = _local_2_["filename"]
  local line = _local_2_["lnum"]
  local column = _local_2_["col"]
  return {filename = filename, line = line, column = column}
end
select = file(_1_)
return {select = select, multiselect = multiselect}