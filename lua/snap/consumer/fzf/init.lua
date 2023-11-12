local _2afile_2a = "fnl/snap/consumer/fzf/init.fnl"
local snap = require("snap")
local io = snap.get("common.io")
local cache = snap.get("consumer.cache")
local positions = snap.get("consumer.positions")
local tbl = snap.get("common.tbl")
local string = snap.get("common.string")
local function _1_(producer)
  local cached_producer = cache(producer)
  local function _2_(request)
    local results = {}
    for data in snap.consume(cached_producer, request) do
      tbl.acc(results, data)
      snap.continue()
    end
    local results_string
    local function _3_(_241)
      return tostring(_241)
    end
    results_string = table.concat(vim.tbl_map(_3_, results), "\n")
    if (request.filter == "") then
      return coroutine.yield(results)
    else
      local cwd = snap.sync(vim.fn.getcwd)
      local stdout = vim.loop.new_pipe(false)
      local fzf = io.spawn("fzf", {"-f", request.filter}, cwd, stdout)
      stdout:write(results_string)
      stdout:shutdown()
      for data, err, kill in fzf do
        if request.canceled() then
          kill()
          coroutine.yield(nil)
        elseif (err ~= "") then
          coroutine.yield(nil)
        elseif (data == "") then
          snap.continue()
        else
          local results_indexed = {}
          for _, result in ipairs(results) do
            results_indexed[tostring(result)] = result
          end
          local filtered_results = string.split(data)
          local function _4_(_241)
            return results_indexed[_241]
          end
          coroutine.yield(vim.tbl_map(_4_, filtered_results))
        end
      end
      return nil
    end
  end
  return positions(_2_)
end
return _1_