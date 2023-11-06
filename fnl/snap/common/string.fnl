(module snap.common.string)

(defn split [str]
  (icollect [_ line (ipairs (vim.split str "\n" true))]
    (let [trimmed (vim.trim line)]
      (if (not= trimmed "") trimmed))))
