local _2afile_2a = "fnl/snap/select/vimgrep.fnl"
local _2amodule_name_2a = "snap.select.vimgrep"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local parse = require("snap.common.vimgrep.parse")
local function multiselect(selections, winnr)
  vim.fn.setqflist(vim.tbl_map(parse, selections))
  vim.api.nvim_command("copen")
  return vim.api.nvim_command("cfirst")
end
_2amodule_2a["multiselect"] = multiselect
local function select(selection, winnr, type)
  local winnr0 = winnr
  local _let_1_ = parse(selection)
  local filename = _let_1_["filename"]
  local lnum = _let_1_["lnum"]
  local col = _let_1_["col"]
  local path = vim.fn.fnamemodify(filename, ":p")
  local buffer = vim.fn.bufnr(path, true)
  vim.api.nvim_buf_set_option(buffer, "buflisted", true)
  do
    local _2_ = type
    if (_2_ == nil) then
      if (winnr0 ~= false) then
        vim.api.nvim_win_set_buf(winnr0, buffer)
      else
      end
    elseif (_2_ == "vsplit") then
      vim.api.nvim_command("vsplit")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    elseif (_2_ == "split") then
      vim.api.nvim_command("split")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    elseif (_2_ == "tab") then
      vim.api.nvim_command("tabnew")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    else
    end
  end
  return vim.api.nvim_win_set_cursor(winnr0, {lnum, col})
end
_2amodule_2a["select"] = select
return _2amodule_2a