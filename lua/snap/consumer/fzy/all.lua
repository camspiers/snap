local _2afile_2a = "fnl/snap/consumer/fzy/all.fnl"
local snap = require("snap")
local fzy = require("fzy")
local function _1_(producer)
  local function filter(filter0, results)
    if (filter0 == "") then
      return results
    else
      local processed = {}
      local function _3_(_241)
        return tostring(_241)
      end
      for _, _2_ in ipairs(fzy.filter(filter0, vim.tbl_map(_3_, results))) do
        local _each_4_ = _2_
        local index = _each_4_[1]
        local positions = _each_4_[2]
        local score = _each_4_[3]
        table.insert(processed, snap.with_metas(results[index], {positions = positions, score = score}))
      end
      return processed
    end
  end
  local function _6_(request)
    for results in snap.consume(producer, request) do
      local _7_ = type(results)
      if (_7_ == "table") then
        coroutine.yield(filter(request.filter, results))
      elseif (_7_ == "nil") then
        coroutine.yield(nil)
      else
      end
    end
    return nil
  end
  return _6_
end
return _1_