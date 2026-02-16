// ============================================================================
// CorrectExam Typst Package - English Example
// ============================================================================
// This example demonstrates all features of the correctexam package.
// Compile with: typst compile --root . examples/exam-en.typ build/exam-en.pdf

// Import all correctexam functions
#import "../lib/lib.typ": *

// ============================================================================
// TEMPLATE CONFIGURATION
// ============================================================================
// Configure the exam template with identity fields, language, and margins.
// The large top margin (4.5cm default) is REQUIRED for CorrectExam's
// scanning system and identity fields on odd pages.

#show: correctexam.with(
  lang: "en",           // Language: "en" or "fr"
  mode: "withid",       // Identity mode: "withid", "noid", "anonymous"
  id-boxes: 8,          // Number of boxes for student ID
)

// ============================================================================
// EXAM TITLE
// ============================================================================
// Create the main title and subtitle information that appears at the top
// of the first page.

#exam-title(
  [Title],              // Main exam title
  subtitle: (
    [2022-2023],        // Academic year or semester
    [Course handouts and lecture notes authorized],
    [Duration: 2 hours],
    [This exam has #total-pages() pages],  // Auto-calculated page count
  ),
)

// Instructions box (optional but recommended)
#align(center)[
  #box(width: 100%, stroke: 0.4pt, inset: 0.2cm)[
    *Write your answers directly inside the reply boxes, in this exam sheet.*
    #linebreak()
    *Do not go beyond these areas. Do not forget to write your name on each sheet.*
  ]
]

// ============================================================================
// EXERCISE 1 - Basic Questions with Answer Boxes
// ============================================================================

#exercise(5)  // Exercise worth 5 points

// Simple question with label for cross-referencing
#question(label: <q-label222>)[First Question]
#answer-box(lines: 2, line-spacing: 1.5em, dot-color: gray)

// Cross-reference to a question (creates a clickable link)
@q-label222

// ============================================================================
// EXERCISE 2 - Questions with Lorem Text (for layout testing)
// ============================================================================

#exercise(4)  // Exercise worth 4 points

#question[#lorem(15)]
#answer-box(lines: 2, line-spacing: 1.5em, dot-color: gray)

#question[#lorem(12)]
#answer-box(lines: 2, line-spacing: 1.5em, dot-color: gray)

#question(label: <q-label2>)[#lorem(12)]

// Multi-column answer box - useful for comparing/contrasting or side-by-side work
#answer-box(lines: 4, columns: 2, line-spacing: 1.5em, dot-color: gray)

// ============================================================================
// EXERCISE 3 - Questions with References and Different Answer Box Styles
// ============================================================================

#exercise(4)  // Exercise worth 4 points

#question(label: <q-mylabel>)[#lorem(16)]

// Reference to question within the same exercise
*Reference to @q-mylabel*

// Answer box with no guide lines (dot-color: white)
// Useful when students need to draw diagrams or when guide lines are distracting
#answer-box(lines: 8, line-spacing: 1.5em, dot-color: white)

#pagebreak()  // Force a new page for better layout control

// ============================================================================
// INLINE ANSWER FIELDS
// ============================================================================
// Inline answer fields allow fill-in-the-blank style questions within text.

#question[Complete the following text:]

You can also write some text with inline boxes #inline-answer() that students must complete #inline-answer(chars: 5).

#answer-box(lines: 8, line-spacing: 1.5em, dot-color: white)

// Question with inline answers embedded in the question text
#question[You can also write some text with inline boxes #inline-answer() that students must complete #inline-answer(chars: 5).]
#answer-box(lines: 3, line-spacing: 1.5em, dot-color: white)

// ============================================================================
// EXERCISE 4 - Multiple Choice Questions (QCM)
// ============================================================================

#exercise(8)  // Exercise worth 8 points

// Simple QCM with two choices
#question[Which color?]
#qcm([blue], [red])

// Another simple QCM
#question[Which form?]
#qcm([rectangular], [triangular])

// Long question followed by answer box
#question[#lorem(85)]
#answer-box(lines: 18, line-spacing: 1.5em, dot-color: white)

#pagebreak()

// ============================================================================
// CUSTOM ANSWER CONTENT
// ============================================================================
// answer-content() allows you to create custom answer zones with arbitrary
// content like code templates, diagrams, tables, or structured layouts.

#question[#lorem(95)]
#answer-box(lines: 18, line-spacing: 1.5em, dot-color: white)

// Code completion template
#answer-content[
  #v(0.1cm)
  #text(font: "DejaVu Sans Mono", size: 10pt)[void saisirEspece (]
  #v(0.8cm)

  #h(0.8cm)#text(font: "DejaVu Sans Mono", size: 10pt)[printf("Enter first name and last name\\n");]
  #v(2.2cm)

  #h(0.8cm)#text(font: "DejaVu Sans Mono", size: 10pt)[printf("Enter a species\\n");]
  #v(2.6cm)
]

// Diagram/drawing zones with structured boxes
#answer-content[
  #stack(spacing: 0.4cm)[
    #box(width: 3cm, height: 4cm, stroke: 0.8pt)[]
    #box(width: 3cm, height: 5cm, stroke: 0.8pt)[]
  ]
]

// Instructions with designated drawing area
#answer-content[
  #align(center)[
    *Copy this figure in the answer area.*
    #v(0.2cm)
    #box(width: 6cm, height: 3.6cm, stroke: 0.9pt, radius: 0.15cm)[]
  ]
]

// ============================================================================
// QUESTION BLOCKS
// ============================================================================
// question-block() keeps a question and its answer together on the same page
// (non-breakable). Useful for avoiding awkward page breaks.

#question-block(label: <q-otherlabel>)[
  #lorem(45)
][
  #answer-box(lines: 18, line-spacing: 1.5em, dot-color: white)
]

#question-block[
  #lorem(35)
][
  #answer-box(lines: 10, line-spacing: 1.5em, dot-color: white)
]

*Reference to @q-otherlabel*

// ============================================================================
// VALIDATION
// ============================================================================
// validate-exam() should be called at the end to check for common issues
// like missing questions, invalid markers, etc.

#validate-exam()
