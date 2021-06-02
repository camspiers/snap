local _2afile_2a = "fnl/snap/producer/ripgrep/general.fnl"
local io = require("snap.io")
local function _2_(request, _1_)
  local _arg_0_ = _1_
  local args = _arg_0_["args"]
  local cwd = _arg_0_["cwd"]
  for data, err, cancel in io.spawn("rg", args, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      local results = {}
      for line in data:gmatch("([^\13\n]*)[\13\n]?") do
        table.insert(results, line)
      end
      coroutine.yield(results)
    end
  end
  return nil
end
return _2_