local _2afile_2a = "fnl/snap/utils.fnl"
local _0_0
do
  local name_0_ = "snap.utils"
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
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local _2amodule_2a = _0_0
local _2amodule_name_2a = "snap.utils"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local run
do
  local v_0_
  do
    local v_0_0
    local function run0(cmd)
      local file = io.popen(cmd, "r")
      local function close_handlers_0_(ok_0_, ...)
        file:close()
        if ok_0_ then
          return ...
        else
          return error(..., 0)
        end
      end
      local function _2_()
        local contents = file:read("*all")
        local function _3_(_241)
          return (_241 ~= "")
        end
        return vim.tbl_filter(_3_, vim.split(contents, "\n"))
      end
      return close_handlers_0_(xpcall(_2_, (package.loaded.fennel or debug).traceback))
    end
    v_0_0 = run0
    _0_0["run"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["run"] = v_0_
  run = v_0_
end
return nil