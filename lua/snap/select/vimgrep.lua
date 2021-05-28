local _2afile_2a = "fnl/snap/select/vimgrep.fnl"
local _0_0
do
  local name_0_ = "snap.select.vimgrep"
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
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local _2amodule_2a = _0_0
local _2amodule_name_2a = "snap.select.vimgrep"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local parse
do
  local v_0_
  do
    local v_0_0
    local function parse0(line)
      local parts = vim.split(line, ":")
      return {col = tonumber(parts[3]), filename = parts[1], lnum = tonumber(parts[2]), text = parts[4]}
    end
    v_0_0 = parse0
    _0_0["parse"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["parse"] = v_0_
  parse = v_0_
end
local multiselect
do
  local v_0_
  do
    local v_0_0
    local function multiselect0(lines, winnr)
      vim.fn.setqflist(vim.tbl_map(parse, lines))
      vim.api.nvim_command("copen")
      return vim.api.nvim_command("cfirst")
    end
    v_0_0 = multiselect0
    _0_0["multiselect"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["multiselect"] = v_0_
  multiselect = v_0_
end
local select
do
  local v_0_
  do
    local v_0_0
    local function select0(line, winnr)
      local _let_0_ = parse(line)
      local col = _let_0_["col"]
      local filename = _let_0_["filename"]
      local lnum = _let_0_["lnum"]
      local buffer = vim.fn.bufnr(filename, true)
      vim.api.nvim_buf_set_option(buffer, "buflisted", true)
      vim.api.nvim_win_set_buf(winnr, buffer)
      return vim.api.nvim_win_set_cursor(winnr, {lnum, col})
    end
    v_0_0 = select0
    _0_0["select"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["select"] = v_0_
  select = v_0_
end
return nil