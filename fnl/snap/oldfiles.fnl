(module snap.oldfiles {require {snap snap
                                oldfile snap.producer.oldfile
                                fzy snap.consumer.fzy
                                file snap.select.file}})

(defn run [] (snap.run {:prompt "Old files"
                        :producer (fzy.create oldfile.create)
                        :select file.select}))

