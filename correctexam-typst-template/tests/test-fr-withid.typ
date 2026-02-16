#import "../lib/lib.typ": *

#show: correctexam.with(lang: "fr", mode: "withid")

#exam-title([Test FR withid])
#exercise(5)
#question[Question 1.]
#answer-box(lines: 5)
#question[Question 2.]
#qcm([A], [B], [C])
#validate-exam()
