#import "../lib/lib.typ": *

#show: correctexam.with(lang: "en", mode: "withid")

#exam-title([Test EN withid])
#exercise(4)
#question[First question.]
#answer-box(lines: 4)
#question[Second question with inline #inline-answer(chars: 6).]
#answer-box(lines: 3)
#validate-exam()
