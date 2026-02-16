// ============================================================================
// CorrectExam Typst Package - Anonymous Grading Example
// ============================================================================
// This example demonstrates anonymous grading mode where students only
// fill in an anonymous ID (no name fields).
// Compile with: typst compile --root . examples/exam-anonymous.typ build/exam-anonymous.pdf

#import "../lib/lib.typ": *

// ============================================================================
// ANONYMOUS MODE CONFIGURATION
// ============================================================================
// mode: "anonymous" creates a single ID row for anonymous grading.
// This is useful when you want to hide student identities during grading
// to reduce bias.

#show: correctexam.with(
  lang: "fr",           // Language
  mode: "anonymous",    // Anonymous mode - only anonymous ID, no name fields
  id-boxes: 10,         // Number of boxes for the anonymous ID
)

#exam-title([Examen anonyme])

#exercise(6)

// Example with code completion template
#question[Complétez le code suivant :]
#answer-content[
  #raw("void saisirEspece (", lang: "c")
  #v(1cm)
  #raw("  printf(\"Saisir le nom\\n\");", lang: "c")
  #v(3cm)
  #raw("  printf(\"Saisir une espece\\n\");", lang: "c")
  #v(4cm)
]

// Example with diagram area
#question[Compléter le diagramme :]
#answer-content[
  #align(center)[#rect(width: 8cm, height: 3cm, stroke: 0.7pt)]
]

#validate-exam()
