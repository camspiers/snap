(module snap.buffer {require {snap snap
                              buffer snap.producer.buffer
                              fzy snap.consumer.fzy
                              file snap.select.file}})

(defn run [] (snap.run {:prompt :Buffers
                        :producer (fzy.create buffer.create)
                        :select file.select}))

