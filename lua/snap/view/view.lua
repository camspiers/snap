local _2afile_2a = "fnl/snap/view/view.fnl"
local _0_
do
  local name_0_ = "snap.view.view"
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
    return {require("snap.common.buffer"), require("snap.common.register"), require("snap.view.size"), require("snap.common.tbl"), require("snap.common.window")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {buffer = "snap.common.buffer", register = "snap.common.register", size = "snap.view.size", tbl = "snap.common.tbl", window = "snap.common.window"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local buffer = _local_0_[1]
local register = _local_0_[2]
local size = _local_0_[3]
local tbl = _local_0_[4]
local window = _local_0_[5]
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.view.view"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local function layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local index = (config.index - 1)
  local border = (index * size.border)
  local padding = (index * size.padding)
  local total_borders = ((config["total-views"] - 1) * size.border)
  local total_paddings = ((config["total-views"] - 1) * size.padding)
  local sizes = tbl.allocate((height - total_borders - total_paddings), config["total-views"])
  local height0 = sizes[config.index]
  local col_offset = math.floor((width * size["view-width"]))
  return {col = (col + col_offset + (size.border * 2) + size.padding), focusable = false, height = height0, row = (row + tbl.sum(tbl.take(sizes, index)) + border + padding), width = (width - col_offset - size.padding - size.padding - size.border)}
end
local create
do
  local v_0_
  do
    local v_0_0
    local function create0(config)
      local bufnr = buffer.create()
      local layout_config = layout(config)
      local winnr = window.create(bufnr, layout_config)
      vim.api.nvim_win_set_option(winnr, "cursorline", false)
      vim.api.nvim_win_set_option(winnr, "cursorcolumn", false)
      vim.api.nvim_win_set_option(winnr, "wrap", false)
      vim.api.nvim_win_set_option(winnr, "winhl", "Normal:SnapNormal,FloatBorder:SnapBorder")
      local function delete()
        if vim.api.nvim_win_is_valid(winnr) then
          window.close(winnr)
        end
        if vim.api.nvim_buf_is_valid(bufnr) then
          return buffer.delete(bufnr, {force = true})
        end
      end
      local function update(view)
        if vim.api.nvim_win_is_valid(winnr) then
          local layout_config0 = layout(config)
          window.update(winnr, layout_config0)
          vim.api.nvim_win_set_option(winnr, "cursorline", true)
          do end (view)["height"] = layout_config0.height
          view["width"] = layout_config0.width
          return nil
        end
      end
      local view = {bufnr = bufnr, delete = delete, height = layout_config.height, update = update, width = layout_config.width, winnr = winnr}
      vim.api.nvim_command("augroup SnapViewResize")
      vim.api.nvim_command("autocmd!")
      local function _3_()
        return view:update()
      end
      vim.api.nvim_command(string.format("autocmd VimResized * %s", register["get-autocmd-call"]("VimResized", _3_)))
      vim.api.nvim_command("augroup END")
      return view
    end
    v_0_0 = create0
    _0_["create"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["create"] = v_0_
  create = v_0_
end
return nil