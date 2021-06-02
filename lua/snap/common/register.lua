local _2afile_2a = "fnl/snap/common/register.fnl"
local _0_
do
  local name_0_ = "snap.common.register"
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
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.common.register"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local register = {}
local clean
do
  local v_0_
  do
    local v_0_0
    local function clean0(group)
      register[group] = nil
      return nil
    end
    v_0_0 = clean0
    _0_["clean"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["clean"] = v_0_
  clean = v_0_
end
local run
do
  local v_0_
  do
    local v_0_0
    local function run0(group, fnc)
      local _3_
      do
        local t_0_ = register
        if (nil ~= t_0_) then
          t_0_ = (t_0_)[group]
        end
        if (nil ~= t_0_) then
          t_0_ = (t_0_)[fnc]
        end
        _3_ = t_0_
      end
      if _3_ then
        return register[group][fnc]()
      end
    end
    v_0_0 = run0
    _0_["run"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["run"] = v_0_
  run = v_0_
end
local get_by_template
do
  local v_0_
  do
    local v_0_0
    local function get_by_template0(group, fnc, pre, post)
      local group_fns = (register[group] or {})
      local id = string.format("%s", fnc)
      do end (register)[group] = group_fns
      if (group_fns[id] == nil) then
        group_fns[id] = fnc
      end
      return string.format("%slua require'snap'.register.run('%s', '%s')%s", pre, group, id, post)
    end
    v_0_0 = get_by_template0
    _0_["get-by-template"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-by-template"] = v_0_
  get_by_template = v_0_
end
local get_map_call
do
  local v_0_
  do
    local v_0_0
    local function get_map_call0(group, fnc)
      return get_by_template(group, fnc, "<Cmd>", "<CR>")
    end
    v_0_0 = get_map_call0
    _0_["get-map-call"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-map-call"] = v_0_
  get_map_call = v_0_
end
local get_autocmd_call
do
  local v_0_
  do
    local v_0_0
    local function get_autocmd_call0(group, fnc)
      return get_by_template(group, fnc, ":", "")
    end
    v_0_0 = get_autocmd_call0
    _0_["get-autocmd-call"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-autocmd-call"] = v_0_
  get_autocmd_call = v_0_
end
local buf_map
do
  local v_0_
  do
    local v_0_0
    local function buf_map0(bufnr, modes, keys, fnc, opts)
      local rhs = get_map_call(tostring(bufnr), fnc)
      for _, key in ipairs(keys) do
        for _0, mode in ipairs(modes) do
          vim.api.nvim_buf_set_keymap(bufnr, mode, key, rhs, (opts or {nowait = true}))
        end
      end
      return nil
    end
    v_0_0 = buf_map0
    _0_["buf-map"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["buf-map"] = v_0_
  buf_map = v_0_
end
local map
do
  local v_0_
  do
    local v_0_0
    local function map0(modes, keys, fnc, opts)
      local rhs = get_map_call("global", fnc)
      for _, key in ipairs(keys) do
        for _0, mode in ipairs(modes) do
          vim.api.nvim_set_keymap(mode, key, rhs, (opts or {}))
        end
      end
      return nil
    end
    v_0_0 = map0
    _0_["map"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["map"] = v_0_
  map = v_0_
end
return nil