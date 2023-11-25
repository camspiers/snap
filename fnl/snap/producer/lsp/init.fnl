(local snap (require :snap))

(fn report-error [error]
  (vim.notify (.. "There was an error when calling LSP: " error.message) vim.log.levels.ERROR))

(fn lsp-buf-request [bufnr action params on-value on-error]
  (vim.lsp.buf_request bufnr action params
    (fn [error result context]
      (if error
        (on-error error)
        (let [client (vim.lsp.get_client_by_id context.client_id)
              results (if (vim.tbl_islist result) result [result])]
          (on-value {: bufnr : results :offset_encoding client.offset_encoding}))))))

(fn lsp-producer [bufnr action params tranformer]
  (local (response error) (snap.async (partial lsp-buf-request bufnr action params)))
  (when error (snap.sync #(report-error error)))
  (snap.sync (partial tranformer (or response {}))))

;; Transformers take a response and return results
;; they are executed inside snap.sync
(local transformers {})

(fn transformers.locations [{: offset_encoding : results}]
  (vim.tbl_map
    #(snap.with_metas $1.filename (vim.tbl_extend :force $1 {: offset_encoding}))
    (vim.lsp.util.locations_to_items results offset_encoding)))

(fn transformers.symbols [{: bufnr : results}]
  (vim.tbl_map
    #(snap.with_metas $1.text $1)
    (vim.lsp.util.symbols_to_items results bufnr)))

(fn locations [action {: winnr}]
  (lsp-producer
    (snap.sync #(vim.api.nvim_win_get_buf winnr))
    action
    (snap.sync #(vim.lsp.util.make_position_params winnr))
    transformers.locations))

(fn references [request]
  (lsp-producer
    (snap.sync #(vim.api.nvim_win_get_buf request.winnr))
    "textDocument/references"
    (snap.sync
      #(vim.tbl_deep_extend
         :force
         (vim.lsp.util.make_position_params request.winnr)
         {:context {:includeDeclaration true}}))
    transformers.locations))

(fn symbols [request]
  (lsp-producer
    (snap.sync #(vim.api.nvim_win_get_buf request.winnr))
    "textDocument/documentSymbol"
    (snap.sync #(vim.lsp.util.make_position_params request.winnr))
    transformers.symbols))

{:definitions (partial locations "textDocument/definition")
 :implementations (partial locations "textDocument/implementation")
 :type_definitions (partial locations "textDocument/typeDefinition")
 : references
 : symbols}
