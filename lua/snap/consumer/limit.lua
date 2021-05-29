local _2afile_2a = "fnl/snap/consumer/limit.fnl"
local snap = require("snap")
local function _1_(limit, producer)
  local function _2_(request)
    local count = 0
    for results in snap.consume(producer, request) do
      if (type(results) == "table") then
        count = (count + #results)
      end
      if (count > limit) then
        request.cancel()
      end
      coroutine.yield(results)
    end
    return nil
  end
  return _2_
end
return _1_