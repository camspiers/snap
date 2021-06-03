local _2afile_2a = "fnl/snap/producer/create.fnl"
local _0_
do
  local name_0_ = "snap.producer.create"
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
local _2amodule_name_2a = "snap.producer.create"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local function create_slow_api()
  local slow_api = {pending = false, value = nil}
  slow_api.schedule = function(fnc)
    slow_api["pending"] = true
    local function _3_()
      slow_api["value"] = fnc()
      do end (slow_api)["pending"] = false
      return nil
    end
    return vim.schedule(_3_)
  end
  return slow_api
end
local function _4_(_3_)
  local _arg_0_ = _3_
  local on_end = _arg_0_["on-end"]
  local on_value = _arg_0_["on-value"]
  local producer = _arg_0_["producer"]
  local request = _arg_0_["request"]
  if not request.canceled() then
    local idle = vim.loop.new_idle()
    local thread = coroutine.create(producer)
    local slow_api = create_slow_api()
    local function stop()
      idle:stop()
      idle = nil
      thread = nil
      slow_api = nil
      if on_end then
        return on_end()
      end
    end
    local function start()
      if slow_api.pending then
        return nil
      elseif (coroutine.status(thread) ~= "dead") then
        local _, value, on_cancel = coroutine.resume(thread, request, slow_api.value)
        local _5_ = type(value)
        if (_5_ == "function") then
          return slow_api.schedule(value)
        elseif (_5_ == "nil") then
          return stop()
        else
          local function _6_()
            return (value == continue_value)
          end
          if ((_5_ == "table") and _6_()) then
            if request.canceled() then
              if on_cancel then
                on_cancel()
              end
              return stop()
            else
              return nil
            end
          else
            local _0 = _5_
            if on_value then
              return on_value(value)
            end
          end
        end
      else
        return stop()
      end
    end
    return idle:start(start)
  end
end
return _4_