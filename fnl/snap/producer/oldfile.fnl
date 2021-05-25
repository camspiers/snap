(module snap.producer.oldfile {require {snap snap}})

(fn get-oldfiles []
  (vim.tbl_filter #(= (vim.fn.empty (vim.fn.glob $1)) 0) vim.v.oldfiles))

(defn create []
  (pick-values 1 (snap.yield get-oldfiles)))
