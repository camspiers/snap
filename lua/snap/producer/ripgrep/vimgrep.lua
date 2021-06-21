local _2afile_2a = "fnl/snap/producer/ripgrep/vimgrep.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local general = snap.get("producer.ripgrep.general")
local vimgrep = {}
local args = {"--line-buffered", "-M", 100, "--vimgrep"}
vimgrep.default = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = {unpack(args), request.filter}, cwd = cwd})
end
vimgrep.args = function(new_args, cwd)
  local args0 = tbl.concat(args, new_args)
  local absolute = (cwd ~= nil)
  local function _1_(request)
    local cwd0 = (cwd or snap.sync(vim.fn.getcwd))
    return general(request, {absolute = absolute, args = {unpack(args0), request.filter}, cwd = cwd0})
  end
  return _1_
end
return vimgrep