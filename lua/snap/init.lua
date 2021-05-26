local _2afile_2a = "fnl/snap/init.fnl"
local _0_0
do
  local name_0_ = "snap"
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
local _2amodule_name_2a = "snap"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local function tbl_first(tbl)
  if tbl then
    return tbl[1]
  end
end
local meta_tbl
do
  local v_0_
  do
    local v_0_0
    local function _2_(_241)
      return _241.result
    end
    v_0_0 = {__tostring = _2_}
    _0_0["meta-tbl"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["meta-tbl"] = v_0_
  meta_tbl = v_0_
end
local meta_result
do
  local v_0_
  do
    local v_0_0
    local function meta_result0(result)
      local _2_0 = type(result)
      if (_2_0 == "string") then
        local meta_result1 = {result = result}
        setmetatable(meta_result1, meta_tbl)
        return meta_result1
      elseif (_2_0 == "table") then
        assert((getmetatable(result) == meta_tbl))
        return result
      end
    end
    v_0_0 = meta_result0
    _0_0["meta_result"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["meta_result"] = v_0_
  meta_result = v_0_
end
local with_meta
do
  local v_0_
  do
    local v_0_0
    local function with_meta0(result, field, value)
      local meta_result0 = meta_result(result)
      meta_result0[field] = value
      return meta_result0
    end
    v_0_0 = with_meta0
    _0_0["with_meta"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["with_meta"] = v_0_
  with_meta = v_0_
end
local has_meta
do
  local v_0_
  do
    local v_0_0
    local function has_meta0(result, field)
      return ((getmetatable(result) == meta_tbl) and (result[field] ~= nil))
    end
    v_0_0 = has_meta0
    _0_0["has_meta"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["has_meta"] = v_0_
  has_meta = v_0_
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
local function partial_quicksort(tbl, p, r, m, comp)
  if (p < r) then
    local q = partition(tbl, p, r, comp)
    partial_quicksort(tbl, p, (q - 1), m, comp)
    if (p < (m - 1)) then
      return partial_quicksort(tbl, (q + 1), r, m, comp)
    end
  end
end
local layouts
do
  local v_0_
  do
    local v_0_0 = {}
    _0_0["layouts"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["layouts"] = v_0_
  layouts = v_0_
end
layouts.lines = function()
  return vim.api.nvim_get_option("lines")
end
layouts.columns = function()
  return vim.api.nvim_get_option("columns")
end
layouts.middle = function(total, size)
  return math.floor(((total - size) / 2))
end
layouts["from-bottom"] = function(size, offset)
  return (layouts.lines() - size - offset)
end
layouts.size = function(_25width, _25height)
  return {height = math.floor((layouts.lines() * _25height)), width = math.floor((layouts.columns() * _25width))}
end
layouts["%centered"] = function(_25width, _25height)
  local _let_0_ = layouts.size(_25width, _25height)
  local height = _let_0_["height"]
  local width = _let_0_["width"]
  return {col = layouts.middle(layouts.columns(), width), height = height, row = layouts.middle(layouts.lines(), height), width = width}
end
layouts["%bottom"] = function(_25width, _25height)
  local _let_0_ = layouts.size(_25width, _25height)
  local height = _let_0_["height"]
  local width = _let_0_["width"]
  return {col = layouts.middle(layouts.columns(), width), height = height, row = layouts["from-bottom"](height, 8), width = width}
end
layouts["%top"] = function(_25width, _25height)
  local _let_0_ = layouts.size(_25width, _25height)
  local height = _let_0_["height"]
  local width = _let_0_["width"]
  return {col = layouts.middle(layouts.columns(), width), height = height, row = 5, width = width}
end
layouts.centered = function()
  return layouts["%centered"](0.8, 0.5)
end
layouts.bottom = function()
  return layouts["%bottom"](0.8, 0.5)
end
layouts.top = function()
  return layouts["%top"](0.8, 0.5)
end
local fns
do
  local v_0_
  do
    local v_0_0 = {}
    _0_0["fns"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["fns"] = v_0_
  fns = v_0_
end
fns.clean = function(bufnr)
  fns[bufnr] = nil
  return nil
end
fns.run = function(bufnr, fnc)
  local _2_
  do
    local res_0_ = fns[bufnr]
    local function _3_()
      local res_0_0 = (res_0_)[fnc]
      return (res_0_0 and res_0_0)
    end
    _2_ = (res_0_ and _3_())
  end
  if _2_ then
    return fns[bufnr][fnc]()
  end
end
fns["get-by-template"] = function(bufnr, fnc, pre, post)
  local buf_fns = (fns[bufnr] or {})
  local id = string.format("%s", fnc)
  fns[bufnr] = buf_fns
  if (buf_fns[id] == nil) then
    buf_fns[id] = fnc
  end
  return string.format("%slua require'snap'.fns.run(%s, '%s')%s", pre, bufnr, id, post)
end
fns["get-map-call"] = function(bufnr, fnc)
  return fns["get-by-template"](bufnr, fnc, "<Cmd>", "<CR>")
end
fns["get-autocmd-call"] = function(bufnr, fnc)
  return fns["get-by-template"](bufnr, fnc, ":", "")
end
fns.map = function(bufnr, keys, fnc)
  local rhs = fns["get-map-call"](bufnr, fnc)
  for _, key in ipairs(keys) do
    vim.api.nvim_buf_set_keymap(bufnr, "n", key, rhs, {})
    vim.api.nvim_buf_set_keymap(bufnr, "i", key, rhs, {})
  end
  return nil
end
local function create_input_layout(layout)
  local _let_0_ = layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  return {col = col, focusable = true, height = 1, row = (height + row + 2), width = width}
end
local function create_buffer()
  return vim.api.nvim_create_buf(false, true)
end
local function create_window(bufnr, _2_0)
  local _arg_0_ = _2_0
  local col = _arg_0_["col"]
  local focusable = _arg_0_["focusable"]
  local height = _arg_0_["height"]
  local row = _arg_0_["row"]
  local width = _arg_0_["width"]
  return vim.api.nvim_open_win(bufnr, 0, {anchor = "NW", border = {"\226\149\173", "\226\148\128", "\226\149\174", "\226\148\130", "\226\149\175", "\226\148\128", "\226\149\176", "\226\148\130"}, col = col, focusable = focusable, height = height, relative = "editor", row = row, style = "minimal", width = width})
end
local function create_results_view(config)
  local bufnr = create_buffer()
  local layout = config.layout()
  local winnr = create_window(bufnr, layout)
  vim.api.nvim_win_set_option(winnr, "cursorline", true)
  vim.api.nvim_win_set_option(winnr, "wrap", false)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
  return {bufnr = bufnr, height = layout.height, width = layout.width, winnr = winnr}
end
local function create_input_view(config)
  local bufnr = create_buffer()
  local winnr = create_window(bufnr, create_input_layout(config.layout))
  vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
  vim.fn.prompt_setprompt(bufnr, config.prompt)
  vim.api.nvim_command("startinsert")
  if (config["initial-filter"] ~= "") then
    vim.api.nvim_feedkeys(config["initial-filter"], "n", false)
  end
  local function get_filter()
    local contents = tbl_first(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false))
    if contents then
      return contents:sub((#config.prompt + 1))
    else
      return ""
    end
  end
  local function on_exit()
    fns.clean(bufnr)
    return config["on-exit"]()
  end
  local function on_enter()
    config["on-enter"]()
    return on_exit()
  end
  local function on_tab()
    config["on-select-toggle"]()
    return config["on-down"]()
  end
  local function on_shifttab()
    config["on-select-toggle"]()
    return config["on-up"]()
  end
  local function on_ctrla()
    return config["on-select-all-toggle"]()
  end
  local on_lines
  local function _4_()
    return config["on-update"](get_filter())
  end
  on_lines = _4_
  local function on_detach()
    return fns.clean(bufnr)
  end
  fns.map(bufnr, {"<CR>"}, on_enter)
  fns.map(bufnr, {"<Up>", "<C-k>", "<C-p>"}, config["on-up"])
  fns.map(bufnr, {"<Down>", "<C-j>", "<C-n>"}, config["on-down"])
  fns.map(bufnr, {"<Esc>", "<C-c>"}, on_exit)
  fns.map(bufnr, {"<Tab>"}, on_tab)
  fns.map(bufnr, {"<S-Tab>"}, on_shifttab)
  fns.map(bufnr, {"<C-a>"}, on_ctrla)
  fns.map(bufnr, {"<C-d>"}, config["on-pagedown"])
  fns.map(bufnr, {"<C-u>"}, config["on-pageup"])
  vim.api.nvim_command(string.format("autocmd! WinLeave <buffer=%s> %s", bufnr, fns["get-autocmd-call"](bufnr, on_exit)))
  vim.api.nvim_buf_attach(bufnr, false, {on_detach = on_detach, on_lines = on_lines})
  return {bufnr = bufnr, winnr = winnr}
end
local function center_with_text_width(text, text_width, width)
  local space = string.rep(" ", ((width - text_width) / 2))
  return (space .. text .. space)
end
local function center(text, width)
  return center_with_text_width(text, string.len(text), width)
end
local function create_loading_screen(width, height, counter)
  local dots = string.rep(".", (counter % 5))
  local space = string.rep(" ", (5 - string.len(dots)))
  local loading_with_dots = ("\226\148\130" .. space .. dots .. " Loading " .. dots .. space .. "\226\148\130")
  local text_width = string.len(loading_with_dots)
  local loading = {}
  for _ = 1, (height / 2) do
    table.insert(loading, "")
  end
  table.insert(loading, center_with_text_width(("\226\149\173" .. string.rep("\226\148\128", 19) .. "\226\149\174"), text_width, width))
  table.insert(loading, center(loading_with_dots, width))
  table.insert(loading, center_with_text_width(("\226\149\176" .. string.rep("\226\148\128", 19) .. "\226\149\175"), text_width, width))
  return loading
end
local accumulate
do
  local v_0_
  do
    local v_0_0
    local function accumulate0(results, partial_results)
      if (partial_results ~= nil) then
        for _, value in ipairs(partial_results) do
          if (tostring(value) ~= "") then
            table.insert(results, value)
          end
        end
        return nil
      end
    end
    v_0_0 = accumulate0
    _0_0["accumulate"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["accumulate"] = v_0_
  accumulate = v_0_
end
local sync
do
  local v_0_
  do
    local v_0_0
    local function sync0(value)
      local _, result = coroutine.yield(value)
      return result
    end
    v_0_0 = sync0
    _0_0["sync"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["sync"] = v_0_
  sync = v_0_
end
local resume
do
  local v_0_
  do
    local v_0_0
    local function resume0(thread, request, value)
      local _, result = coroutine.resume(thread, request, value)
      if request.cancel then
        return nil
      elseif (type(result) == "function") then
        return resume0(thread, request, sync(result))
      else
        return result
      end
    end
    v_0_0 = resume0
    _0_0["resume"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["resume"] = v_0_
  resume = v_0_
end
local consume
do
  local v_0_
  do
    local v_0_0
    local function consume0(producer, request)
      local reader = coroutine.create(producer)
      local function _3_()
        if (coroutine.status(reader) ~= "dead") then
          return resume(reader, request)
        end
      end
      return _3_
    end
    v_0_0 = consume0
    _0_0["consume"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["consume"] = v_0_
  consume = v_0_
end
local run
do
  local v_0_
  do
    local v_0_0
    local function run0(config)
      assert((type(config) == "table"), "Config must be a table")
      assert(config.producer, "Config must have a producer")
      assert((type(config.producer) == "function"), "Producer must be a function")
      assert(config.select, "Config must have a select")
      assert((type(config.select) == "function"), "Select must be a function")
      if config.multiselect then
        assert((type(config.multiselect) == "function"), "Multiselect must be a function")
      end
      if config.prompt then
        assert((type(config.prompt) == "string"), "Prompt must be a string")
      end
      if config.layout then
        assert((type(config.layout) == "function"), "Layout must be a function")
      end
      local last_filter = nil
      local last_results = {}
      local exit = false
      local buffers = {}
      local layout = (config.layout or layouts.bottom)
      local initial_filter = (config["initial-filter"] or "")
      local namespace = vim.api.nvim_create_namespace("Snap")
      local original_winnr = vim.api.nvim_get_current_win()
      local prompt = string.format("%s> ", (config.prompt or "Find"))
      local selected = {}
      local function on_exit()
        exit = true
        for _, bufnr in ipairs(buffers) do
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, {force = true})
          end
        end
        vim.api.nvim_set_current_win(original_winnr)
        return vim.api.nvim_command("stopinsert")
      end
      local view = create_results_view({["on-exit"] = on_exit, layout = layout})
      table.insert(buffers, view.bufnr)
      local function add_results_highlight(row)
        return vim.api.nvim_buf_add_highlight(view.bufnr, namespace, "Comment", (row - 1), 0, -1)
      end
      local function set_lines(start, _end, lines)
        return vim.api.nvim_buf_set_lines(view.bufnr, start, _end, false, lines)
      end
      local function get_cursor_row()
        local _let_0_ = vim.api.nvim_win_get_cursor(view.winnr)
        local row = _let_0_[1]
        local _ = _let_0_[2]
        return row
      end
      local function get_cursor_line(row)
        return tbl_first(vim.api.nvim_buf_get_lines(view.bufnr, (row - 1), row, false))
      end
      local function write_results(results)
        if not exit then
          local result_size = #results
          if (result_size == 0) then
            return set_lines(0, -1, {})
          else
            local partial_results = {unpack(results, 1, (view.height + get_cursor_row()))}
            set_lines(0, -1, vim.tbl_map(tostring, partial_results))
            for row, line in pairs(partial_results) do
              if selected[tostring(line)] then
                add_results_highlight(row)
              end
            end
            return nil
          end
        end
      end
      local function on_update_unwraped(filter, height)
        local function should_cancel()
          return (exit or (filter ~= last_filter))
        end
        if (filter == last_filter) then
          local check = vim.loop.new_check()
          local reader = coroutine.create(config.producer)
          local has_rendered = false
          local pending_blocking_value = false
          local blocking_value = nil
          local loading_count = 0
          local last_time = vim.loop.now()
          local results = {}
          local request = {cancel = should_cancel(), filter = filter, height = height}
          local function schedule_write(results0)
            has_rendered = true
            local function _6_(...)
              return write_results(results0, ...)
            end
            return vim.schedule(_6_)
          end
          local function _end()
            check:stop()
            if not request.cancel then
              if has_meta(tbl_first(results), "score") then
                local function _6_(_241, _242)
                  return (_241.score > _242.score)
                end
                partial_quicksort(results, 1, #results, view.height, _6_)
              end
              last_results = results
              return schedule_write(results)
            end
          end
          local function schedule_blocking_value(fnc)
            pending_blocking_value = true
            local function _6_()
              blocking_value = fnc()
              pending_blocking_value = false
              return nil
            end
            return vim.schedule(_6_)
          end
          local function render_loading_screen()
            loading_count = (loading_count + 1)
            local function _6_()
              if not request.cancel then
                local loading = create_loading_screen(view.width, view.height, loading_count)
                return set_lines(0, -1, loading)
              end
            end
            return vim.schedule(_6_)
          end
          local function checker()
            if pending_blocking_value then
              return nil
            end
            local current_time = vim.loop.now()
            request["cancel"] = should_cancel()
            if (coroutine.status(reader) ~= "dead") then
              local _, value = coroutine.resume(reader, request, blocking_value)
              local _7_0 = type(value)
              if (_7_0 == "function") then
                schedule_blocking_value(value)
              elseif (_7_0 == "table") then
                accumulate(results, value)
                if ((#results >= view.height) and not has_meta(tbl_first(results), "score")) then
                  schedule_write(results)
                end
              elseif (_7_0 == "nil") then
                _end()
              end
            else
              _end()
            end
            if (not has_rendered and (loading_count == 0) and (#results > 0)) then
              render_loading_screen()
            end
            if (not has_rendered and ((current_time - last_time) > 500)) then
              last_time = current_time
              return render_loading_screen()
            end
          end
          return check:start(checker)
        end
      end
      local function on_update(filter)
        last_filter = filter
        local function _6_(...)
          return on_update_unwraped(filter, view.height, ...)
        end
        return vim.schedule(_6_)
      end
      local function on_enter()
        local selected_values = vim.tbl_values(selected)
        if (#selected_values == 0) then
          local row = get_cursor_row()
          local selection = get_cursor_line(row)
          if (selection ~= "") then
            return config.select(selection, original_winnr)
          end
        else
          if config.multiselect then
            return config.multiselect(selected_values, original_winnr)
          end
        end
      end
      local function on_select_all_toggle()
        if config.multiselect then
          for _, value in ipairs(last_results) do
            local value0 = tostring(value)
            if (selected[value0] == nil) then
              selected[value0] = value0
            else
              selected[value0] = nil
            end
          end
          return write_results(last_results)
        end
      end
      local function on_select_toggle()
        if config.multiselect then
          local row = get_cursor_row()
          local selection = get_cursor_line(row)
          if (selection ~= "") then
            if selected[selection] then
              selected[selection] = nil
              return nil
            else
              selected[selection] = selection
              return nil
            end
          end
        end
      end
      local function on_key_direction(get_next_index)
        local row = get_cursor_row()
        local index = get_next_index(row)
        vim.api.nvim_win_set_cursor(view.winnr, {math.max(1, math.min(vim.api.nvim_buf_line_count(view.bufnr), index)), 0})
        return write_results(last_results)
      end
      local function on_up()
        local function _6_(_241)
          return (_241 - 1)
        end
        return on_key_direction(_6_)
      end
      local function on_down()
        local function _6_(_241)
          return (_241 + 1)
        end
        return on_key_direction(_6_)
      end
      local function on_pageup()
        local function _6_(_241)
          return (_241 - view.height)
        end
        return on_key_direction(_6_)
      end
      local function on_pagedown()
        local function _6_(_241)
          return (_241 + view.height)
        end
        return on_key_direction(_6_)
      end
      local input_view_info = create_input_view({["initial-filter"] = initial_filter, ["on-down"] = on_down, ["on-enter"] = on_enter, ["on-exit"] = on_exit, ["on-pagedown"] = on_pagedown, ["on-pageup"] = on_pageup, ["on-select-all-toggle"] = on_select_all_toggle, ["on-select-toggle"] = on_select_toggle, ["on-up"] = on_up, ["on-update"] = on_update, layout = layout, prompt = prompt})
      return table.insert(buffers, input_view_info.bufnr)
    end
    v_0_0 = run0
    _0_0["run"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["run"] = v_0_
  run = v_0_
end
return nil