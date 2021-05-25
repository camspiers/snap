local _2afile_2a = "fnl/snap/producer/fd/general.fnl"
local snap = require("snap")
local io = require("snap.io")
local function _1_(args, request)
  local cwd = snap.yield(vim.fn.getcwd)
  for data, err, kill in io.spawn("fd", args, cwd) do
    if request.cancel then
      kill()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      coroutine.yield(vim.split(data, "\n", true))
    end
  end
  return nil
end
return _1_