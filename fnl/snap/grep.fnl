(module snap.grep {require {snap snap
                            io snap.io
                            vimgrep snap.producer.ripgrep.vimgrep
                            vimgrep-select snap.select.vimgrep}})

(defn run [] (snap.run {:prompt :Grep
                        :producer vimgrep.create
                        :select vimgrep-select.select
                        :multiselect vimgrep-select.multiselect}))

(defn cursor [] (snap.run {:prompt :Grep
                           :initial-filter (vim.fn.expand :<cword>)
                           :producer vimgrep.create
                           :select vimgrep-select.select
                           :multiselect vimgrep-select.multiselect}))

