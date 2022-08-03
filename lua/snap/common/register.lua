local _2afile_2a = "fnl/snap/common/register.fnl"
local _2amodule_name_2a = "snap.common.register"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local register = {commands = {}}
local function clean(group)
  register[group] = nil
  return nil
end
_2amodule_2a["clean"] = clean
local function run(group, fnc)
  local _2_
  do
    local t_1_ = register
    if (nil ~= t_1_) then
      t_1_ = (t_1_)[group]
    else
    end
    if (nil ~= t_1_) then
      t_1_ = (t_1_)[fnc]
    else
    end
    _2_ = t_1_
  end
  if _2_ then
    return register[group][fnc]()
  else
    return nil
  end
end
_2amodule_2a["run"] = run
local function get_by_template(group, fnc, pre, post)
  local group_fns = (register[group] or {})
  local id = string.format("%s", fnc)
  do end (register)[group] = group_fns
  if (group_fns[id] == nil) then
    group_fns[id] = fnc
  else
  end
  return string.format("%slua require'snap'.register.run('%s', '%s')%s", pre, group, id, post)
end
_2amodule_2a["get-by-template"] = get_by_template
local function get_map_call(group, fnc)
  return get_by_template(group, fnc, "<Cmd>", "<CR>")
end
_2amodule_2a["get-map-call"] = get_map_call
local function get_autocmd_call(group, fnc)
  return get_by_template(group, fnc, ":", "")
end
_2amodule_2a["get-autocmd-call"] = get_autocmd_call
local function buf_map(bufnr, modes, keys, fnc, opts)
  local rhs = get_map_call(tostring(bufnr), fnc)
  for _, key in ipairs(keys) do
    for _0, mode in ipairs(modes) do
      vim.api.nvim_buf_set_keymap(bufnr, mode, key, rhs, (opts or {nowait = true}))
    end
  end
  return nil
end
_2amodule_2a["buf-map"] = buf_map
local function handle_string(tbl)
  local _7_ = type(tbl)
  if (_7_ == "table") then
    return tbl
  elseif (_7_ == "string") then
    return {tbl}
  else
    return nil
  end
end
local function map(modes, keys, fnc, opts)
  local rhs = get_map_call("global", fnc)
  for _, key in ipairs(handle_string(keys)) do
    for _0, mode in ipairs(handle_string(modes)) do
      vim.api.nvim_set_keymap(mode, key, rhs, (opts or {}))
    end
  end
  return nil
end
_2amodule_2a["map"] = map
_G.snap_commands = function()
  return vim.tbl_keys(register.commands)
end
local function command(name, fnc)
  if (#register.commands == 0) then
    vim.api.nvim_command("command! -nargs=1 -complete=customlist,v:lua.snap_commands Snap lua require'snap'.register.run('commands', <f-args>)")
  else
  end
  register.commands[name] = fnc
  return nil
end
_2amodule_2a["command"] = command
return _2amodule_2a