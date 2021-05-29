local _2afile_2a = "fnl/snap/consumer/fzy/filter.fnl"
local snap = require("snap")
local fzy = require("fzy")
local function _1_(producer)
  local function filter(filter0, results)
    if (filter0 == "") then
      return results
    else
      local function _2_(_241)
        return fzy.has_match(filter0, _241)
      end
      return vim.tbl_filter(_2_, results)
    end
  end
  local function _2_(request)
    for results in snap.consume(producer, request) do
      local _3_0 = type(results)
      if (_3_0 == "table") then
        coroutine.yield(filter(request.filter, results))
      elseif (_3_0 == "nil") then
        coroutine.yield(nil)
      end
    end
    return nil
  end
  return _2_
end
return _1_