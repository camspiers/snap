(let [snap (require :snap)
      general (require :snap.producer.git.general)]
  (fn process-line [line]
    (local (end) (line:find " "))
    (snap.with_metas
      ;; TODO: Required because fzy errors when each line is too long
      (line:sub 1 200)
      {:hash (line:sub 1 (- end 1))
       :comment (line:sub (+ end 1) -1)}))

  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (each [results (snap.consume #(general $1 {:args [:log :--oneline] : cwd}) request)]
        (match (type results)
          "table" (coroutine.yield (vim.tbl_map process-line results))
          "nil" (coroutine.yield nil))))))

