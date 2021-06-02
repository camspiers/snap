local _2afile_2a = "fnl/snap/view/results.fnl"
local _0_
do
  local name_0_ = "snap.view.results"
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
    return {require("snap.common.buffer"), require("snap.view.size"), require("snap.common.window")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {buffer = "snap.common.buffer", size = "snap.view.size", window = "snap.common.window"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local buffer = _local_0_[1]
local size = _local_0_[2]
local window = _local_0_[3]
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.view.results"
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
  return {col = col, focusable = false, height = (height - size.border - size.border - size.padding), row = row, width = _3_}
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
      vim.api.nvim_buf_set_option(bufnr, "textwidth", 0)
      vim.api.nvim_buf_set_option(bufnr, "wrapmargin", 0)
      vim.api.nvim_win_set_option(winnr, "wrap", false)
      vim.api.nvim_win_set_option(winnr, "cursorline", true)
      return {bufnr = bufnr, height = layout0.height, width = layout0.width, winnr = winnr}
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