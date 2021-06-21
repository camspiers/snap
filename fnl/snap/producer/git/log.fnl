(fn parse [line]
  (local (end) (line:find " "))
  {:hash (line:sub 1 (- end 1)) :comment (line:sub (+ end 1) -1)})

(let [snap (require :snap)
      io (require :snap.common.io)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (each [data err cancel (io.spawn :git [:log :--oneline] cwd)]
        (if
          (request.canceled) (do (cancel) (coroutine.yield nil))
          (not= err "") (coroutine.yield nil)
          (= data "") (coroutine.yield [])
          (do
            (local results (vim.split (data:sub 1 -2) "\n" true))
            (if
              (> (length results) 0)
              (coroutine.yield
                (vim.tbl_map #(snap.with_metas $1 (parse $1)) results))
              (snap.continue))))))))
