local _2afile_2a = "fnl/snap/view/results.fnl"
local _2amodule_name_2a = "snap.view.results"
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
local buffer, register, size, window = require("snap.common.buffer"), require("snap.common.register"), require("snap.view.size"), require("snap.common.window")
do end (_2amodule_locals_2a)["buffer"] = buffer
_2amodule_locals_2a["register"] = register
_2amodule_locals_2a["size"] = size
_2amodule_locals_2a["window"] = window
local group = vim.api.nvim_create_augroup("SnapResults", {clear = true})
local function layout(config)
  local _let_1_ = config.layout()
  local width = _let_1_["width"]
  local height = _let_1_["height"]
  local row = _let_1_["row"]
  local col = _let_1_["col"]
  local _2_
  if config["has-views"]() then
    _2_ = (math.floor((width * size["view-width"])) - size.padding - size.padding)
  else
    _2_ = width
  end
  local _4_
  if config.reverse then
    _4_ = (row + size.border + size.padding + size.padding)
  else
    _4_ = row
  end
  return {width = _2_, height = (height - size.border - size.border - size.padding), title = "Results", row = _4_, col = col, focusable = false}
end
local function create(config)
  local bufnr = buffer.create()
  local layout_config = layout(config)
  local winnr = window.create(bufnr, layout_config)
  vim.api.nvim_set_option_value("buftype", "prompt", {buf = bufnr})
  vim.api.nvim_set_option_value("textwidth", 0, {buf = bufnr})
  vim.api.nvim_set_option_value("wrapmargin", 0, {buf = bufnr})
  vim.api.nvim_set_option_value("wrap", false, {win = winnr})
  vim.api.nvim_set_option_value("cursorline", true, {win = winnr})
  vim.api.nvim_set_option_value("winhl", "CursorLine:SnapSelect,Normal:SnapNormal,FloatBorder:SnapBorder", {win = winnr})
  local function delete()
    if vim.api.nvim_win_is_valid(winnr) then
      window.close(winnr)
    else
    end
    if vim.api.nvim_buf_is_valid(bufnr) then
      return buffer.delete(bufnr)
    else
      return nil
    end
  end
  local function update(view)
    if vim.api.nvim_win_is_valid(winnr) then
      local layout_config0 = layout(config)
      window.update(winnr, layout_config0)
      vim.api.nvim_set_option_value("cursorline", true, {win = winnr})
      do end (view)["height"] = layout_config0.height
      view["width"] = layout_config0.width
      return nil
    else
      return nil
    end
  end
  local view = {update = update, delete = delete, bufnr = bufnr, winnr = winnr, width = layout_config.width, height = layout_config.height}
  local function _9_()
    return view:update()
  end
  vim.api.nvim_create_autocmd("VimResized", {group = group, callback = _9_})
  return view
end
_2amodule_2a["create"] = create
return _2amodule_2a