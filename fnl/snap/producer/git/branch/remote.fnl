(let [snap (require :snap)
      general (require :snap.producer.git.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args [:branch :-r :--sort :-committerdate :--format "%(refname:short)"] : cwd}))))
