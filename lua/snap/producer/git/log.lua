local _2afile_2a = "fnl/snap/producer/git/log.fnl"
local function parse(line)
  local _end = line:find(" ")
  return {comment = line:sub((_end + 1), -1), hash = line:sub(1, (_end - 1))}
end
local snap = require("snap")
local io = require("snap.common.io")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  for data, err, cancel in io.spawn("git", {"log", "--oneline"}, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      local results = vim.split(data:sub(1, -2), "\n", true)
      if (#results > 0) then
        local function _2_(_241)
          return snap.with_metas(_241, parse(_241))
        end
        coroutine.yield(vim.tbl_map(_2_, results))
      else
        snap.continue()
      end
    end
  end
  return nil
end
return _1_