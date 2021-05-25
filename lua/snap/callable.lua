local _2afile_2a = "fnl/snap/callable.fnl"
local function create(mod, fnc)
  return setmetatable(mod, {__call = fnc})
end
return create