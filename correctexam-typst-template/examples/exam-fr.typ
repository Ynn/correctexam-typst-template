// ============================================================================
// CorrectExam Typst Package - French Example
// ============================================================================
// This example demonstrates all features of the correctexam package in French.
// Compile with: typst compile --root . examples/exam-fr.typ build/exam-fr.pdf

#import "../lib/lib.typ": *

// Configure template for French language
#show: correctexam.with(lang: "fr", mode: "withid", id-boxes: 8)

#exam-title(
  [Titre],
  subtitle: (
    [2022-2023],
    [Polycopiés de cours et notes de cours autorisés],
    [Durée : 2 heures],
    [Sujet sur #total-pages() pages],
  ),
)

// Instructions for students
#box(width: 100%, stroke: 0.4pt, inset: 0.2cm)[
  *Écrivez directement sur le sujet dans les zones de réponse.
  Ne débordez pas de ces zones. Mettez votre nom sur chaque page.*
]

// ============================================================================
// Examples demonstrating various features (see exam-en.typ for detailed
// English comments on each feature)
// ============================================================================

#exercise(5)

#question(label: <q-label222>)[Première question]
#answer-box(lines: 2, line-spacing: 1.5em, dot-color: gray)

@q-label222

#exercise(4)

#question[#lorem(15)]
#answer-box(lines: 2, line-spacing: 1.5em, dot-color: gray)

#question[#lorem(12)]
#answer-box(lines: 2, line-spacing: 1.5em, dot-color: gray)
#question(label: <q-label2>)[#lorem(12)]

#answer-box(lines: 4, columns: 2, line-spacing: 1.5em, dot-color: gray)

#exercise(4)

#question(label: <q-mylabel>)[#lorem(16)]

*Référence à @q-mylabel*

#answer-box(lines: 8, line-spacing: 1.5em, dot-color: white)

#pagebreak()

#question[Complétez le texte suivant :]

Vous pouvez également écrire du texte avec des encadrés #inline-answer(), que les étudiants doivent compléter #inline-answer(chars: 5).

#answer-box(lines: 8, line-spacing: 1.5em, dot-color: white)

#question[Vous pouvez également écrire du texte avec des encadrés #inline-answer(), que les étudiants doivent compléter #inline-answer(chars: 5).]
#answer-box(lines: 3, line-spacing: 1.5em, dot-color: white)

#exercise(8)

#question[Quelle couleur ?]
#qcm([bleu], [rouge], [rouge], [rouge], [rouge], [rouge], [rouge])

#question[Quelle forme ?]
#qcm([rectangulaire], [triangulaire])

#question[#lorem(85)]
#answer-box(lines: 18, line-spacing: 1.5em, dot-color: white)

#pagebreak()

#question[#lorem(95)]
#answer-box(lines: 18, line-spacing: 1.5em, dot-color: white)

#answer-content[
  #v(0.1cm)
  #text(font: "DejaVu Sans Mono", size: 10pt)[void saisirEspece (]
  #v(0.8cm)

  #h(0.8cm)#text(font: "DejaVu Sans Mono", size: 10pt)[printf("Saisir le nom et le prénom\\n");]
  #v(2.2cm)

  #h(0.8cm)#text(font: "DejaVu Sans Mono", size: 10pt)[printf("Saisir une espèce\\n");]
  #v(2.6cm)
]

#answer-content[
  #stack(spacing: 0.4cm)[
    #box(width: 3cm, height: 4cm, stroke: 0.8pt)[]
    #box(width: 3cm, height: 5cm, stroke: 0.8pt)[]
  ]
]

#answer-content[
  #align(center)[
    *Recopiez cette figure dans la zone de réponse.*
    #v(0.2cm)
    #box(width: 6cm, height: 3.6cm, stroke: 0.9pt, radius: 0.15cm)[]
  ]
]

#question-block[
  #lorem(45)
][
  #answer-box(lines: 18, line-spacing: 1.5em, dot-color: white)
]

#question-block(label: <q-otherlabel>)[
  #lorem(35)
][
  #answer-box(lines: 10, line-spacing: 1.5em, dot-color: white)
]

*Référence à @q-otherlabel*

#validate-exam()
