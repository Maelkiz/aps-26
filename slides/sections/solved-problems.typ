#import "../theme.typ": accent, light-bg, slide-title, tag, note

// ── Section divider: Solved Problems ─────────────────────────────────────────
#page(fill: accent)[
  #set text(fill: white)
  #align(horizon + center)[
    #text(size: 40pt, weight: "bold")[Solved Problems]
    #v(0.6em)
    #text(size: 18pt)[
      Robert Hood · Cookie Selection · Jagged Skyline
    ]
  ]
]

#include "solved/geometric-problem.typ"
#include "solved/array-problem.typ"
#include "solved/randomized-problem.typ"
