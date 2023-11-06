local _2afile_2a = "fnl/snap/common/buffer.fnl"
local _2amodule_name_2a = "snap.common.buffer"
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
local namespace = vim.api.nvim_create_namespace("snap.highlights")
local function set_lines(bufnr, start, _end, lines)
  return vim.api.nvim_buf_set_lines(bufnr, start, _end, false, lines)
end
_2amodule_2a["set-lines"] = set_lines
local function add_highlight(bufnr, hl, row, col_start, col_end)
  return vim.api.nvim_buf_add_highlight(bufnr, -1, hl, row, col_start, col_end)
end
_2amodule_2a["add-highlight"] = add_highlight
local function add_selected_highlight(bufnr, row)
  return vim.api.nvim_buf_add_highlight(bufnr, namespace, "SnapMultiSelect", (row - 1), 0, -1)
end
_2amodule_2a["add-selected-highlight"] = add_selected_highlight
local function add_positions_highlight(bufnr, row, positions)
  local line = (row - 1)
  for _, col in ipairs(positions) do
    add_highlight(bufnr, "SnapPosition", line, (col - 1), col)
  end
  return nil
end
_2amodule_2a["add-positions-highlight"] = add_positions_highlight
local function create()
  return vim.api.nvim_create_buf(false, true)
end
_2amodule_2a["create"] = create
local function delete(bufnr)
  return vim.api.nvim_buf_delete(bufnr, {force = true})
end
_2amodule_2a["delete"] = delete
return _2amodule_2a