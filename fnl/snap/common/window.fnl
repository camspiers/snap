(module snap.common.window)

(defn create [bufnr {: width : height : row : col : focusable : enter : title}]
  "Creates a window with specified options"
  (vim.api.nvim_open_win bufnr (if (= enter nil) false enter) {: width
                          : height
                          : row
                          : col
                          : focusable
                          :title_pos (if (not= title nil) :center nil)
                          :title (if (not= title nil) (string.format " %s " title) nil)
                          :noautocmd true
                          :relative :editor
                          :anchor :NW
                          :style :minimal
                          :border ["╭" "─" "╮" "│" "╯" "─" "╰" "│"]}))

(defn update [winnr {: width : height : row : col : focusable}]
  "Updates a window with specified options"
  (when (vim.api.nvim_win_is_valid winnr)
    (vim.api.nvim_win_set_config winnr {: width
                                        : height
                                        : row
                                        : col
                                        : focusable
                                        :relative :editor})))

(defn close [winnr]
  (vim.api.nvim_win_close winnr true))
