#import "../theme.typ": accent, light-bg, slide-title, tag, note

// ── Slide 1: Title ────────────────────────────────────────────────────────────
#page(fill: light-bg)[
  #align(horizon + center)[
    #text(size: 13pt, fill: gray.darken(20%))[Algorithmic Problem Solving 2026 — Group H]
    #v(0.5em)
    #text(size: 38pt, weight: "bold")[APS Exam 2026]
    #v(1em)
    #line(length: 55%, stroke: 0.8pt + accent)
    #v(1em)
    #text(size: 17pt)[
      Karl Theodor Ruby · Kristoffer Mejborn Eliasson · Lukas Shaghashvili-Johannessen \
      #v(0.3em)
      #text(fill: gray.darken(30%))[IT University of Copenhagen]
    ]
  ]
]
