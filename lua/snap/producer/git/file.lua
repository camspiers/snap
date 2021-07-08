local _2afile_2a = "fnl/snap/producer/git/file.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local general = snap.get("producer.git.general")
local git = {}
local args = {"ls-files"}
git.default = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = args, cwd = cwd})
end
git.args = function(new_args)
  local args0 = tbl.concat(args, new_args)
  local function _1_(request)
    local cwd = (cwd or snap.sync(vim.fn.getcwd))
    return general(request, {args = args0, cwd = cwd})
  end
  return _1_
end
return git