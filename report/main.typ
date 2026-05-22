
// APS 2026 — Project report

#set document(title: "Project Report — APS 2026", author: "Group H")
#set page(paper: "a4", margin: (x: 4cm, y: 4cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em, spacing: 1.2em)
#set text(font: "Libertinus Serif")

#let accent = rgb("#C0392B")

#show link: it => text(fill: accent)[#it]

// --- Cover page (no header) ---
#page(
  margin: (x: 3cm, y: 4cm),
  header: none,
  footer: none,
  {
    v(1fr)

    align(center)[
      #text(size: 14pt, fill: gray.darken(30%))[Algorithmic Problem Solving 2026]
      #v(1.2em)
      #text(size: 26pt, weight: "bold")[Project Report]
    ]

    v(2fr)

    table(
      columns: (auto, 1fr),
      stroke: 0.5pt + gray,
      inset: 0.6em,
      [*Group*],       [Group H],
      [*Members*],     [
        Karl Thedor Ruby (#link("mailto:krub@itu.dk")[krub\@itu.dk]) \
        Kristoffer Mejborn Eliasson (#link("mailto:krme@itu.dk")[krme\@itu.dk]) \
        Lukas Shaghashvili-Johannessen (#link("mailto:lush@itu.dk")[lush\@itu.dk])
      ],
      [*Supervisor*],  [Holger Dell, Martin Aumüller],
      [*Course*],      [Algorithmic Problem Solving (APS 2026)],
      [*Date*],        [2026-05-22],
    )

    v(1fr)

    align(center)[
      #text(size: 10pt)[IT University of Copenhagen]
    ]
  }
)

// --- Body ---
#let body-header = context {
  let elems = query(selector(heading.where(level: 1)).before(here()))
  set text(size: 8pt)
  smallcaps[Algorithmic Problem Solving 2026]
  h(1fr)
  if elems.len() > 0 {
    let cur = elems.last()
    if cur.numbering != none {
      let num = counter(heading).at(cur.location()).at(0)
      smallcaps[#num #cur.body]
    }
  }
  v(-0.4em)
  line(length: 100%, stroke: 0.5pt)
}

// Contents page — no header, tighter top margin
#set page(numbering: "1", header: none, margin: (top: 2.5cm, bottom: 3cm, x: 4cm))
#counter(page).update(1)

#outline(
  indent: auto,
  depth: 3,
  title: [#text(weight: "bold", size: 22pt)[Contents] #v(0.5em)],
)
#pagebreak()

// restore body margins
#set page(margin: (x: 4cm, y: 4cm))

// Body — running header on
#set page(header: body-header)

#include "sections/abstract.typ"
#include "sections/designed-problem.typ"
#include "sections/solved-problems.typ"

#pagebreak()

// Appendices — no header, tighter margins so code fits
#set page(header: none, margin: (x: 2.5cm, y: 3cm))
= Appendices
#show raw.where(block: true): set text(size: 8pt)
#include "sections/appendices/roberthood.typ"
#pagebreak()
#include "sections/appendices/cookieselection.typ"
#pagebreak()
#include "sections/appendices/jaggedskyline.typ"

#pagebreak()

= Use of AI

During the preparation of this report and the accompanying source code, members of the group made use of generative AI tools (large-language-model assistants) as a writing aid and as a sparring partner for algorithmic discussion. Specifically, AI was used to help phrase explanations more clearly, to challenge our reasoning when discussing algorithmic choices, and to point out gaps in our complexity arguments.

#bibliography("cite.bib")
