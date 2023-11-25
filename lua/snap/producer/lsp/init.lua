local _2afile_2a = "fnl/snap/producer/lsp/init.fnl"
local snap = require("snap")
local function report_error(error)
  return vim.notify(("There was an error when calling LSP: " .. error.message), vim.log.levels.ERROR)
end
local function lsp_buf_request(bufnr, action, params, on_value, on_error)
  local function _1_(error, result, context)
    if error then
      return on_error(error)
    else
      local client = vim.lsp.get_client_by_id(context.client_id)
      local results
      if vim.tbl_islist(result) then
        results = result
      else
        results = {result}
      end
      return on_value({bufnr = bufnr, results = results, offset_encoding = client.offset_encoding})
    end
  end
  return vim.lsp.buf_request(bufnr, action, params, _1_)
end
local function lsp_producer(bufnr, action, params, tranformer)
  local response, error = nil, nil
  local function _4_()
    return lsp_buf_request(bufnr, action, params)
  end
  response, error = snap.async(_4_)
  if error then
    local function _5_()
      return report_error(error)
    end
    snap.sync(_5_)
  else
  end
  local function _8_()
    local _7_ = (response or {})
    local function _9_(...)
      return tranformer(_7_, ...)
    end
    return _9_
  end
  return snap.sync(_8_())
end
local transformers = {}
transformers.locations = function(_10_)
  local _arg_11_ = _10_
  local offset_encoding = _arg_11_["offset_encoding"]
  local results = _arg_11_["results"]
  local function _12_(_241)
    return snap.with_metas(_241.filename, vim.tbl_extend("force", _241, {offset_encoding = offset_encoding}))
  end
  return vim.tbl_map(_12_, vim.lsp.util.locations_to_items(results, offset_encoding))
end
transformers.symbols = function(_13_)
  local _arg_14_ = _13_
  local bufnr = _arg_14_["bufnr"]
  local results = _arg_14_["results"]
  local function _15_(_241)
    return snap.with_metas(_241.text, _241)
  end
  return vim.tbl_map(_15_, vim.lsp.util.symbols_to_items(results, bufnr))
end
local function locations(action, _16_)
  local _arg_17_ = _16_
  local winnr = _arg_17_["winnr"]
  local function _18_()
    return vim.api.nvim_win_get_buf(winnr)
  end
  local function _19_()
    return vim.lsp.util.make_position_params(winnr)
  end
  return lsp_producer(snap.sync(_18_), action, snap.sync(_19_), transformers.locations)
end
local function references(request)
  local function _20_()
    return vim.api.nvim_win_get_buf(request.winnr)
  end
  local function _21_()
    return vim.tbl_deep_extend("force", vim.lsp.util.make_position_params(request.winnr), {context = {includeDeclaration = true}})
  end
  return lsp_producer(snap.sync(_20_), "textDocument/references", snap.sync(_21_), transformers.locations)
end
local function symbols(request)
  local function _22_()
    return vim.api.nvim_win_get_buf(request.winnr)
  end
  local function _23_()
    return vim.lsp.util.make_position_params(request.winnr)
  end
  return lsp_producer(snap.sync(_22_), "textDocument/documentSymbol", snap.sync(_23_), transformers.symbols)
end
local function _24_(...)
  return locations("textDocument/definition", ...)
end
local function _25_(...)
  return locations("textDocument/implementation", ...)
end
local function _26_(...)
  return locations("textDocument/typeDefinition", ...)
end
return {definitions = _24_, implementations = _25_, type_definitions = _26_, references = references, symbols = symbols}