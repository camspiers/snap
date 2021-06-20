local _2afile_2a = "fnl/snap/producer/ripgrep/general.fnl"
local snap = require("snap")
local io = require("snap.common.io")
local function _2_(request, _1_)
  local _arg_0_ = _1_
  local absolute = _arg_0_["absolute"]
  local args = _arg_0_["args"]
  local cwd = _arg_0_["cwd"]
  for data, err, cancel in io.spawn("rg", args, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      snap.continue()
    else
      local results = vim.split(data:sub(1, -2), "\n", true)
      if absolute then
        local function _3_(_241)
          return string.format("%s/%s", cwd, _241)
        end
        results = vim.tbl_map(_3_, results)
      end
      coroutine.yield(results)
    end
  end
  return nil
end
return _2_