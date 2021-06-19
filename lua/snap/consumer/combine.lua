local _2afile_2a = "fnl/snap/consumer/combine.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local function _1_(...)
  local producers = {...}
  local function _2_(request)
    for _, producer in ipairs(producers) do
      for results in snap.consume(producer, request) do
        coroutine.yield(results)
      end
    end
    return nil
  end
  return _2_
end
return _1_