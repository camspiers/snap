local _2afile_2a = "fnl/snap/view/input.fnl"
local _2amodule_name_2a = "snap.view.input"
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
local buffer, register, size, tbl, window = require("snap.common.buffer"), require("snap.common.register"), require("snap.view.size"), require("snap.common.tbl"), require("snap.common.window")
do end (_2amodule_locals_2a)["buffer"] = buffer
_2amodule_locals_2a["register"] = register
_2amodule_locals_2a["size"] = size
_2amodule_locals_2a["tbl"] = tbl
_2amodule_locals_2a["window"] = window
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
    _4_ = row
  else
    _4_ = ((row + height) - size.padding)
  end
  return {width = _2_, height = 1, row = _4_, col = col, focusable = true, enter = true}
end
local mappings = {next = {"<C-q>"}, enter = {"<CR>"}, ["enter-split"] = {"<C-x>"}, ["enter-vsplit"] = {"<C-v>"}, ["enter-tab"] = {"<C-t>"}, exit = {"<Esc>", "<C-c>"}, select = {"<Tab>"}, unselect = {"<S-Tab>"}, ["select-all"] = {"<C-a>"}, ["prev-item"] = {"<C-p>", "<Up>", "<C-k>"}, ["next-item"] = {"<C-n>", "<Down>", "<C-j>"}, ["prev-page"] = {"<C-b>", "<PageUp>"}, ["next-page"] = {"<C-f>", "<PageDown"}, ["view-page-down"] = {"<C-d>"}, ["view-page-up"] = {"<C-u>"}, ["view-toggle-hide"] = {"<C-h>"}}
local group = vim.api.nvim_create_augroup("SnapInput", {clear = true})
local function create(config)
  local bufnr = buffer.create()
  local layout_config = layout(config)
  local winnr = window.create(bufnr, layout_config)
  vim.api.nvim_set_option_value("winhl", "Search:None,Normal:SnapNormal,FloatBorder:SnapBorder", {win = winnr})
  vim.api.nvim_set_option_value("buftype", "prompt", {buf = bufnr})
  vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = bufnr})
  buffer["add-highlight"](bufnr, "SnapPrompt", 0, 0, string.len(config.prompt))
  vim.fn.prompt_setprompt(bufnr, config.prompt)
  vim.api.nvim_command("startinsert")
  local mappings0
  if config.mappings then
    mappings0 = tbl.merge(mappings, config.mappings)
  else
    mappings0 = mappings
  end
  local function get_filter()
    local contents = tbl.first(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false))
    if contents then
      return contents:sub((#config.prompt + 1))
    else
      return ""
    end
  end
  local exited = false
  local function on_exit()
    if not exited then
      exited = true
      return config["on-exit"]()
    else
      return nil
    end
  end
  local function on_enter(type)
    config["on-enter"](type)
    return on_exit()
  end
  local function on_next()
    config["on-next"]()
    return on_exit()
  end
  local function on_tab()
    config["on-select-toggle"]()
    return config["on-next-item"]()
  end
  local function on_shifttab()
    config["on-select-toggle"]()
    return config["on-prev-item"]()
  end
  local function on_ctrla()
    return config["on-select-all-toggle"]()
  end
  local function on_lines()
    config["on-update"](get_filter())
    return nil
  end
  local function on_detach()
    return nil
  end
  register["buf-map"](bufnr, {"n", "i"}, mappings0.next, on_next)
  register["buf-map"](bufnr, {"n", "i"}, mappings0.enter, on_enter)
  local function _9_(...)
    return on_enter("split", ...)
  end
  register["buf-map"](bufnr, {"n", "i"}, mappings0["enter-split"], _9_)
  local function _10_(...)
    return on_enter("vsplit", ...)
  end
  register["buf-map"](bufnr, {"n", "i"}, mappings0["enter-vsplit"], _10_)
  local function _11_(...)
    return on_enter("tab", ...)
  end
  register["buf-map"](bufnr, {"n", "i"}, mappings0["enter-tab"], _11_)
  register["buf-map"](bufnr, {"n", "i"}, mappings0.exit, on_exit)
  register["buf-map"](bufnr, {"n", "i"}, mappings0.select, on_tab)
  register["buf-map"](bufnr, {"n", "i"}, mappings0.unselect, on_shifttab)
  register["buf-map"](bufnr, {"n", "i"}, mappings0["select-all"], on_ctrla)
  register["buf-map"](bufnr, {"n", "i"}, mappings0["prev-item"], config["on-prev-item"])
  register["buf-map"](bufnr, {"n", "i"}, mappings0["next-item"], config["on-next-item"])
  register["buf-map"](bufnr, {"n", "i"}, mappings0["prev-page"], config["on-prev-page"])
  register["buf-map"](bufnr, {"n", "i"}, mappings0["next-page"], config["on-next-page"])
  register["buf-map"](bufnr, {"n", "i"}, mappings0["view-page-down"], config["on-viewpagedown"])
  register["buf-map"](bufnr, {"n", "i"}, mappings0["view-page-up"], config["on-viewpageup"])
  register["buf-map"](bufnr, {"n", "i"}, mappings0["view-toggle-hide"], config["on-view-toggle-hide"])
  vim.api.nvim_create_autocmd({"WinLeave", "BufLeave", "BufDelete"}, {group = group, buffer = bufnr, once = true, callback = on_exit})
  vim.api.nvim_buf_attach(bufnr, false, {on_lines = on_lines, on_detach = on_detach})
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
  local function _15_()
    return view:update()
  end
  vim.api.nvim_create_autocmd("VimResized", {group = group, callback = _15_})
  return view
end
_2amodule_2a["create"] = create
return _2amodule_2a