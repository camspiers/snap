local _2afile_2a = "fnl/snap/consumer/fzy/positions.fnl"
local snap = require("snap")
local fzy = require("fzy")
local function _1_(producer)
  local function _2_(request)
    for results in snap.consume(producer, request) do
      local _3_0 = type(results)
      if (_3_0 == "table") then
        local function _4_()
          if (request.filter == "") then
            return results
          else
            local function _4_(result)
              return snap.with_meta(result, "positions", fzy.positions(request.filter, tostring(result)))
            end
            return vim.tbl_map(_4_, results)
          end
        end
        coroutine.yield(_4_())
      elseif (_3_0 == "nil") then
        coroutine.yield(nil)
      end
    end
    return nil
  end
  return _2_
end
return _1_