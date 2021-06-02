local _2afile_2a = "fnl/snap/init.fnl"
local _0_
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
    return {require("snap.common.buffer"), require("snap.common.register"), require("snap.common.tbl"), require("snap.common.window")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {buffer = "snap.common.buffer", register = "snap.common.register", tbl = "snap.common.tbl", window = "snap.common.window"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local buffer = _local_0_[1]
local register = _local_0_[2]
local tbl = _local_0_[3]
local window = _local_0_[4]
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local register0
do
  local v_0_
  do
    local v_0_0 = register
    _0_["register"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["register"] = v_0_
  register0 = v_0_
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
    _0_["get"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get"] = v_0_
  get = v_0_
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
    _0_["sync"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["sync"] = v_0_
  sync = v_0_
end
local continue_value = {continue = true}
local continue
do
  local v_0_
  do
    local v_0_0
    local function continue0(on_cancel)
      return coroutine.yield(continue_value, on_cancel)
    end
    v_0_0 = continue0
    _0_["continue"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["continue"] = v_0_
  continue = v_0_
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
    _0_["resume"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
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
        if (coroutine.status(reader) == "dead") then
          reader = nil
          return nil
        else
          return resume(reader, request)
        end
      end
      return _3_
    end
    v_0_0 = consume0
    _0_["consume"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["consume"] = v_0_
  consume = v_0_
end
local meta_tbl
do
  local v_0_
  do
    local v_0_0
    local function _3_(_241)
      return _241.result
    end
    v_0_0 = {__tostring = _3_}
    _0_["meta-tbl"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["meta-tbl"] = v_0_
  meta_tbl = v_0_
end
local meta_result
do
  local v_0_
  do
    local v_0_0
    local function meta_result0(result)
      local _3_ = type(result)
      if (_3_ == "string") then
        local meta_result1 = {result = result}
        setmetatable(meta_result1, meta_tbl)
        return meta_result1
      elseif (_3_ == "table") then
        assert((getmetatable(result) == meta_tbl))
        return result
      end
    end
    v_0_0 = meta_result0
    _0_["meta_result"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
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
      do end (meta_result0)[field] = value
      return meta_result0
    end
    v_0_0 = with_meta0
    _0_["with_meta"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["with_meta"] = v_0_
  with_meta = v_0_
end
local with_metas
do
  local v_0_
  do
    local v_0_0
    local function with_metas0(result, data)
      local meta_result0 = meta_result(result)
      for field, value in pairs(data) do
        meta_result0[field] = value
      end
      return meta_result0
    end
    v_0_0 = with_metas0
    _0_["with_metas"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["with_metas"] = v_0_
  with_metas = v_0_
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
    _0_["has_meta"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["has_meta"] = v_0_
  has_meta = v_0_
end
local border_size = 1
local padding_size = 1
local views_width = 0.5
local function create_input_layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local _3_
  if config["has-views"] then
    _3_ = math.floor((width * views_width))
  else
    _3_ = width
  end
  return {col = col, focusable = true, height = 1, row = ((row + height) - padding_size), width = _3_}
end
local function create_results_layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local _3_
  if config["has-views"] then
    _3_ = math.floor((width * views_width))
  else
    _3_ = width
  end
  return {col = col, focusable = false, height = (height - border_size - border_size - padding_size), row = row, width = _3_}
end
local function create_view_layout(config)
  local _let_0_ = config.layout()
  local col = _let_0_["col"]
  local height = _let_0_["height"]
  local row = _let_0_["row"]
  local width = _let_0_["width"]
  local index = (config.index - 1)
  local border = (index * border_size)
  local padding = (index * padding_size)
  local total_borders = ((config["total-views"] - 1) * border_size)
  local total_paddings = ((config["total-views"] - 1) * padding_size)
  local sizes = tbl.allocate((height - total_borders - total_paddings), config["total-views"])
  local height0 = sizes[config.index]
  local col_offset = math.floor((width * views_width))
  return {col = (col + col_offset + (border_size * 2) + padding_size), focusable = false, height = height0, row = (row + tbl.sum(tbl.take(sizes, index)) + border + padding), width = (width - col_offset)}
end
local function create_results_view(config)
  local bufnr = buffer.create()
  local layout = create_results_layout(config)
  local winnr = window.create(bufnr, layout)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
  vim.api.nvim_buf_set_option(bufnr, "textwidth", 0)
  vim.api.nvim_buf_set_option(bufnr, "wrapmargin", 0)
  vim.api.nvim_win_set_option(winnr, "wrap", false)
  vim.api.nvim_win_set_option(winnr, "cursorline", true)
  return {bufnr = bufnr, height = layout.height, width = layout.width, winnr = winnr}
end
local function create_view(config)
  local bufnr = buffer.create()
  local layout = create_view_layout(config)
  local winnr = window.create(bufnr, layout)
  vim.api.nvim_win_set_option(winnr, "cursorline", false)
  vim.api.nvim_win_set_option(winnr, "wrap", false)
  return {bufnr = bufnr, height = layout.height, width = layout.width, winnr = winnr}
end
local function create_input_view(config)
  local bufnr = buffer.create()
  local layout = create_input_layout(config)
  local winnr = window.create(bufnr, layout)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
  vim.fn.prompt_setprompt(bufnr, config.prompt)
  vim.api.nvim_command("startinsert")
  local function get_filter()
    local contents = tbl.first(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false))
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
  local function _3_()
    return config["on-update"](get_filter())
  end
  on_lines = _3_
  local function on_detach()
    return register0.clean(bufnr)
  end
  register0["buf-map"](bufnr, {"n", "i"}, {"<CR>"}, on_enter)
  register0["buf-map"](bufnr, {"n", "i"}, {"<Up>", "<C-k>", "<C-p>"}, config["on-up"])
  register0["buf-map"](bufnr, {"n", "i"}, {"<Down>", "<C-j>", "<C-n>"}, config["on-down"])
  register0["buf-map"](bufnr, {"n", "i"}, {"<Esc>", "<C-c>"}, on_exit)
  register0["buf-map"](bufnr, {"n", "i"}, {"<Tab>"}, on_tab)
  register0["buf-map"](bufnr, {"n", "i"}, {"<S-Tab>"}, on_shifttab)
  register0["buf-map"](bufnr, {"n", "i"}, {"<C-a>"}, on_ctrla)
  register0["buf-map"](bufnr, {"n", "i"}, {"<C-d>"}, config["on-pagedown"])
  register0["buf-map"](bufnr, {"n", "i"}, {"<C-u>"}, config["on-pageup"])
  vim.api.nvim_command(string.format("autocmd! WinLeave <buffer=%s> %s", bufnr, register0["get-autocmd-call"](tostring(bufnr), on_exit)))
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
local function create_slow_api()
  local slow_api = {pending = false, value = nil}
  slow_api.schedule = function(fnc)
    slow_api["pending"] = true
    local function _3_()
      slow_api["value"] = fnc()
      do end (slow_api)["pending"] = false
      return nil
    end
    return vim.schedule(_3_)
  end
  return slow_api
end
local function schedule_producer(_3_)
  local _arg_0_ = _3_
  local on_end = _arg_0_["on-end"]
  local on_value = _arg_0_["on-value"]
  local producer = _arg_0_["producer"]
  local request = _arg_0_["request"]
  if not request.canceled() then
    local idle = vim.loop.new_idle()
    local thread = coroutine.create(producer)
    local slow_api = create_slow_api()
    local function stop()
      idle:stop()
      idle = nil
      thread = nil
      slow_api = nil
      if on_end then
        return on_end()
      end
    end
    local function start()
      if slow_api.pending then
        return nil
      elseif (coroutine.status(thread) ~= "dead") then
        local _, value, on_cancel = coroutine.resume(thread, request, slow_api.value)
        local _4_ = type(value)
        if (_4_ == "function") then
          return slow_api.schedule(value)
        elseif (_4_ == "nil") then
          return stop()
        else
          local function _5_()
            return (value == continue_value)
          end
          if ((_4_ == "table") and _5_()) then
            if request.canceled() then
              if on_cancel then
                on_cancel()
              end
              return stop()
            else
              return nil
            end
          else
            local _0 = _4_
            if on_value then
              return on_value(value)
            end
          end
        end
      else
        return stop()
      end
    end
    return idle:start(start)
  end
end
local function create_request(config)
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
      local last_requested_filter = ""
      local last_requested_selection = nil
      local exit = false
      local buffers = {}
      local layout = (config.layout or (get("layout")).centered)
      local initial_filter = (config.initial_filter or "")
      local original_winnr = vim.api.nvim_get_current_win()
      local prompt = string.format("%s> ", (config.prompt or "Find"))
      local selected = {}
      local cursor_row = 1
      local function on_exit()
        exit = true
        last_results = {}
        selected = nil
        config["producer"] = nil
        config["views"] = nil
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
      local function get_selection()
        return last_results[cursor_row]
      end
      local function write_results(results)
        if not exit then
          do
            local result_size = #results
            if (result_size == 0) then
              buffer["set-lines"](results_view.bufnr, 0, -1, {})
            else
              local max = (results_view.height + cursor_row)
              local partial_results = {}
              for _, result in ipairs(results) do
                if (max == #partial_results) then break end
                table.insert(partial_results, tostring(result))
              end
              buffer["set-lines"](results_view.bufnr, 0, -1, partial_results)
              for row, _ in pairs(partial_results) do
                local result = results[row]
                if has_meta(result, "positions") then
                  buffer["add-positions-highlight"](results_view.bufnr, row, result.positions)
                end
                if selected[tostring(result)] then
                  buffer["add-selected-highlight"](results_view.bufnr, row)
                end
              end
            end
            if (cursor_row > result_size) then
              cursor_row = math.max(1, result_size)
            end
          end
          local selection = get_selection()
          if (has_views and (last_requested_selection ~= selection)) then
            last_requested_selection = selection
            if (selection == nil) then
              local function _10_()
                for _, _11_ in ipairs(views) do
                  local _each_0_ = _11_
                  local _each_1_ = _each_0_["view"]
                  local bufnr = _each_1_["bufnr"]
                  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
                end
                return nil
              end
              return vim.schedule(_10_)
            else
              local function _10_()
                for _, _11_ in ipairs(views) do
                  local _each_0_ = _11_
                  local producer = _each_0_["producer"]
                  local _each_1_ = _each_0_["view"]
                  local bufnr = _each_1_["bufnr"]
                  local winnr = _each_1_["winnr"]
                  local request
                  local function _12_(request0)
                    return (exit or (request0.selection ~= get_selection()))
                  end
                  request = create_request({body = {bufnr = bufnr, selection = selection, winnr = winnr}, cancel = _12_})
                  schedule_producer({producer = producer, request = request})
                end
                return nil
              end
              return vim.schedule(_10_)
            end
          end
        end
      end
      local function on_update(filter)
        last_requested_filter = filter
        local has_rendered = false
        local loading_count = 0
        local last_time = vim.loop.now()
        local results = {}
        local function cancel(request)
          return (exit or (request.filter ~= last_requested_filter))
        end
        local body = {filter = filter, height = results_view.height, winnr = original_winnr}
        local request = create_request({body = body, cancel = cancel})
        local config0 = {producer = config.producer, request = request}
        local function schedule_results_write(results0)
          has_rendered = true
          local function _10_(...)
            return write_results(results0, ...)
          end
          return vim.schedule(_10_)
        end
        local function render_loading_screen()
          loading_count = (loading_count + 1)
          local function _10_()
            if not request.canceled() then
              local loading = create_loading_screen(results_view.width, results_view.height, loading_count)
              return buffer["set-lines"](results_view.bufnr, 0, -1, loading)
            end
          end
          return vim.schedule(_10_)
        end
        config0["on-end"] = function()
          if has_meta(tbl.first(results), "score") then
            local function _10_(_241, _242)
              return (_241.score > _242.score)
            end
            tbl["partial-quicksort"](results, 1, #results, (results_view.height + cursor_row), _10_)
          end
          last_results = results
          schedule_results_write(last_results)
          results = {}
          return nil
        end
        config0["on-value"] = function(value)
          assert((type(value) == "table"), "Main producer yielded a non-yieldable value")
          local current_time = vim.loop.now()
          tbl.accumulate(results, value)
          if ((#last_results == 0) and (#results >= results_view.height) and not has_meta(tbl.first(results), "score")) then
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
        local selected_values = vim.tbl_keys(selected)
        if (#selected_values == 0) then
          local selection = get_selection()
          if (selection ~= nil) then
            local function _10_(...)
              return config.select(selection, original_winnr, ...)
            end
            return vim.schedule(_10_)
          end
        else
          if config.multiselect then
            local function _10_(...)
              return config.multiselect(selected_values, original_winnr, ...)
            end
            return vim.schedule(_10_)
          end
        end
      end
      local function on_select_all_toggle()
        if config.multiselect then
          for _, value in ipairs(last_results) do
            local value0 = tostring(value)
            if selected[value0] then
              selected[value0] = nil
            else
              selected[value0] = true
            end
          end
          return write_results(last_results)
        end
      end
      local function on_select_toggle()
        if config.multiselect then
          local selection = get_selection()
          if (selection ~= nil) then
            local value = tostring(selection)
            if selected[value] then
              selected[value] = nil
              return nil
            else
              selected[value] = true
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
        local function _10_(_241)
          return (_241 - 1)
        end
        return on_key_direction(_10_)
      end
      local function on_down()
        local function _10_(_241)
          return (_241 + 1)
        end
        return on_key_direction(_10_)
      end
      local function on_pageup()
        local function _10_(_241)
          return (_241 - results_view.height)
        end
        return on_key_direction(_10_)
      end
      local function on_pagedown()
        local function _10_(_241)
          return (_241 + results_view.height)
        end
        return on_key_direction(_10_)
      end
      local input_view_info = create_input_view({["has-views"] = has_views, ["on-down"] = on_down, ["on-enter"] = on_enter, ["on-exit"] = on_exit, ["on-pagedown"] = on_pagedown, ["on-pageup"] = on_pageup, ["on-select-all-toggle"] = on_select_all_toggle, ["on-select-toggle"] = on_select_toggle, ["on-up"] = on_up, ["on-update"] = on_update, layout = layout, prompt = prompt})
      table.insert(buffers, input_view_info.bufnr)
      if (initial_filter ~= "") then
        vim.api.nvim_feedkeys(initial_filter, "n", false)
      end
      return nil
    end
    v_0_0 = run0
    _0_["run"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["run"] = v_0_
  run = v_0_
end
return nil