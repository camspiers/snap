local _2afile_2a = "fnl/snap/producer/tmux/session.fnl"
local snap = require("snap")
local io = require("snap.common.io")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  for data, err, cancel in io.spawn("tmux", {"list-sessions", "-F", "#S"}, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      coroutine.yield(vim.split(data:sub(1, -2), "\n", true))
    end
  end
  return nil
end
return _1_