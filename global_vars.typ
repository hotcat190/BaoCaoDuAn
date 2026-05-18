#let TTS_implemented = state("TTS_implemented", false)

#let stt-counter = counter("table-stt")
#show table: it => {
  stt-counter.update(0)
  it
}
#let stt() = [#stt-counter.step()#context stt-counter.display()]