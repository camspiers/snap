(module snap.select.tmux.switch {require {io snap.common.io}})

(defn select [selection winnr]
  (io.spawn :tmux [:switch-client "-t" selection] cwd))
