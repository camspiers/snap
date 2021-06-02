(module snap.common.buffer)

;; Creates a namespace for highlighting
(local namespace (vim.api.nvim_create_namespace :Snap))

(defn set-lines [bufnr start end lines]
  "Helper to set lines to results view"
  (vim.api.nvim_buf_set_lines bufnr start end false lines))

(defn add-selected-highlight [bufnr row]
  "Helper function for adding selected highlighting"
  (vim.api.nvim_buf_add_highlight bufnr namespace :Comment (- row 1) 0 -1))

(defn add-positions-highlight [bufnr row positions]
  "Helper function for adding positions highlights"
  (local line (- row 1))
  (each [_ col (ipairs positions)]
    (vim.api.nvim_buf_add_highlight bufnr namespace :Search line (- col 1) col)))

(defn create []
  "Creates a scratch buffer"
  (vim.api.nvim_create_buf false true))

