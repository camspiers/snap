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
local get
do
  local v_0_
  do
    local v_0_0
    local function get0(mod)
      return require(string.format("snap.%s", mod))
    end
    v_0_0 = get0
    _0_0["get"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get"] = v_0_
  get = v_0_
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
      if request.canceled() then
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
      local function _2_()
        if (coroutine.status(reader) ~= "dead") then
          return resume(reader, request)
        end
      end
      return _2_
    end
    v_0_0 = consume0
    _0_0["consume"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["consume"] = v_0_
  consume = v_0_
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
local register
do
  local v_0_
  do
    local v_0_0 = {}
    _0_0["register"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["register"] = v_0_
  register = v_0_
end
register.clean = function(group)
  register[group] = nil
  return nil
end
register.run = function(group, fnc)
  local _2_
  do
    local res_0_ = register[group]
    local function _3_()
      local res_0_0 = (res_0_)[fnc]
      return (res_0_0 and res_0_0)
    end
    _2_ = (res_0_ and _3_())
  end
  if _2_ then
    return register[group][fnc]()
  end
end
register["get-by-template"] = function(group, fnc, pre, post)
  local group_fns = (register[group] or {})
  local id = string.format("%s", fnc)
  register[group] = group_fns
  if (group_fns[id] == nil) then
    group_fns[id] = fnc
  end
  return string.format("%slua require'snap'.register.run('%s', '%s')%s", pre, group, id, post)
end
register["get-map-call"] = function(group, fnc)
  return register["get-by-template"](group, fnc, "<Cmd>", "<CR>")
end
register["get-autocmd-call"] = function(group, fnc)
  return register["get-by-template"](group, fnc, ":", "")
end
register.buf_map = function(bufnr, modes, keys, fnc, opts)
  local rhs = register["get-map-call"](tostring(bufnr), fnc)
  for _, key in ipairs(keys) do
    for _0, mode in ipairs(modes) do
      vim.api.nvim_buf_set_keymap(bufnr, mode, key, rhs, (opts or {}))
    end
  end
  return nil
end
register.map = function(modes, keys, fnc, opts)
  local rhs = register["get-map-call"]("global", fnc)
  for _, key in ipairs(keys) do
    for _0, mode in ipairs(modes) do
      vim.api.nvim_set_keymap(mode, key, rhs, (opts or {}))
    end
  end
  return nil
end
local border_size = 1
local padding_size = 1
local function create_input_layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local _2_
  if config["has-views"] then
    _2_ = math.floor((width * 0.55))
  else
    _2_ = width
  end
  return {col = col, focusable = true, height = 1, row = ((row + height) - border_size), width = _2_}
end
local function create_results_layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local _2_
  if config["has-views"] then
    _2_ = math.floor((width * 0.55))
  else
    _2_ = width
  end
  return {col = col, focusable = false, height = (height - border_size - border_size - padding_size), row = row, width = _2_}
end
local function create_view_layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local index = (config.index - 1)
  local offset = math.floor((width * 0.55))
  local height_with_border = math.floor((height / config["total-views"]))
  local height0 = (height_with_border - (index * border_size))
  return {col = (col + offset + (border_size * 2) + padding_size), focusable = false, height = height0, row = (row + (index * height_with_border) + (index * border_size) + (index * padding_size)), width = (width - offset)}
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
  local layout = create_results_layout(config)
  local winnr = create_window(bufnr, layout)
  vim.api.nvim_win_set_option(winnr, "cursorline", true)
  vim.api.nvim_win_set_option(winnr, "wrap", false)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
  return {bufnr = bufnr, height = layout.height, width = layout.width, winnr = winnr}
end
local function create_view(config)
  local bufnr = create_buffer()
  local layout = create_view_layout(config)
  local winnr = create_window(bufnr, layout)
  vim.api.nvim_win_set_option(winnr, "cursorline", false)
  vim.api.nvim_win_set_option(winnr, "wrap", false)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "on")
  return {bufnr = bufnr, height = layout.height, width = layout.width, winnr = winnr}
end
local function create_input_view(config)
  local bufnr = create_buffer()
  local layout = create_input_layout(config)
  local winnr = create_window(bufnr, layout)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
  vim.fn.prompt_setprompt(bufnr, config.prompt)
  vim.api.nvim_command("startinsert")
  if (config.initial_filter ~= "") then
    vim.api.nvim_feedkeys(config.initial_filter, "n", false)
  end
  local function get_filter()
    local contents = tbl_first(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false))
    if contents then
      return contents:sub((#config.prompt + 1))
    else
      return ""
    end
  end
  local exited = false
  local function on_exit()
    if not exited then
      exited = true
      return config["on-exit"]()
    end
  end
  local function on_enter()
    config["on-enter"]()
    return config["on-exit"]()
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
    return register.clean(bufnr)
  end
  register.buf_map(bufnr, {"n", "i"}, {"<CR>"}, on_enter)
  register.buf_map(bufnr, {"n", "i"}, {"<Up>", "<C-k>", "<C-p>"}, config["on-up"])
  register.buf_map(bufnr, {"n", "i"}, {"<Down>", "<C-j>", "<C-n>"}, config["on-down"])
  register.buf_map(bufnr, {"n", "i"}, {"<Esc>", "<C-c>"}, on_exit)
  register.buf_map(bufnr, {"n", "i"}, {"<Tab>"}, on_tab)
  register.buf_map(bufnr, {"n", "i"}, {"<S-Tab>"}, on_shifttab)
  register.buf_map(bufnr, {"n", "i"}, {"<C-a>"}, on_ctrla)
  register.buf_map(bufnr, {"n", "i"}, {"<C-d>"}, config["on-pagedown"])
  register.buf_map(bufnr, {"n", "i"}, {"<C-u>"}, config["on-pageup"])
  vim.api.nvim_command(string.format("autocmd! WinLeave <buffer=%s> %s", bufnr, register["get-autocmd-call"](tostring(bufnr), on_exit)))
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
local run
do
  local v_0_
  do
    local v_0_0
    local function run0(config)
      assert((type(config) == "table"), "snap.run config must be a table")
      assert(config.producer, "snap.run config must have a producer")
      assert((type(config.producer) == "function"), "snap.run 'producer' must be a function")
      assert(config.select, "snap.run config must have a select")
      assert((type(config.select) == "function"), "snap.run 'select' must be a function")
      if config.multiselect then
        assert((type(config.multiselect) == "function"), "snap.run 'multiselect' must be a function")
      end
      if config.prompt then
        assert((type(config.prompt) == "string"), "snap.run 'prompt' must be a string")
      end
      if config.layout then
        assert((type(config.layout) == "function"), "snap.run 'layout' must be a function")
      end
      if config.views then
        assert((type(config.views) == "table"), "snap.run 'views' must be a table")
        for _, view in ipairs(config.views) do
          assert((type(view) == "function"), "snap.run each view in 'views' must be a function")
        end
      end
      local last_results = {}
      local exit = false
      local buffers = {}
      local layout = (config.layout or (get("layout")).centered)
      local initial_filter = (config.initial_filter or "")
      local namespace = vim.api.nvim_create_namespace("Snap")
      local original_winnr = vim.api.nvim_get_current_win()
      local prompt = string.format("%s> ", (config.prompt or "Find"))
      local selected = {}
      local cursor_row = 1
      local function on_exit()
        exit = true
        last_results = {}
        selected = nil
        vim.api.nvim_set_current_win(original_winnr)
        for _, bufnr in ipairs(buffers) do
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, {force = true})
          end
        end
        return vim.api.nvim_command("stopinsert")
      end
      local total_views
      if config.views then
        total_views = #config.views
      else
        total_views = 0
      end
      local has_views = (total_views > 0)
      local views = {}
      if has_views then
        for index, producer in ipairs(config.views) do
          local view = {producer = producer, view = create_view({["total-views"] = total_views, index = index, layout = layout})}
          table.insert(views, view)
          table.insert(buffers, view.view.bufnr)
        end
      end
      local results_view = create_results_view({["has-views"] = has_views, layout = layout})
      table.insert(buffers, results_view.bufnr)
      local function add_selected_highlight(row)
        return vim.api.nvim_buf_add_highlight(results_view.bufnr, namespace, "Comment", (row - 1), 0, -1)
      end
      local function add_positions_highlight(row, positions)
        local line = (row - 1)
        for _, col in ipairs(positions) do
          vim.api.nvim_buf_add_highlight(results_view.bufnr, namespace, "Search", line, (col - 1), col)
        end
        return nil
      end
      local function set_lines(start, _end, lines)
        return vim.api.nvim_buf_set_lines(results_view.bufnr, start, _end, false, lines)
      end
      local function get_selection()
        return tostring(last_results[cursor_row])
      end
      local function create_slow_api()
        local slow_api = {pending = false, value = nil}
        slow_api.schedule = function(fnc)
          slow_api["pending"] = true
          local function _9_()
            slow_api["value"] = fnc()
            slow_api["pending"] = false
            return nil
          end
          return vim.schedule(_9_)
        end
        slow_api.free = function()
          slow_api["value"] = nil
          return nil
        end
        return slow_api
      end
      local function create_request(_9_0)
        local _arg_0_ = _9_0
        local body = _arg_0_["body"]
        local cancel = _arg_0_["cancel"]
        assert((type(body) == "table"), "body must be a table")
        assert((type(cancel) == "function"), "cancel must be a function")
        local request = {["is-canceled"] = false}
        for key, value in pairs(body) do
          request[key] = value
        end
        request.cancel = function()
          request["is-canceled"] = true
          return nil
        end
        request.canceled = function()
          return (exit or request["is-canceled"] or cancel(request))
        end
        return request
      end
      local function schedule_producer(_10_0)
        local _arg_0_ = _10_0
        local on_end = _arg_0_["on-end"]
        local on_value = _arg_0_["on-value"]
        local producer = _arg_0_["producer"]
        local request = _arg_0_["request"]
        if not request.canceled() then
          local idle = vim.loop.new_idle()
          local thread = coroutine.create(producer)
          local slow_api = create_slow_api()
          local stop
          local function _11_()
            idle:stop()
            if on_end then
              return on_end()
            end
          end
          stop = _11_
          local function _12_()
            if slow_api.pending then
              return nil
            elseif (coroutine.status(thread) ~= "dead") then
              local _, value = coroutine.resume(thread, request, slow_api.value)
              slow_api.free()
              local _13_0 = type(value)
              if (_13_0 == "function") then
                return slow_api.schedule(value)
              elseif (_13_0 == "nil") then
                return stop()
              else
                local _0 = _13_0
                if on_value then
                  return on_value(value)
                end
              end
            else
              return stop()
            end
          end
          return idle:start(_12_)
        end
      end
      local function write_results(results)
        if not exit then
          do
            local result_size = #results
            if (result_size == 0) then
              set_lines(0, -1, {})
            else
              local max = (results_view.height + cursor_row)
              local partial_results = {}
              for _, result in ipairs(results) do
                if (max == #partial_results) then break end
                table.insert(partial_results, tostring(result))
              end
              set_lines(0, -1, partial_results)
              for row, result in pairs(partial_results) do
                if has_meta(results[row], "positions") then
                  add_positions_highlight(row, results[row].positions)
                end
                if selected[result] then
                  add_selected_highlight(row)
                end
              end
            end
          end
          if has_views then
            for _, _11_0 in ipairs(views) do
              local _each_0_ = _11_0
              local producer = _each_0_["producer"]
              local _each_1_ = _each_0_["view"]
              local bufnr = _each_1_["bufnr"]
              local winnr = _each_1_["winnr"]
              local request
              local function _12_(request0)
                return (request0.selection ~= get_selection())
              end
              request = create_request({body = {bufnr = bufnr, selection = get_selection(), winnr = winnr}, cancel = _12_})
              schedule_producer({producer = producer, request = request})
            end
            return nil
          end
        end
      end
      local function on_update(filter)
        local has_rendered = false
        local loading_count = 0
        local last_time = vim.loop.now()
        local results = {}
        local request
        local function _11_(request0)
          return (request0.filter ~= filter)
        end
        request = create_request({body = {filter = filter, height = results_view.height}, cancel = _11_})
        local config0 = {producer = config.producer, request = request}
        local function schedule_results_write(results0)
          has_rendered = true
          local function _12_(...)
            return write_results(results0, ...)
          end
          return vim.schedule(_12_)
        end
        local function render_loading_screen()
          loading_count = (loading_count + 1)
          local function _12_()
            if not request.canceled() then
              local loading = create_loading_screen(results_view.width, results_view.height, loading_count)
              return set_lines(0, -1, loading)
            end
          end
          return vim.schedule(_12_)
        end
        config0["on-end"] = function()
          if has_meta(tbl_first(results), "score") then
            local function _12_(_241, _242)
              return (_241.score > _242.score)
            end
            partial_quicksort(results, 1, #results, (results_view.height + cursor_row), _12_)
          end
          last_results = results
          schedule_results_write(last_results)
          results = {}
          return nil
        end
        config0["on-value"] = function(value)
          assert((type(value) == "table"), "Main producer yielded a non-yieldable value")
          local current_time = vim.loop.now()
          accumulate(results, value)
          if ((#last_results == 0) and (#results >= results_view.height) and not has_meta(tbl_first(results), "score")) then
            last_results = results
            schedule_results_write(results)
          end
          if (not has_rendered and (loading_count == 0) and (#results > 0)) then
            render_loading_screen()
          end
          if (not has_rendered and ((current_time - last_time) > 500)) then
            last_time = current_time
            return render_loading_screen()
          end
        end
        return schedule_producer(config0)
      end
      local function on_enter()
        local selected_values = vim.tbl_values(selected)
        if (#selected_values == 0) then
          local selection = get_selection()
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
          local selection = get_selection()
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
        local line_count = vim.api.nvim_buf_line_count(results_view.bufnr)
        local index = math.max(1, math.min(line_count, get_next_index(cursor_row)))
        vim.api.nvim_win_set_cursor(results_view.winnr, {index, 0})
        cursor_row = index
        return write_results(last_results)
      end
      local function on_up()
        local function _11_(_241)
          return (_241 - 1)
        end
        return on_key_direction(_11_)
      end
      local function on_down()
        local function _11_(_241)
          return (_241 + 1)
        end
        return on_key_direction(_11_)
      end
      local function on_pageup()
        local function _11_(_241)
          return (_241 - results_view.height)
        end
        return on_key_direction(_11_)
      end
      local function on_pagedown()
        local function _11_(_241)
          return (_241 + results_view.height)
        end
        return on_key_direction(_11_)
      end
      local input_view_info = create_input_view({["has-views"] = has_views, ["on-down"] = on_down, ["on-enter"] = on_enter, ["on-exit"] = on_exit, ["on-pagedown"] = on_pagedown, ["on-pageup"] = on_pageup, ["on-select-all-toggle"] = on_select_all_toggle, ["on-select-toggle"] = on_select_toggle, ["on-up"] = on_up, ["on-update"] = on_update, initial_filter = initial_filter, layout = layout, prompt = prompt})
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