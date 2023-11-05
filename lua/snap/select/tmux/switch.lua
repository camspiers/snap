local _2afile_2a = "fnl/snap/select/tmux/switch.fnl"
local _2amodule_name_2a = "snap.select.tmux.switch"
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
local io = require("snap.common.io")
do end (_2amodule_locals_2a)["io"] = io
local function select(selection, winnr)
  return io.spawn("tmux", {"switch-client", "-t", selection}, cwd)
end
_2amodule_2a["select"] = select
return _2amodule_2a