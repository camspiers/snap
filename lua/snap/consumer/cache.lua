local _2afile_2a = "fnl/snap/consumer/cache.fnl"
local snap = require("snap")
local function _1_(producer)
  local cache = {}
  local function _2_(request)
    if (#cache == 0) then
      for results in snap.consume(producer, request) do
        snap.accumulate(cache, results)
        coroutine.yield(results)
      end
      return nil
    else
      return cache
    end
  end
  return _2_
end
return _1_