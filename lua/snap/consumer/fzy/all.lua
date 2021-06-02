local _2afile_2a = "fnl/snap/consumer/fzy/all.fnl"
local snap = require("snap")
local fzy = require("fzy")
local function _1_(producer)
  local function filter(filter0, results)
    if (filter0 == "") then
      return results
    else
      local processed = {}
      for _, _2_ in ipairs(fzy.filter(filter0, results)) do
        local _each_0_ = _2_
        local index = _each_0_[1]
        local positions = _each_0_[2]
        local score = _each_0_[3]
        table.insert(processed, snap.with_metas(results[index], {positions = positions, score = score}))
      end
      return processed
    end
  end
  local function _2_(request)
    for results in snap.consume(producer, request) do
      local _3_ = type(results)
      if (_3_ == "table") then
        coroutine.yield(filter(request.filter, results))
      elseif (_3_ == "nil") then
        coroutine.yield(nil)
      end
    end
    return nil
  end
  return _2_
end
return _1_