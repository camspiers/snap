local _2afile_2a = "fnl/snap/consumer/try.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local function _1_(...)
  local producers = {...}
  local function _2_(request)
    for _, producer in ipairs(producers) do
      local had_values = false
      for results in snap.consume(producer, request) do
        if ((type(results) == "table") and (#results > 0)) then
          had_values = true
        end
        coroutine.yield(results)
      end
      if had_values then
        coroutine.yield(nil)
      end
    end
    return nil
  end
  return _2_
end
return _1_