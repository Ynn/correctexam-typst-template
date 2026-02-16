#import "../lib/lib.typ": *

#show: correctexam.with(lang: "en", mode: "withid")

#exam-title(
  [All features],
  subtitle: (
    [Line 1],
    [Line 2],
    [Pages: #total-pages()],
  ),
)

#exercise(5, title: [Core])

#question(label: <q.core>)[Referenced question.]
#answer-box(lines: 5, columns: 2, dot-color: gray)

#question[Inline fields #inline-answer() and #inline-answer(chars: 5).]
#answer-content[
  #raw("int f(int x) {", lang: "c")
  #v(2cm)
  #raw("}", lang: "c")
]

#exercise(4, title: [QCM])
#question[Pick one.]
#qcm([yes], [no], [maybe], [later])

@q.core

#validate-exam()
