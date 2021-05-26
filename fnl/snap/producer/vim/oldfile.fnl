(fn get-oldfiles []
  (vim.tbl_filter #(= (vim.fn.empty (vim.fn.glob $1)) 0) vim.v.oldfiles))

(let [snap (require :snap)]
  (fn []
    (snap.sync get-oldfiles)))

