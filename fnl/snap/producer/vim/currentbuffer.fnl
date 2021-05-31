(let [snap (require :snap)]
  (fn [{: winnr}]
    (local bufnr (snap.sync (partial vim.api.nvim_win_get_buf winnr)))
    (local filename (snap.sync (partial vim.api.nvim_buf_get_name bufnr)))
    (local contents (snap.sync (partial vim.api.nvim_buf_get_lines bufnr 0 -1 false)))
    (local results [])
    (each [row line (ipairs contents)]
      (table.insert results (snap.with_metas line {: filename : row})))
    (coroutine.yield results)))
