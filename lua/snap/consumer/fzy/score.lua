local _2afile_2a = "fnl/snap/consumer/fzy/score.fnl"
local _0_0
do
  local name_0_ = "snap.consumer.fzy.score"
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
    return {require("fzy"), require("snap")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {fzy = "fzy", snap = "snap"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local fzy = _local_0_[1]
local snap = _local_0_[2]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "snap.consumer.fzy.score"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local create
do
  local v_0_
  do
    local v_0_0
    local function create0(producer)
      local function _2_(request)
        for results in snap.consume(producer, request) do
          local _3_0 = type(results)
          if (_3_0 == "table") then
            local function _4_(_241)
              return snap.with_meta(_241, "score", fzy.score(request.filter, tostring(_241)))
            end
            coroutine.yield(vim.tbl_map(_4_, results))
          elseif (_3_0 == "nil") then
            coroutine.yield(nil)
          end
        end
        return nil
      end
      return _2_
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