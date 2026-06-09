#import "../../theme.typ": accent, light-bg, slide-title, tag, note

// ── Slide 10: Jagged Skyline — Problem ───────────────────────────────────────
#page[
  #grid(
    columns: (1fr, auto),
    slide-title[Jagged Skyline — Problem],
    tag[Randomized Algorithm],
  )
  #v(-0.3em)

  *Setting:* a skyline of width $w$ and height $h$.

  *Goal:* find the column with the maximum height.

  *Only allowed query:* "Is there a building at column $x$ of height $>= y$?"
  - Interactor responds yes or no.

  #v(0.8em)
  #note[
    *Challenge:* adversarial column ordering could force scanning many short columns before finding the maximum — a deterministic algorithm has no defence.
  ]
]

// ── Slide 11: Jagged Skyline — Solution ──────────────────────────────────────
#page[
  #grid(
    columns: (1fr, auto),
    slide-title[Jagged Skyline — Solution],
    tag[Las Vegas],
  )
  #v(-0.3em)

  *Las Vegas approach:* randomise column order to defeat adversarial inputs.

  *Algorithm:*
  + *Shuffle* all columns uniformly at random
  + For each column $x$ in shuffled order:
    - One upward probe: "height $>=$ current best?" — skip immediately if no
    - If yes: *binary search* to find exact height of $x$ in $O(log h)$ queries
    - Update current best if taller
  + *Early exit* when best height $= h$

  #v(0.3em)
  *Expected queries:* $O(k log h)$, where $k$ = number of columns sampled before the global maximum is found.

  #note[Never assumes skyline structure; always verifies heights via binary search before reporting.]
]
