
// APS 2026 — Project report

#set document(title: "Project Report — APS 2026", author: "Group H")
#set page(paper: "a4", margin: (x: 2.5cm, y: 3cm))
#set heading(numbering: "1.")
#set par(justify: true)

// --- Cover page ---
#page(
  margin: (x: 3cm, y: 4cm),
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
      [*Date*],        [[YYYY-MM-DD]],
    )

    v(1fr)

    align(center)[
      #text(size: 10pt)[IT University of Copenhagen]
    ]
  }
)

// --- Body ---
#set page(numbering: "1")
#counter(page).update(1)

#outline(indent: auto)
#pagebreak()

#include "sections/abstract.typ"
#include "sections/designed-problem.typ"
#include "sections/solved-problems.typ"
#include "sections/appendix-a.typ"
#include "sections/appendix-b.typ"
