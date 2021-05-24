local _2afile_2a = "fnl/snap/grep.fnl"
local _0_0
do
  local name_0_ = "snap.grep"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("snap.io"), require("snap")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {io = "snap.io", snap = "snap"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local io = _local_0_[1]
local snap = _local_0_[2]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "snap.grep"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local function get_results(request)
  local cwd = snap.yield(vim.fn.getcwd)
  for data, err, kill in io.spawn("rg", {"--vimgrep", "--hidden", request.filter}, cwd) do
    if request.cancel then
      kill()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      coroutine.yield(vim.split(data, "\n", true))
    end
  end
  return nil
end
local function parse(line)
  local parts = vim.split(line, ":")
  return {col = tonumber(parts[3]), filename = parts[1], lnum = tonumber(parts[2]), text = parts[4]}
end
local function on_multiselect(lines, winnr)
  vim.fn.setqflist(vim.tbl_map(parse, lines))
  vim.api.nvim_command("copen")
  return vim.api.nvim_command("cfirst")
end
local function on_select(line, winnr)
  local _let_0_ = parse(line)
  local col = _let_0_["col"]
  local filename = _let_0_["filename"]
  local lnum = _let_0_["lnum"]
  local buffer = vim.fn.bufnr(filename, true)
  vim.api.nvim_buf_set_option(buffer, "buflisted", true)
  vim.api.nvim_win_set_buf(winnr, buffer)
  return vim.api.nvim_win_set_cursor(winnr, {lnum, col})
end
local run
do
  local v_0_
  do
    local v_0_0
    local function run0()
      return snap.run({get_results = get_results, on_multiselect = on_multiselect, on_select = on_select, prompt = "Grep"})
    end
    v_0_0 = run0
    _0_0["run"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["run"] = v_0_
  run = v_0_
end
local cursor
do
  local v_0_
  do
    local v_0_0
    local function cursor0()
      return snap.run({["initial-filter"] = vim.fn.expand("<cword>"), get_results = get_results, on_multiselect = on_multiselect, on_select = on_select, prompt = "Grep"})
    end
    v_0_0 = cursor0
    _0_0["cursor"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["cursor"] = v_0_
  cursor = v_0_
end
return nil