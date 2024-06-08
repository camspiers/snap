(let [snap (require :snap)
      io (snap.get :common.io)
      string (snap.get :common.string)]
  (fn [request {: args}]
    "ttags - https://github.com/tex/ttags
     global - https://www.gnu.org/software/global"
    (var largs args)
    (if
      (= request.filter "")
      (coroutine.yield nil)
      (let [cwd (snap.sync vim.fn.getcwd)
            cmd (if (io.exists (.. cwd "/" ".ttags.0.db"))
                    :ttags
                    (io.exists (.. cwd "/" "GTAGS"))
                    (do
                      (table.insert largs "--result=grep")
                      :global)
                    (coroutine.yield nil))]
        (each [data err cancel (io.spawn cmd largs cwd)]
          (if
            (request.canceled) (do (cancel) (coroutine.yield nil))
            (not= err "") (coroutine.yield nil)
            (= data "") (snap.continue)
            (coroutine.yield (string.split data))))))))
