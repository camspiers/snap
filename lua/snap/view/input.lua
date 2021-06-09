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
  if config["has-views"] then
    _3_ = math.floor((width * size["view-width"]))
  else
    _3_ = width
  end
  return {col = col, focusable = true, height = 1, row = ((row + height) - size.padding), width = _3_}
end
local create
do
  local v_0_
  do
    local v_0_0
    local function create0(config)
      local bufnr = buffer.create()
      local layout0 = layout(config)
      local winnr = window.create(bufnr, layout0)
      vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
      vim.fn.prompt_setprompt(bufnr, config.prompt)
      vim.api.nvim_command("startinsert")
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
        end
      end
      local function on_enter(type)
        config["on-enter"](type)
        return config["on-exit"]()
      end
      local function on_tab()
        config["on-select-toggle"]()
        return config["on-down"]()
      end
      local function on_shifttab()
        config["on-select-toggle"]()
        return config["on-up"]()
      end
      local function on_ctrla()
        return config["on-select-all-toggle"]()
      end
      local on_lines
      local function _3_()
        return config["on-update"](get_filter())
      end
      on_lines = _3_
      local function on_detach()
        return register.clean(bufnr)
      end
      register["buf-map"](bufnr, {"n", "i"}, {"<CR>"}, on_enter)
      local function _4_(...)
        return on_enter("split", ...)
      end
      register["buf-map"](bufnr, {"n", "i"}, {"<C-x>"}, _4_)
      local function _5_(...)
        return on_enter("vsplit", ...)
      end
      register["buf-map"](bufnr, {"n", "i"}, {"<C-v>"}, _5_)
      local function _6_(...)
        return on_enter("tab", ...)
      end
      register["buf-map"](bufnr, {"n", "i"}, {"<C-t>"}, _6_)
      register["buf-map"](bufnr, {"n", "i"}, {"<Esc>", "<C-c>"}, on_exit)
      register["buf-map"](bufnr, {"n", "i"}, {"<Tab>"}, on_tab)
      register["buf-map"](bufnr, {"n", "i"}, {"<S-Tab>"}, on_shifttab)
      register["buf-map"](bufnr, {"n", "i"}, {"<C-a>"}, on_ctrla)
      register["buf-map"](bufnr, {"n", "i"}, {"<Up>", "<C-p>"}, config["on-up"])
      register["buf-map"](bufnr, {"n", "i"}, {"<Down>", "<C-n>"}, config["on-down"])
      register["buf-map"](bufnr, {"n", "i"}, {"<C-f>", "<PageUp>"}, config["on-pageup"])
      register["buf-map"](bufnr, {"n", "i"}, {"<C-b>", "<PageDown>"}, config["on-pagedown"])
      register["buf-map"](bufnr, {"n", "i"}, {"<C-d>"}, config["on-viewpagedown"])
      register["buf-map"](bufnr, {"n", "i"}, {"<C-u>"}, config["on-viewpageup"])
      vim.api.nvim_command(string.format("autocmd! WinLeave <buffer=%s> %s", bufnr, register["get-autocmd-call"](tostring(bufnr), on_exit)))
      vim.api.nvim_buf_attach(bufnr, false, {on_detach = on_detach, on_lines = on_lines})
      return {bufnr = bufnr, winnr = winnr}
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