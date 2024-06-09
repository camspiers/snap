local _2afile_2a = "fnl/snap/common/grep/parse.fnl"
local function _1_(line)
  local parts = vim.split(tostring(line), ":")
  return {filename = parts[1], lnum = tonumber(parts[2]), text = parts[3]}
end
return _1_