(module snap.common.buffer)

;; Creates a namespace for highlighting
(local namespace (vim.api.nvim_create_namespace :Snap))

;; Helper to set lines to results view
(defn set-lines [bufnr start end lines]
  (vim.api.nvim_buf_set_lines bufnr start end false lines))

;; Helper function for adding selected highlighting
(defn add-selected-highlight [bufnr row]
  (vim.api.nvim_buf_add_highlight bufnr namespace :Comment (- row 1) 0 -1))

;; Helper function for adding positions highlights
(defn add-positions-highlight [bufnr row positions]
  (local line (- row 1))
  (each [_ col (ipairs positions)]
    (vim.api.nvim_buf_add_highlight bufnr namespace :Search line (- col 1) col)))

;; Creates a scratch buffer, used for both results and input
(defn create [] (vim.api.nvim_create_buf false true))

