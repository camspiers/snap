(fn get-buffers []
  (vim.tbl_map #(vim.fn.bufname $1)
               (vim.tbl_filter #(and (not= (vim.fn.bufname $1) "")
                                     (= (vim.fn.buflisted $1) 1)
                                     (= (vim.fn.bufexists $1) 1))
                               (vim.api.nvim_list_bufs))))

(let [snap (require :snap)]
  (fn []
    (snap.sync get-buffers)))

