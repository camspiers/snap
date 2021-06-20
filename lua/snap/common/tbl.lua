local _2afile_2a = "fnl/snap/common/tbl.fnl"
local _0_
do
  local name_0_ = "snap.common.tbl"
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
local _2amodule_name_2a = "snap.common.tbl"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local accumulate
do
  local v_0_
  do
    local v_0_0
    local function accumulate0(tbl, vals)
      if (vals ~= nil) then
        for _, value in ipairs(vals) do
          if (tostring(value) ~= "") then
            table.insert(tbl, value)
          end
        end
        return nil
      end
    end
    v_0_0 = accumulate0
    _0_["accumulate"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["accumulate"] = v_0_
  accumulate = v_0_
end
local merge
do
  local v_0_
  do
    local v_0_0
    local function merge0(tbl1, tbl2)
      local result = {}
      for key, val in pairs(tbl1) do
        result[key] = val
      end
      for key, val in pairs(tbl2) do
        result[key] = val
      end
      return result
    end
    v_0_0 = merge0
    _0_["merge"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["merge"] = v_0_
  merge = v_0_
end
local concat
do
  local v_0_
  do
    local v_0_0
    local function concat0(tbl_a, tbl_b)
      local tbl = {}
      accumulate(tbl, tbl_a)
      accumulate(tbl, tbl_b)
      return tbl
    end
    v_0_0 = concat0
    _0_["concat"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["concat"] = v_0_
  concat = v_0_
end
local take
do
  local v_0_
  do
    local v_0_0
    local function take0(tbl, num)
      local partial_tbl = {}
      for _, value in ipairs(tbl) do
        if (num == #partial_tbl) then break end
        table.insert(partial_tbl, value)
      end
      return partial_tbl
    end
    v_0_0 = take0
    _0_["take"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["take"] = v_0_
  take = v_0_
end
local sum
do
  local v_0_
  do
    local v_0_0
    local function sum0(tbl)
      local count = 0
      for _, val in ipairs(tbl) do
        count = (count + val)
      end
      return count
    end
    v_0_0 = sum0
    _0_["sum"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["sum"] = v_0_
  sum = v_0_
end
local first
do
  local v_0_
  do
    local v_0_0
    local function first0(tbl)
      if tbl then
        return tbl[1]
      end
    end
    v_0_0 = first0
    _0_["first"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["first"] = v_0_
  first = v_0_
end
local allocate
do
  local v_0_
  do
    local v_0_0
    local function allocate0(total, divisor)
      local remainder = total
      local parts = {}
      local part = math.floor((total / divisor))
      for i = 1, divisor do
        if (i == divisor) then
          table.insert(parts, remainder)
        else
          table.insert(parts, part)
          remainder = (remainder - part)
        end
      end
      return parts
    end
    v_0_0 = allocate0
    _0_["allocate"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["allocate"] = v_0_
  allocate = v_0_
end
local function partition(tbl, p, r, comp)
  local x = tbl[r]
  local i = (p - 1)
  for j = p, (r - 1), 1 do
    if comp(tbl[j], x) then
      i = (i + 1)
      local temp = tbl[i]
      tbl[i] = tbl[j]
      tbl[j] = temp
    end
  end
  local temp = tbl[(i + 1)]
  tbl[(i + 1)] = tbl[r]
  tbl[r] = temp
  return (i + 1)
end
local partial_quicksort
do
  local v_0_
  do
    local v_0_0
    local function partial_quicksort0(tbl, p, r, m, comp)
      if (p < r) then
        local q = partition(tbl, p, r, comp)
        partial_quicksort0(tbl, p, (q - 1), m, comp)
        if (p < (m - 1)) then
          return partial_quicksort0(tbl, (q + 1), r, m, comp)
        end
      end
    end
    v_0_0 = partial_quicksort0
    _0_["partial-quicksort"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["partial-quicksort"] = v_0_
  partial_quicksort = v_0_
end
return nil