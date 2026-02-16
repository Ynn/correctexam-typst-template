#import "../lib/lib.typ": *

#show: correctexam.with(lang: "fr", mode: "withid")

#exam-title([Test multipage])
#exercise(8)
#question[Long answer 1.]
#answer-box(lines: 18, dot-color: white)
#question[Long answer 2.]
#answer-box(lines: 18, dot-color: white)
#question[Long answer 3.]
#answer-box(lines: 18, dot-color: white)
#validate-exam()
