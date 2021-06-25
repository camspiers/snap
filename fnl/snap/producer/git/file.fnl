(let [snap (require :snap)
      general (snap.get :producer.git.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
        (if (not= (general request {:args [:ls-files :-o] : cwd}) nil)
            (.. (general request {:args [:ls-files] : cwd}) (general request {:args [:ls-files :-o] : cwd}))))
                (general request {:args [:ls-files] : cwd})))

