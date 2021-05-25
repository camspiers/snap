local _2afile_2a = "fnl/snap/producer/oldfile.fnl"
local _0_0
do
  local name_0_ = "snap.producer.oldfile"
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
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("snap")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {snap = "snap"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local snap = _local_0_[1]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "snap.producer.oldfile"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local function get_oldfiles()
  local function _2_(_241)
    return (vim.fn.empty(vim.fn.glob(_241)) == 0)
  end
  return vim.tbl_filter(_2_, vim.v.oldfiles)
end
local create
do
  local v_0_
  do
    local v_0_0
    local function create0()
      local _2_0 = snap.yield(get_oldfiles)
      return _2_0
    end
    v_0_0 = create0
    _0_0["create"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["create"] = v_0_
  create = v_0_
end
return nil