local _2afile_2a = "fnl/snap/producer/ripgrep/general.fnl"
local snap = require("snap")
local io = snap.get("common.io")
local string = snap.get("common.string")
local function _3_(request, _1_)
  local _arg_2_ = _1_
  local args = _arg_2_["args"]
  local cwd = _arg_2_["cwd"]
  local absolute = _arg_2_["absolute"]
  for data, err, cancel in io.spawn("rg", args, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      snap.continue()
    else
      local results = string.split(data)
      if absolute then
        local function _4_(_241)
          return string.format("%s/%s", cwd, _241)
        end
        results = vim.tbl_map(_4_, results)
      else
      end
      coroutine.yield(results)
    end
  end
  return nil
end
return _3_