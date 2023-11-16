(let [snap (require :snap)
      tbl (snap.get :common.tbl)]

  (fn get-marks [winnr]
    (local bufnr (vim.api.nvim_win_get_buf winnr))
    (vim.tbl_map
      (fn [mark]
        (local lnum (. mark.pos 2))
        (local content (. (vim.api.nvim_buf_get_lines bufnr (- lnum  1) lnum false) 1))
        ;; Modify the mark so that it is consistent with global marks
        (tset mark :file (vim.api.nvim_buf_get_name bufnr))
        (snap.with_metas (string.format "%s : %s" mark.mark content) mark))
      (vim.fn.getmarklist bufnr)))

  (fn [{: winnr}] (snap.sync (partial get-marks winnr))))
