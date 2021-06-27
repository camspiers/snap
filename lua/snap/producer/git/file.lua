local _2afile_2a = "fnl/snap/producer/git/file.fnl"
local snap = require("snap")
local general = snap.get("producer.git.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  if (general(request, {args = {"ls-files", "-o"}, cwd = cwd}) ~= nil) then
    do local _ = (general(request, {args = {"ls-files"}, cwd = cwd}) .. general(request, {args = {"ls-files", "-o"}, cwd = cwd})) end
  end
  return general(request, {args = {"ls-files"}, cwd = cwd})
end
return _1_
