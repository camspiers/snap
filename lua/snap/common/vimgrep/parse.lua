local _2afile_2a = "fnl/snap/common/vimgrep/parse.fnl"
local function _1_(line)
  local parts = vim.split(tostring(line), ":")
  return {filename = parts[1], lnum = tonumber(parts[2]), col = tonumber(parts[3]), text = parts[4]}
end
return _1_