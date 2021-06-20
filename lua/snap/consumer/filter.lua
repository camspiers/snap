local _2afile_2a = "fnl/snap/consumer/filter.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local function _1_(filter_fnc, producer)
  local function _2_(request)
    for results in snap.consume(producer, request) do
      if ((type(results) == "table") and (#results > 0)) then
        coroutine.yield(vim.tbl_filter(filter_fnc, results))
      else
        coroutine.yield(results)
      end
    end
    return nil
  end
  return _2_
end
return _1_