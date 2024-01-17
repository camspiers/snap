local _2afile_2a = "fnl/snap/producer/ripgrep/vimgrep.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local general = snap.get("producer.ripgrep.general")
local vimgrep = {}
local args = {"--line-buffered", "-M", 100, "--vimgrep"}
local line_args = {"--line-buffered", "-M", 100, "--no-heading", "--column"}
vimgrep.default = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = tbl.concat(args, {request.filter}), cwd = cwd})
end
vimgrep.hidden = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = tbl.concat(args, {"--hidden", request.filter}), cwd = cwd})
end
vimgrep.line = function(new_args, cwd)
  local args0 = tbl.concat(line_args, new_args)
  local absolute = (cwd ~= nil)
  local function _1_(request)
    local cmd = (cwd or snap.sync(vim.fn.getcwd))
    return general(request, {args = tbl.concat(args0, {request.filter}), cwd = cwd, absolute = absolute})
  end
  return _1_
end
vimgrep.open_files = function(request)
  local open_files
  local function _2_()
    local function _3_(_2410)
      return vim.api.nvim_buf_get_name(_2410)
    end
    return vim.tbl_map(_3_, vim.api.nvim_list_bufs())
  end
  open_files = snap.sync(_2_)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = tbl.concat(args, tbl.concat(open_files, {request.filter})), cwd = cwd})
end
vimgrep.args = function(new_args, cwd)
  local args0 = tbl.concat(args, new_args)
  local absolute = (cwd ~= nil)
  local function _4_(request)
    local cwd0 = (cwd or snap.sync(vim.fn.getcwd))
    return general(request, {args = tbl.concat(args0, {request.filter}), cwd = cwd0, absolute = absolute})
  end
  return _4_
end
return vimgrep