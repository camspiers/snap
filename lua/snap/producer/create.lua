local _2afile_2a = "fnl/snap/producer/create.fnl"
local snap = require("snap")
local function create_slow_api()
  local slow_api = {value = nil, pending = false}
  slow_api.schedule = function(fnc)
    slow_api["pending"] = true
    local function _1_()
      slow_api["value"] = fnc()
      do end (slow_api)["pending"] = false
      return nil
    end
    return vim.schedule(_1_)
  end
  return slow_api
end
local function _4_(_2_)
  local _arg_3_ = _2_
  local producer = _arg_3_["producer"]
  local request = _arg_3_["request"]
  local on_end = _arg_3_["on-end"]
  local on_value = _arg_3_["on-value"]
  local on_tick = _arg_3_["on-tick"]
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
      else
        return nil
      end
    end
    local function start()
      if slow_api.pending then
        return nil
      elseif (coroutine.status(thread) ~= "dead") then
        local _, value, on_cancel = coroutine.resume(thread, request, slow_api.value)
        do
          local _6_ = type(value)
          if (_6_ == "function") then
            slow_api.schedule(value)
          elseif (_6_ == "nil") then
            stop()
          else
            local function _7_()
              return (value == snap.continue_value)
            end
            if ((_6_ == "table") and _7_()) then
              if request.canceled() then
                if on_cancel then
                  on_cancel()
                else
                end
                stop()
              else
              end
            elseif true then
              local _0 = _6_
              if on_value then
                on_value(value)
              else
              end
            else
            end
          end
        end
        if on_tick then
          return on_tick()
        else
          return nil
        end
      else
        return stop()
      end
    end
    return idle:start(start)
  else
    return nil
  end
end
return _4_