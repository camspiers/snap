local _2afile_2a = "fnl/snap/common/buffer.fnl"
local _0_
do
  local name_0_ = "snap.common.buffer"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.common.buffer"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local namespace = vim.api.nvim_create_namespace("Snap")
local set_lines
do
  local v_0_
  do
    local v_0_0
    local function set_lines0(bufnr, start, _end, lines)
      return vim.api.nvim_buf_set_lines(bufnr, start, _end, false, lines)
    end
    v_0_0 = set_lines0
    _0_["set-lines"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["set-lines"] = v_0_
  set_lines = v_0_
end
local add_highlight
do
  local v_0_
  do
    local v_0_0
    local function add_highlight0(bufnr, hl, row, col_start, col_end)
      return vim.api.nvim_buf_add_highlight(bufnr, namespace, hl, row, col_start, col_end)
    end
    v_0_0 = add_highlight0
    _0_["add-highlight"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["add-highlight"] = v_0_
  add_highlight = v_0_
end
local add_selected_highlight
do
  local v_0_
  do
    local v_0_0
    local function add_selected_highlight0(bufnr, row)
      return vim.api.nvim_buf_add_highlight(bufnr, namespace, "SnapMultiSelect", (row - 1), 0, -1)
    end
    v_0_0 = add_selected_highlight0
    _0_["add-selected-highlight"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["add-selected-highlight"] = v_0_
  add_selected_highlight = v_0_
end
local add_positions_highlight
do
  local v_0_
  do
    local v_0_0
    local function add_positions_highlight0(bufnr, row, positions, offset)
      local line = (row - 1)
      for _, col in ipairs(positions) do
        add_highlight(bufnr, "SnapPosition", line, ((col - 1) + offset), (col + offset))
      end
      return nil
    end
    v_0_0 = add_positions_highlight0
    _0_["add-positions-highlight"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["add-positions-highlight"] = v_0_
  add_positions_highlight = v_0_
end
local create
do
  local v_0_
  do
    local v_0_0
    local function create0()
      return vim.api.nvim_create_buf(false, true)
    end
    v_0_0 = create0
    _0_["create"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["create"] = v_0_
  create = v_0_
end
local delete
do
  local v_0_
  do
    local v_0_0
    local function delete0(bufnr)
      return vim.api.nvim_buf_delete(bufnr, {force = true})
    end
    v_0_0 = delete0
    _0_["delete"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["delete"] = v_0_
  delete = v_0_
end
return nil