#import "../lib/lib.typ": *

#show: correctexam.with(
  lang: "fr",
  mode: "withid",
  lastname-boxes: 15,
  firstname-boxes: 12,
  id-boxes: 10,
  box-width: 0.7cm,
  box-height: 0.9cm,
  box-gap: 0.8mm,
)

#exam-title([Test custom boxes])
#exercise(2)
#question[Question custom.]
#answer-box(height: 5cm)
#validate-exam()
