(module snap.common.window)

(defn create [bufnr {: width : height : row : col : focusable}]
  "Creates a window with specified options"
  (vim.api.nvim_open_win bufnr 0 {: width
                          : height
                          : row
                          : col
                          : focusable
                          :relative :editor
                          :anchor :NW
                          :style :minimal
                          :border ["╭" "─" "╮" "│" "╯" "─" "╰" "│"]}))
