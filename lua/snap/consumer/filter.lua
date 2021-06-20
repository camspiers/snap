local _2afile_2a = "fnl/snap/consumer/filter.fnl"
local snap = require("snap")
local function _1_(filter_fnc, producer)
  local function _2_(request)
    for results in snap.consume(producer, request) do
      if ((type(results) == "table") and (#results > 0)) then
        local function _3_(_241)
          return filter_fnc(_241, request)
        end
        coroutine.yield(vim.tbl_filter(_3_, results))
      else
        coroutine.yield(results)
      end
    end
    return nil
  end
  return _2_
end
return _1_