local _2afile_2a = "fnl/snap/select/vim/mark.fnl"
local _2amodule_name_2a = "snap.select.vim.mark"
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
local function select(selection, winnr, type)
  local winnr0 = winnr
  local path = vim.fn.fnamemodify(selection.file, ":p")
  local buffer = vim.fn.bufnr(path, true)
  vim.api.nvim_buf_set_option(buffer, "buflisted", true)
  do
    local _1_ = type
    if (_1_ == nil) then
      if (winnr0 ~= false) then
        vim.api.nvim_win_set_buf(winnr0, buffer)
      else
      end
    elseif (_1_ == "vsplit") then
      vim.api.nvim_command("vsplit")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    elseif (_1_ == "split") then
      vim.api.nvim_command("split")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    elseif (_1_ == "tab") then
      vim.api.nvim_command("tabnew")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    else
    end
  end
  return vim.api.nvim_win_set_cursor(winnr0, {selection.pos[2], selection.pos[3]})
end
_2amodule_2a["select"] = select
return _2amodule_2a