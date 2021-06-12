local _2afile_2a = "fnl/snap/producer/fd/file.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local general = snap.get("producer.fd.general")
local file = {}
local args = {"--no-ignore-vcs", "-t", "f"}
file.default = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = args, cwd = cwd})
end
file.hidden = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = {"--hidden", unpack(args)}, cwd = cwd})
end
file.args = function(new_args)
  local function _1_(request)
    local cwd = snap.sync(vim.fn.getcwd)
    return general(request, {args = tbl.concat(args, new_args), cwd = cwd})
  end
  return _1_
end
return file