local _2afile_2a = "fnl/snap/producer/request.fnl"
local _2amodule_name_2a = "snap.producer.request"
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
local _ = nil
_2amodule_locals_2a["_"] = _
local function create(config)
  assert((type(config.body) == "table"), "body must be a table")
  assert((type(config.cancel) == "function"), "cancel must be a function")
  local request = {["is-canceled"] = false}
  for key, value in pairs(config.body) do
    request[key] = value
  end
  request.cancel = function()
    request["is-canceled"] = true
    return nil
  end
  request.canceled = function()
    return (request["is-canceled"] or config.cancel(request))
  end
  return request
end
_2amodule_2a["create"] = create
return _2amodule_2a