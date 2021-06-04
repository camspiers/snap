(let [snap (require :snap)
      tbl (snap.get :common.tbl)]

  (fn get-jumplist []
    (vim.tbl_map
      (fn [item]
        (snap.with_metas 
          (string.format "%s:%s:%s" (or item.filename (vim.api.nvim_buf_get_name item.bufnr)) item.lnum item.col)
          item))
      (vim.tbl_filter
        #(vim.api.nvim_buf_is_valid $1.bufnr)
        (tbl.first (vim.fn.getjumplist)))))

  (fn []
    (snap.sync get-jumplist)))

