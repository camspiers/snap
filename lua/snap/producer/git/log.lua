local _2afile_2a = "fnl/snap/producer/git/log.fnl"
local snap = require("snap")
local general = require("snap.producer.git.general")
local function process_line(line)
  local _end = line:find(" ")
  return snap.with_metas(line:sub(1, 200), {hash = line:sub(1, (_end - 1)), comment = line:sub((_end + 1), -1)})
end
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  local function _2_(_241)
    return general(_241, {args = {"log", "--oneline"}, cwd = cwd})
  end
  for results in snap.consume(_2_, request) do
    local _3_ = type(results)
    if (_3_ == "table") then
      coroutine.yield(vim.tbl_map(process_line, results))
    elseif (_3_ == "nil") then
      coroutine.yield(nil)
    else
    end
  end
  return nil
end
return _1_