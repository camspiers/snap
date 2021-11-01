(module snap.select.insert)
 t

(defn select [selection winnr]

  (vim.api.nvim_put [(tostring selection)] "c" true true))
