local _2afile_2a = "fnl/snap/view/input.fnl"
local _0_
do
  local name_0_ = "snap.view.input"
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
local _2amodule_name_2a = "snap.view.input"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local function layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local _3_
  if config["has-views"]() then
    _3_ = math.floor((width * size["view-width"]))
  else
    _3_ = width
  end
  return {col = col, focusable = true, height = 1, row = ((row + height) - size.padding), width = _3_}
end
local mappings = {["enter-split"] = {"<C-x>"}, ["enter-tab"] = {"<C-t>"}, ["enter-vsplit"] = {"<C-v>"}, ["next-item"] = {"<C-n>"}, ["next-page"] = {"<C-f>"}, ["prev-item"] = {"<C-p>"}, ["prev-page"] = {"<C-b>"}, ["select-all"] = {"<C-a>"}, ["view-page-down"] = {"<C-d>"}, ["view-page-up"] = {"<C-u>"}, ["view-toggle-hide"] = {"<C-h>"}, enter = {"<CR>"}, exit = {"<Esc>", "<C-c>"}, next = {"<C-q>"}, select = {"<Tab>"}, unselect = {"<S-Tab>"}}
local create
do
  local v_0_
  do
    local v_0_0
    local function create0(config)
      local bufnr = buffer.create()
      local layout_config = layout(config)
      local winnr = window.create(bufnr, layout_config)
      vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
      vim.fn.prompt_setprompt(bufnr, config.prompt)
      buffer["add-highlight"](bufnr, "SnapPrompt", 0, 0, string.len(config.prompt))
      vim.api.nvim_command("startinsert")
      vim.api.nvim_win_set_option(winnr, "winhl", "Normal:SnapNormal,FloatBorder:SnapBorder")
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
          vim.api.nvim_command("augroup SnapInputLeave")
          vim.api.nvim_command("autocmd!")
          vim.api.nvim_command("augroup END")
          exited = true
          return config["on-exit"]()
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
        return config["on-update"](get_filter())
      end
      local function on_detach()
        return register.clean(bufnr)
      end
      register["buf-map"](bufnr, {"n", "i"}, mappings0.next, on_next)
      register["buf-map"](bufnr, {"n", "i"}, mappings0.enter, on_enter)
      local function _4_(...)
        return on_enter("split", ...)
      end
      register["buf-map"](bufnr, {"n", "i"}, mappings0["enter-split"], _4_)
      local function _5_(...)
        return on_enter("vsplit", ...)
      end
      register["buf-map"](bufnr, {"n", "i"}, mappings0["enter-vsplit"], _5_)
      local function _6_(...)
        return on_enter("tab", ...)
      end
      register["buf-map"](bufnr, {"n", "i"}, mappings0["enter-tab"], _6_)
      register["buf-map"](bufnr, {"n", "i"}, mappings0.exit, on_exit)
      register["buf-map"](bufnr, {"n", "i"}, mappings0.select, on_tab)
      register["buf-map"](bufnr, {"n", "i"}, mappings0.unselect, on_shifttab)
      register["buf-map"](bufnr, {"n", "i"}, mappings0["select-all"], on_ctrla)
      local _7_
      if config.reverse then
        _7_ = {"<Down>", "<C-j>"}
      else
        _7_ = {"<Up>", "<C-k>"}
      end
      register["buf-map"](bufnr, {"n", "i"}, _7_, config["on-prev-item"])
      local _9_
      if config.reverse then
        _9_ = {"<Up>", "<C-k>"}
      else
        _9_ = {"<Down>", "<C-j>"}
      end
      register["buf-map"](bufnr, {"n", "i"}, _9_, config["on-next-item"])
      register["buf-map"](bufnr, {"n", "i"}, mappings0["prev-item"], config["on-prev-item"])
      register["buf-map"](bufnr, {"n", "i"}, mappings0["next-item"], config["on-next-item"])
      local _11_
      if config.reverse then
        _11_ = {"<PageDown>"}
      else
        _11_ = {"<PageUp>"}
      end
      register["buf-map"](bufnr, {"n", "i"}, _11_, config["on-prev-page"])
      local _13_
      if config.reverse then
        _13_ = {"<PageUp>"}
      else
        _13_ = {"<PageDown>"}
      end
      register["buf-map"](bufnr, {"n", "i"}, _13_, config["on-next-page"])
      register["buf-map"](bufnr, {"n", "i"}, mappings0["prev-page"], config["on-prev-page"])
      register["buf-map"](bufnr, {"n", "i"}, mappings0["next-page"], config["on-next-page"])
      register["buf-map"](bufnr, {"n", "i"}, mappings0["view-page-down"], config["on-viewpagedown"])
      register["buf-map"](bufnr, {"n", "i"}, mappings0["view-page-up"], config["on-viewpageup"])
      register["buf-map"](bufnr, {"n", "i"}, mappings0["view-toggle-hide"], config["on-view-toggle-hide"])
      vim.api.nvim_command("augroup SnapInputLeave")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command(string.format("autocmd! BufLeave <buffer=%s> %s", bufnr, register["get-autocmd-call"](tostring(bufnr), on_exit)))
      vim.api.nvim_command("augroup END")
      vim.api.nvim_buf_attach(bufnr, false, {on_detach = on_detach, on_lines = on_lines})
      local function delete()
        if vim.api.nvim_win_is_valid(winnr) then
          window.close(winnr)
        end
        if vim.api.nvim_buf_is_valid(bufnr) then
          return buffer.delete(bufnr, {force = true})
        end
      end
      local function update(view)
        local layout_config0 = layout(config)
        window.update(winnr, layout_config0)
        do end (view)["height"] = layout_config0.height
        view["width"] = layout_config0.width
        return nil
      end
      local view = {bufnr = bufnr, delete = delete, height = layout_config.height, update = update, width = layout_config.width, winnr = winnr}
      vim.api.nvim_command("augroup SnapInputViewResize")
      vim.api.nvim_command("autocmd!")
      local function _15_()
        return view:update()
      end
      vim.api.nvim_command(string.format("autocmd VimResized * %s", register["get-autocmd-call"]("VimResized", _15_)))
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