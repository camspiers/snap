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
  local function _4_(...)
    return lsp_buf_request(bufnr, action, params, ...)
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
local function get_bufnr(winnr)
  local function _10_()
    return vim.api.nvim_win_get_buf(winnr)
  end
  return snap.sync(_10_)
end
local function get_params(winnr)
  local function _11_()
    return vim.lsp.util.make_position_params(winnr)
  end
  return snap.sync(_11_)
end
local transformers = {}
transformers.locations = function(_12_)
  local _arg_13_ = _12_
  local offset_encoding = _arg_13_["offset_encoding"]
  local results = _arg_13_["results"]
  local function _14_(_241)
    return snap.with_metas(_241.filename, vim.tbl_extend("force", _241, {offset_encoding = offset_encoding}))
  end
  return vim.tbl_map(_14_, vim.lsp.util.locations_to_items(results, offset_encoding))
end
transformers.symbols = function(_15_)
  local _arg_16_ = _15_
  local bufnr = _arg_16_["bufnr"]
  local results = _arg_16_["results"]
  local function _17_(_241)
    return snap.with_metas(_241.text, _241)
  end
  return vim.tbl_map(_17_, vim.lsp.util.symbols_to_items(results, bufnr))
end
local function locations(action, _18_)
  local _arg_19_ = _18_
  local winnr = _arg_19_["winnr"]
  return lsp_producer(get_bufnr(winnr), action, get_params(winnr), transformers.locations)
end
local function references(_20_)
  local _arg_21_ = _20_
  local winnr = _arg_21_["winnr"]
  return lsp_producer(get_bufnr(winnr), "textDocument/references", vim.tbl_deep_extend("force", get_params(winnr), {context = {includeDeclaration = true}}), transformers.locations)
end
local function symbols(_22_)
  local _arg_23_ = _22_
  local winnr = _arg_23_["winnr"]
  return lsp_producer(get_bufnr(winnr), "textDocument/documentSymbol", get_params(winnr), transformers.symbols)
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