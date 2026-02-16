# correctexam (Typst package)

`correctexam` is a Typst package that generates machine-readable exam PDFs for CorrectExam.

The package places grading-zone markers in an embedded PDF attachment named `correctexam-markers.json`.
This is the first step of the pipeline; the second step is running `annotate-ce` (see repository root README).

## Quick Start

### 1. Install Typst

Download from [typst.app](https://typst.app) or install via package manager:

```bash
# macOS
brew install typst

# Linux (most distros)
# See https://github.com/typst/typst for installation instructions
```

### 2. Create Your First Exam

Create a file `my-exam.typ`:

```typst
#import "@preview/correctexam:0.1.0": *

#show: correctexam.with(lang: "en", mode: "withid")

#exam-title(
  [Final Exam - Computer Science],
  subtitle: (
    [2025-2026],
    [Duration: 2 hours],
    [This exam has #total-pages() pages],
  ),
)

#exercise(10)

#question[Explain the difference between a process and a thread.]
#answer-box(lines: 8, dot-color: gray)

#question[Which sorting algorithm has O(n log n) complexity?]
#qcm([Bubble sort], [Merge sort], [Selection sort])

#validate-exam()
```

### 3. Compile

```bash
typst compile my-exam.typ my-exam.pdf
```

### 4. Annotate for CorrectExam

```bash
# Install annotate-ce (see main repository README)
annotate-ce my-exam.pdf -o my-exam.annotated.pdf
```

### 5. Print and Distribute

Print `my-exam.annotated.pdf` and distribute to students.

### 6. Grade with CorrectExam

Scan completed exams and use CorrectExam's web interface for grading.

## What this package provides

- Exam page layout with CorrectExam-style header/footer markers
- Student identity area modes: `withid`, `anonymous`, `noid`
- Numbered exercises and questions
- Free-text answer zones (`answer-box`)
- Custom answer content zones (`answer-content`)
- Inline answer fields (`inline-answer`)
- Multiple-choice zones (`qcm`)
- Built-in validation helper (`validate-exam`)
- English/French i18n support

## Install and import

Using the package from Typst Universe:

```typst
#import "@preview/correctexam:0.1.0": *
```

Local workspace usage (as in this repository examples):

```typst
#import "../lib/lib.typ": *
```

## Minimal example

```typst
#import "@preview/correctexam:0.1.0": *

#show: correctexam.with(lang: "en", mode: "withid")

#exam-title(
  [Exam Title],
  subtitle: (
    [2025-2026],
    [Duration: 2 hours],
    [This exam has #total-pages() pages],
  ),
)

#exercise(5)
#question[First question.]
#answer-box(lines: 6)

#question[Which answer is correct?]
#qcm([A], [B], [C])

#validate-exam()
```

Compile (from inside `correctexam-typst-template/`):

```bash
typst compile --root . examples/exam-en.typ build/exam-en.pdf
typst compile --root . examples/exam-fr.typ build/exam-fr.pdf
typst compile --root . examples/exam-anonymous.typ build/exam-anonymous.pdf
```

Compile (from monorepo root):

```bash
typst compile --root correctexam-typst-template \
  correctexam-typst-template/examples/exam-en.typ \
  correctexam-typst-template/build/exam-en.pdf
```

## Then annotate with `annotate-ce`

After Typst compilation, run:

```bash
cargo run --manifest-path ../annotate-typst/Cargo.toml -- \
  build/exam-en.pdf \
  -o build/exam-en.annotated.pdf
```

Use `exam.annotated.pdf` as the final CorrectExam-compatible file.

## Marker JSON format

The attached `correctexam-markers.json` contains an array of marker objects like:

```json
{
  "key": "correctexam-answer-1-1-1",
  "x": 1.3,
  "y": 12.45,
  "w": 18.4,
  "h": 4.2,
  "p": 1,
  "type": "qcm"
}
```

- Coordinates use centimeters.
- Values are rounded to three decimals.
- `y` is encoded as lower edge (`top + h`) for CorrectExam compatibility.

## Complete API reference

### `correctexam(body, ..options)`

Main template function that sets up the exam page layout and CorrectExam markers.

**Parameters:**
- `lang`: Language code (`"fr"` or `"en"`). Default: `"fr"`
- `mode`: Identity mode (`"withid"`, `"noid"`, or `"anonymous"`). Default: `"withid"`
  - `"withid"`: Last name, first name, and student ID on odd pages
  - `"noid"`: Last name and first name only (no student ID row)
  - `"anonymous"`: Single anonymat ID row for anonymous grading
- `lastname-boxes`: Number of boxes for last name. Default: `19`
- `firstname-boxes`: Number of boxes for first name. Default: `19`
- `id-boxes`: Number of boxes for student/anonymous ID. Default: `8`
- `box-width`: Width of each identity box. Default: `0.78cm`
- `box-height`: Height of each identity box. Default: `0.88cm`
- `box-gap`: Gap between identity boxes. Default: `0.5mm`
- `box-stroke`: Stroke style for identity boxes. Default: `0.35pt + luma(180)`
- `marker-top-offset`: Vertical offset for corner marker dots. Default: `0.55cm`
- `paper`: Paper size (`"a4"`, `"us-letter"`, etc.). Default: `"a4"`
- `margin`: Page margins dictionary. Default: `(top: 4.5cm, bottom: 1.7cm, left: 1.3cm, right: 1.3cm)`
- `font`: Font family. Default: `"Libertinus Serif"`
- `font-size`: Base font size. Default: `11pt`
- `corner-radius`: Radius of corner marker dots. Default: `3.6mm`

**Usage:**
```typst
#show: correctexam.with(lang: "en", mode: "withid", id-boxes: 8)
```

### `exam-title(title, subtitle: ())`

Creates the exam title at the top of the first page.

**Parameters:**
- `title`: Main title content
- `subtitle`: Array of subtitle lines (optional)

**Usage:**
```typst
#exam-title(
  [Final Exam - Computer Science],
  subtitle: (
    [Academic Year 2025-2026],
    [Duration: 3 hours],
    [All materials authorized],
    [This exam has #total-pages() pages],
  ),
)
```

### `exercise(points, title: none)`

Starts a new numbered exercise with a point value.

**Parameters:**
- `points`: Number of points for this exercise
- `title`: Optional exercise title

**Usage:**
```typst
#exercise(10)
#exercise(15, title: [Graph Algorithms])
```

### `question(body, label: none)`

Creates a numbered question within the current exercise.

**Parameters:**
- `body`: Question text
- `label`: Optional label for cross-references

**Usage:**
```typst
#question[What is the time complexity?]
#question(label: <q-sorting>)[Explain bubble sort.]

// Reference elsewhere:
See @q-sorting for details.
```

### `answer-box(lines: 3, height: auto, columns: 1, line-spacing: 1.5em, dot-color: black)`

Creates a lined answer box for written responses.

**Parameters:**
- `lines`: Number of lines to display. Default: `3`
- `height`: Fixed height (overrides `lines` if set). Default: `auto`
- `columns`: Number of columns for multi-column layout. Default: `1`
- `line-spacing`: Spacing between lines. Default: `1.5em`
- `dot-color`: Color of dotted guide lines (`black`, `gray`, or `white` for no lines). Default: `black`

**Usage:**
```typst
// Simple box with 6 lines
#answer-box(lines: 6)

// Two-column layout with gray guide lines
#answer-box(lines: 8, columns: 2, dot-color: gray)

// Fixed height box with no guide lines
#answer-box(height: 8cm, dot-color: white)
```

### `answer-content(body)`

Creates a custom answer zone with arbitrary content (diagrams, code templates, etc.).

**Parameters:**
- `body`: Content to display inside the answer box

**Usage:**
```typst
#answer-content[
  // Code template
  #text(font: "DejaVu Sans Mono", size: 10pt)[
    def function_name():
  ]
  #v(2cm)
  #text(font: "DejaVu Sans Mono", size: 10pt)[
    return result
  ]
]

#answer-content[
  // Diagram area
  #grid(
    columns: (1fr, 1fr),
    box(width: 4cm, height: 4cm, stroke: 0.5pt)[],
    box(width: 4cm, height: 4cm, stroke: 0.5pt)[],
  )
]
```

### `inline-answer(chars: 10)`

Creates an inline fill-in-the-blank box within text.

**Parameters:**
- `chars`: Approximate number of characters. Default: `10`

**Usage:**
```typst
The capital of France is #inline-answer(chars: 5) and the
population is approximately #inline-answer(chars: 8) million.
```

### `qcm(..items, columns: 1)`

Creates a multiple-choice question (QCM) zone with checkboxes.

**Parameters:**
- `items`: Variable number of choice contents (use positional arguments)
- `columns`: Number of columns for choice layout. Default: `1`

**Usage:**
```typst
#question[What is 2+2?]
#qcm([2], [3], [4], [5])

#question[Select primary colors:]
#qcm(columns: 3)[Red][Blue][Green][Yellow][Purple][Orange]
```

### `question-block(body, answer, label: none)`

Groups a question with its answer zone in a non-breakable block.

**Parameters:**
- `body`: Question content
- `answer`: Answer zone (typically `answer-box()` or `answer-content()`)
- `label`: Optional label for cross-references

**Usage:**
```typst
#question-block(label: <q-important>)[
  Explain the difference between process and thread.
][
  #answer-box(lines: 10, dot-color: gray)
]
```

### `total-pages()`

Returns the total number of pages in the document.

**Usage:**
```typst
This exam has #total-pages() pages.
```

### `validate-exam()`

Validates exam structure and emits warnings. Should be called at the end of the document.

**Usage:**
```typst
// At the end of your exam file:
#validate-exam()
```

### `correctexam-i18n(lang, key)`

Retrieves internationalized strings.

**Parameters:**
- `lang`: Language code (`"fr"` or `"en"`)
- `key`: String key to retrieve

Available keys: `"exercise"`, `"question-prefix"`, `"lastname"`, `"firstname"`, `"studentid"`, `"anonymousid"`, `"point"`, `"points"`

**Usage:**
```typst
#correctexam-i18n("en", "exercise")  // Returns "Exercise"
#correctexam-i18n("fr", "question-prefix")  // Returns "Q"
```

## Best Practices & Tips

### Structuring Your Exam

**1. Use Consistent Point Values**

Plan your point distribution upfront and use the `exercise()` point parameter:

```typst
#exercise(10, title: [Data Structures])  // 40% of grade
#exercise(15, title: [Algorithms])       // 60% of grade
```

Keep a running tally to ensure the total matches your grading rubric.

**2. Group Related Content**

Use `question-block()` liberally to prevent awkward page breaks:

```typst
#question-block[
  Given the following code:
  #raw("...", lang: "python")
  
  What is the output?
][
  #answer-box(lines: 5)
]
```

**3. Test Page Breaks Early**

Compile frequently during authoring. If a question breaks badly across pages, adjust spacing or add `#pagebreak()`.

### Answer Box Sizing

**Line Count Guidelines:**
- Short answer (1-2 sentences): `lines: 2-3`
- Paragraph response: `lines: 6-10`
- Essay question: `lines: 15-25` or use `height: 12cm`

**Column Layout:**
```typst
// Side-by-side comparisons
#answer-box(lines: 8, columns: 2)

// Three-column for short items
#answer-box(lines: 4, columns: 3)
```

**Guide Lines:**
- `dot-color: gray` — Helpful for younger students or handwriting practice
- `dot-color: black` — Maximum visibility for students with vision issues
- `dot-color: white` — Clean look for diagrams or mathematical notation

### Custom Content Templates

Create reusable templates for common patterns:

```typst
// Define once at top of file
#let code-template(..lines) = {
  answer-content(
    stack(
      spacing: 1.5cm,
      ..lines.pos().map(line => 
        text(font: "DejaVu Sans Mono", size: 10pt, line)
      )
    )
  )
}

// Use throughout exam
#question[Complete the function:]
#code-template(
  "def factorial(n):",
  "    # Your code here",
  "    return result"
)
```

### Pagination Strategy

**Option 1: Continuous Flow** (default)
Let Typst handle page breaks automatically. Good for text-heavy exams.

**Option 2: Exercise-per-Page**
Use `#pagebreak()` after each exercise for consistent grading rhythm:

```typst
#exercise(10)
#question[...]
#answer-box(lines: 20)
#pagebreak()

#exercise(15)
// ...
```

**Option 3: Hybrid**
Major exercises start new pages, minor questions flow:

```typst
#exercise(20, title: [Major Topic])
#pagebreak()  // Force new page for major sections

#question[...]
#answer-box(lines: 10)

#question[...]  // Flows naturally
#answer-box(lines: 8)
```

### Mathematics Typesetting

Typst has excellent built-in math support:

```typst
#question[
  Calculate $integral_0^pi sin(x) dif x$.
]

#question[
  Given $A = mat(1, 2; 3, 4)$, compute $det(A)$.
]

#question[
  Solve for $x$ where $x^2 - 3x + 2 = 0$.
]
```

### Multi-Language Exams

For institutions with bilingual requirements:

```typst
#let bilingual(fr, en) = context {
  let cfg = correctexam-config.get()
  if cfg.lang == "fr" { fr } else { en }
}

#question[
  #bilingual(
    [Expliquez le concept de polymorphisme.],
    [Explain the concept of polymorphism.]
  )
]
```

### Version Control

Track your exam source files in Git:

```bash
# .gitignore
build/
*.pdf
!exam-template.pdf  # Keep reference template
```

Tag released versions:
```bash
git tag -a v2025-final -m "Final exam version"
```

### Testing Workflow

1. **Compile frequently** during authoring
2. **Print a test copy** to check:
   - Identity fields are clear
   - Answer boxes have adequate space
   - No content overlaps with margins
   - Corner markers are visible
3. **Scan the test copy** through CorrectExam pipeline
4. **Grade a mock answer** to verify marker detection

### Accessibility Considerations

**Font Size:**
Default 11pt is readable for most students. For accessibility needs:

```typst
#show: correctexam.with(
  font-size: 13pt,  // Larger for low-vision students
)
```

**High Contrast:**
```typst
// Use black guide lines instead of gray
#answer-box(lines: 8, dot-color: black)
```

**Dyslexia-Friendly Font:**
```typst
#show: correctexam.with(
  font: "OpenDyslexic",  // If installed
)
```

**Alternative Formats:**
For students requiring digital versions, consider generating a separate non-scannable PDF:

```typst
#show: correctexam.with(
  mode: "noid",  // No identity fields
)
// Provide name field as regular form content instead
```

## Troubleshooting

### "Could not find package" error

If you get an error importing `@preview/correctexam:0.1.0`:

**Solution 1: Use local import (for development)**
```typst
#import "../lib/lib.typ": *  // Relative path to package
```

**Solution 2: Install from Typst Universe (for published package)**
```bash
typst update  # Update package index
```

### Compilation is slow

Typst should compile in under 1 second for most exams. If it's slow:

**Common causes:**
- Very large lorem text blocks (replace with real content)
- Complex recursive functions
- Huge images (compress before including)

**Solution:**
```bash
typst compile --root . exam.typ exam.pdf  # Ensure --root is set
```

### Identity boxes don't appear on odd pages

Check your mode setting:

```typst
#show: correctexam.with(
  mode: "withid",  // NOT "noid" or "anonymous"
)
```

Verify you're looking at an odd page (page 1, 3, 5, etc.).

### Corner markers are missing or cut off

The markers are **black dots in the corners**. If missing:

1. Check margins aren't too small (minimum 1cm on all sides)
2. Verify PDF viewer shows the entire page (not cropped)
3. Try printing to see if it's a display issue

### Answer boxes overlap with content

If text appears inside answer boxes:

**Don't do this:**
```typst
#question[Question text
#answer-box(lines: 4)  // Wrong: inside question
more text]
```

**Do this:**
```typst
#question[Question text]
#answer-box(lines: 4)  // Correct: after question
```

### Questions break across pages awkwardly

Use `question-block()` for atomic question+answer units:

```typst
#question-block[
  Long question with figure...
][
  #answer-box(lines: 10)
]
```

Or manually break with `#pagebreak()`.

### "Undefined function" errors

Make sure you've imported correctexam:

```typst
#import "@preview/correctexam:0.1.0": *

#show: correctexam.with(...)  // Template must be activated
```

### Math symbols don't render

Typst uses `$...$` for math mode:

```typst
// Don't use LaTeX syntax
// \alpha, \sum_{i=1}^n

// Use Typst math mode
$alpha$, $sum_(i=1)^n$
```

See [Typst math documentation](https://typst.app/docs/reference/math/) for syntax.

### Scanned exams aren't recognized by CorrectExam

1. **Verify annotation step:** Did you run `annotate-ce` after compiling?
2. **Check marker visibility:** Print a test page and verify corner dots are visible
3. **Scan quality:** Ensure scans are at least 150 DPI, not too dark/light
4. **Orientation:** Scans should be upright (CorrectExam will detect orientation)

### Can't use custom fonts

Install fonts system-wide and reference by name:

```typst
#show: correctexam.with(
  font: "Comic Sans MS",  // Must be installed on system
)
```

Or use Typst's built-in fonts: `"New Computer Modern"`, `"Libertinus Serif"`, etc.

### Page numbers are wrong

The `total-pages()` function returns the final page count. If it shows `??` during editing, compile the full document once. Typst needs a complete pass to calculate totals.

### Getting "marker collision" warnings

This means multiple answer zones overlap. Check for:

```typst
// Don't nest answer zones
#answer-box(lines: 4)
#answer-box(lines: 4)  // OK - separate zones

// Don't do:
#answer-content[
  #answer-box(lines: 4)  // Wrong: nested
]
```

### Need help?

- **GitHub Issues**: Report bugs or feature requests
- **Typst Discord**: Ask questions about Typst syntax
- **CorrectExam Forum**: Questions about the scanning/grading workflow

## Examples in this repository

- `examples/exam-en.typ`
- `examples/exam-fr.typ`
- `examples/exam-anonymous.typ`
- `quickstart/exam-en.typ`
- `quickstart/exam-fr.typ`

The English and French examples mirror the historical LaTeX sample structure (including QCM, references, custom content areas, and copyable figure content).

## Development checks

```bash
cd tests
./validate.sh
```
