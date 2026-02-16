#import "../lib/lib.typ": *

#show: correctexam.with(lang: "fr", mode: "anonymous", id-boxes: 10)

#exam-title([Test FR anonymous])
#exercise(3)
#question[Question anonyme.]
#answer-box(lines: 3)
#question[QCM anonyme.]
#qcm([oui], [non], [peut-être], [jamais])
#validate-exam()
