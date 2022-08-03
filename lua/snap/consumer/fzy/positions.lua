local _2afile_2a = "fnl/snap/consumer/fzy/positions.fnl"
local snap = require("snap")
local fzy = require("fzy")
local function _1_(producer)
  local function _2_(request)
    for results in snap.consume(producer, request) do
      local _3_ = type(results)
      if (_3_ == "table") then
        local function _5_()
          if (request.filter == "") then
            return results
          else
            local function _4_(result)
              return snap.with_meta(result, "positions", fzy.positions(request.filter, tostring(result)))
            end
            return vim.tbl_map(_4_, results)
          end
        end
        coroutine.yield(_5_())
      elseif (_3_ == "nil") then
        coroutine.yield(nil)
      else
      end
    end
    return nil
  end
  return _2_
end
return _1_