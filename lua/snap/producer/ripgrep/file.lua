local _2afile_2a = "fnl/snap/producer/ripgrep/file.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local general = snap.get("producer.ripgrep.general")
local file = {}
local args = {"--line-buffered", "--files"}
file.default = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = args, cwd = cwd})
end
file.hidden = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = {"--hidden", unpack(args)}, cwd = cwd})
end
file.args = function(new_args, cwd)
  local args0 = tbl.concat(args, new_args)
  local absolute = (cwd ~= nil)
  local function _1_(request)
    local cwd0 = (cwd or snap.sync(vim.fn.getcwd))
    return general(request, {args = args0, cwd = cwd0, absolute = absolute})
  end
  return _1_
end
return file