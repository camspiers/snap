local _2afile_2a = "fnl/snap/preview/vimgrep.fnl"
local snap = require("snap")
local snap_io = snap.get("io")
local parse = snap.get("common.vimgrep.parse")
local function _1_(request)
  local selection = parse(request.selection)
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(selection.filename, ":p", ...)
  end
  path = snap.sync(_2_)
  local handle = io.popen(string.format("file -n -b --mime-encoding %s", path))
  local encoding = string.gsub(handle:read("*a"), "^%s*(.-)%s*$", "%1")
  handle:close()
  snap.continue()
  local preview
  if (encoding == "binary") then
    preview = {"Binary file"}
  else
    local databuffer = ""
    local reader = coroutine.create(snap_io.read)
    while (coroutine.status(reader) ~= "dead") do
      local _, cancel, data = coroutine.resume(reader, path)
      if (data ~= nil) then
        databuffer = (databuffer .. data)
      end
      if request.canceled() then
        cancel()
        coroutine.yield(nil)
      end
      snap.continue()
    end
    preview = vim.split(databuffer, "\n", true)
  end
  local function _4_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", true)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", true)
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      local fake_path = (vim.fn.tempname() .. "%" .. vim.fn.fnamemodify(selection.filename, ":p:gs?/?%?"))
      vim.api.nvim_buf_set_name(request.bufnr, fake_path)
      local function _5_(...)
        return vim.api.nvim_command("filetype detect", ...)
      end
      vim.api.nvim_buf_call(request.bufnr, _5_)
      if (encoding ~= "binary") then
        return vim.api.nvim_win_set_cursor(request.winnr, {selection.lnum, (selection.col - 1)})
      end
    end
  end
  return snap.sync(_4_)
end
return _1_