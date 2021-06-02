local _2afile_2a = "fnl/snap/view/size.fnl"
local _0_
do
  local name_0_ = "snap.view.size"
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
local _2amodule_name_2a = "snap.view.size"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local border
do
  local v_0_
  do
    local v_0_0 = 1
    _0_["border"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["border"] = v_0_
  border = v_0_
end
local padding
do
  local v_0_
  do
    local v_0_0 = 1
    _0_["padding"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["padding"] = v_0_
  padding = v_0_
end
local view_width
do
  local v_0_
  do
    local v_0_0 = 0.5
    _0_["view-width"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["view-width"] = v_0_
  view_width = v_0_
end
return nil