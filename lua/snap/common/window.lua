local _2afile_2a = "fnl/snap/common/window.fnl"
local _0_
do
  local name_0_ = "snap.common.window"
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
local _2amodule_name_2a = "snap.common.window"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local create
do
  local v_0_
  do
    local v_0_0
    local function create0(bufnr, _3_)
      local _arg_0_ = _3_
      local col = _arg_0_["col"]
      local focusable = _arg_0_["focusable"]
      local height = _arg_0_["height"]
      local row = _arg_0_["row"]
      local width = _arg_0_["width"]
      return vim.api.nvim_open_win(bufnr, 0, {anchor = "NW", border = {"\226\149\173", "\226\148\128", "\226\149\174", "\226\148\130", "\226\149\175", "\226\148\128", "\226\149\176", "\226\148\130"}, col = col, focusable = focusable, height = height, relative = "editor", row = row, style = "minimal", width = width})
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