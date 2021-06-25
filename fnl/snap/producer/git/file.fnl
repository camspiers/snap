(let [snap (require :snap)
      general (snap.get :producer.git.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
        (.. (general request {:args [:ls-files] : cwd}) (general request {:args [:ls-files :-o] : cwd})))))
