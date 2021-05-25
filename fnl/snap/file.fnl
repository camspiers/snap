(module snap.file {require {snap snap
                            io snap.io
                            file snap.producer.ripgrep.file
                            fzy snap.consumer.fzy
                            file-select snap.select.file}})

(defn run [] (snap.run {:prompt :Files
                        :producer (fzy.create file.create)
                        :select file-select.select
                        :multiselect file-select.multiselect}))

