local _2afile_2a = "fnl/snap/consumer/fzy/filter.fnl"
local snap = require("snap")
local fzy = require("fzy")
local function _1_(producer)
  local function filter(filter0, results)
    if (filter0 == "") then
      return results
    else
      local function _2_(_241)
        return fzy.has_match(filter0, tostring(_241))
      end
      return vim.tbl_filter(_2_, results)
    end
  end
  local function _4_(request)
    for results in snap.consume(producer, request) do
      local _5_ = type(results)
      if (_5_ == "table") then
        coroutine.yield(filter(request.filter, results))
      elseif (_5_ == "nil") then
        coroutine.yield(nil)
      else
      end
    end
    return nil
  end
  return _4_
end
return _1_