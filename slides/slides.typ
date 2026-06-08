// APS 2026 — Group H presentation slides

#set page(
  paper: "presentation-16-9",
  margin: (x: 1.8cm, y: 1.4cm),
  fill: white,
)
#set text(font: "Libertinus Serif", size: 20pt)
#set strong(delta: 200)
#set par(leading: 0.7em, spacing: 0.9em)

#let accent = rgb("#C0392B")
#let light-bg = rgb("#F7F1F1")
#let slide-title(body) = {
  text(size: 22pt, weight: "bold", fill: accent)[#body]
  v(0.1em)
  line(length: 100%, stroke: 0.6pt + accent)
  v(0.5em)
}
#let tag(body) = text(size: 13pt, fill: gray.darken(30%))[#body]
#let note(body) = block(
  fill: light-bg, inset: 0.7em, radius: 4pt, width: 100%,
)[#text(size: 18pt)[#body]]

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

// ── Section divider: The Siege ────────────────────────────────────────────────
#page(fill: accent)[
  #set text(fill: white)
  #align(horizon + center)[
    #text(size: 14pt)[Designed Problem]
    #v(0.4em)
    #text(size: 40pt, weight: "bold")[The Siege]
    #v(0.4em)
    #text(size: 16pt)[Dynamic Programming · Network Flow]
  ]
]

// ── Slide 2: Problem Setup ────────────────────────────────────────────────────
#page[
  #slide-title[The Siege — Problem Setup]
  #grid(
    columns: (1fr, auto),
    gutter: 1.2em,
    [
      - *Setting:* Warchief Grukk conquers $N$ dwarven strongholds
      - Each stronghold = *directed weighted graph* (tunnels with capacity limits)
      - *Gold yield* = max-flow from room $0$ (Gold Vein) → room $V_i - 1$ (entrance)
      - *Warrior budget* $B$: conquering stronghold $i$ costs $c_i$ warriors
      - *Goal:* choose a subset to *maximise total gold* within budget $B$; output indices ascending
    ],
    block(fill: light-bg, inset: 0.8em, radius: 4pt, width: 8cm)[
      *Bounds* \
      #v(0.2em)
      $1 <= N <= 50$ \
      $1 <= B <= 1000$ \
      $2 <= V_i <= 15$ \
      $1 <= E_i <= 40$
    ],
  )
]

// ── Slide 3: Solution — Max-flow ─────────────────────────────────────────────
#page[
  #slide-title[Subproblem 1 — Max-flow per Stronghold]
  - *Algorithm:* Edmonds-Karp — BFS-augmented Ford-Fulkerson
  - BFS finds the *shortest* augmenting path in the residual graph each iteration
  - *Residual graph:* reverse edges allow later correction of committed flow

  #v(0.3em)
  *Complexity per stronghold:*
  $ O(V_i dot E_i^2) $

  With $V_i <= 15$, $E_i <= 40$: at most $15 times 40^2 = 24\,000$ inspections per stronghold.
  At $N = 50$: at most $1.2 times 10^6$ total residual-edge inspections.

  #v(0.3em)
  #note[Run Edmonds-Karp independently on each stronghold. Results: gold values $g_1, g_2, dots, g_N$.]
]

// ── Slide 4: Solution — Knapsack DP ──────────────────────────────────────────
#page[
  #slide-title[Subproblem 2 — 0/1 Knapsack DP]
  Each stronghold now has gold value $g_i$ and warrior cost $c_i$ — classic 0/1 knapsack with capacity $B$.

  *Recurrence:*
  $
    "dp"[i][j] = cases(
      "dp"[i-1][j] & "if " j < c_i,
      max("dp"[i-1][j], g_i + "dp"[i-1][j - c_i]) & "otherwise"
    ), quad "dp"[0][j] = 0
  $

  *Backtrack* from $"dp"[N][B]$: stronghold $i$ chosen iff $"dp"[i][j] eq.not "dp"[i-1][j]$.

  #v(0.3em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    note[DP: $O(N dot B) = 5 times 10^4$ steps],
    note[Combined: $O(N V_max E_max^2 + N B)$ — dominated by max-flows],
  )
]

// ── Slide 5: Foils & Test Design ─────────────────────────────────────────────
#page[
  #slide-title[Foils & Test Design]
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    [
      *TLE foil — Brute force* \
      Enumerate all $2^N$ subsets \
      $O(2^N dot (N + V dot E^2))$ \
      Correct, but $2^{50} approx 10^{15}$ at $N=50$
    ],
    [
      *WA foil — Greedy ratio* \
      Sort by $g_i \/ c_i$ descending, add greedily \
      Optimal for *fractional* knapsack \
      Fails for 0/1
    ],
  )

  #v(0.2em)
  #text(size: 18pt)[
    *WA counter-example* ($B = 10$):

    #v(0.1em)
    #table(
      columns: (auto, auto, auto, auto),
      stroke: 0.4pt + gray,
      inset: (x: 0.6em, y: 0.4em),
      align: center,
      [*Item*], [*Cost $c$*], [*Gold $g$*], [*Ratio $g\/c$*],
      [A], [4], [5], [1.25 #text(fill: accent)[★]],
      [B], [4], [4], [1.00],
      [C], [6], [6], [1.00],
    )
    #v(0.2em)
    Greedy picks A+B = *9 gold*. Optimal is A+C = *11 gold*.

    #v(0.2em)
    *Validator:* runs full knapsack; rejects inputs where the optimal subset is not unique.
  ]
]

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

// ── Slide 6: Robert Hood — Problem ───────────────────────────────────────────
#page[
  #grid(
    columns: (1fr, auto),
    slide-title[Robert Hood — Problem],
    tag[Geometric Algorithms],
  )
  #v(-0.3em)

  *Input:* $n$ points in the plane with integer coordinates $(n <= 10^5)$

  *Output:* maximum Euclidean distance between any two points

  #v(0.6em)
  The *diameter* of a point set — the longest pairwise distance.

  #v(0.8em)
  #note[
    *Why not brute force?* \
    Checking all $binom(n,2) approx 5 times 10^9$ pairs at $n = 10^5$ is far too slow.
  ]
]

// ── Slide 7: Robert Hood — Solution ──────────────────────────────────────────
#page[
  #grid(
    columns: (1fr, auto),
    slide-title[Robert Hood — Solution],
    tag[O(n log n)],
  )
  #v(-0.3em)

  *Key insight:* diameter endpoints always lie on the convex hull — any interior point can be projected outward to increase distance.

  #v(0.3em)
  *Step 1 — Convex hull:* Andrew's monotone chain
  - Sort lexicographically, build lower + upper hull in two linear passes — $O(n log n)$

  *Step 2 — Rotating calipers:* find hull diameter in $O(m)$
  - For each hull edge, advance antipodal pointer $j$ while cross product $> 0$
  - Unimodality of the hull ensures $j$ never retreats
  - Compare *squared* distances — avoids $sqrt$ in the inner loop

  #v(0.3em)
  #note[Empirical worst case: all $n$ points on hull (circle). $n = 10^5$ in $approx 0.73$ s (CPython 3).]
]

// ── Slide 8: Cookie Selection — Problem ──────────────────────────────────────
#page[
  #grid(
    columns: (1fr, auto),
    slide-title[Cookie Selection — Problem],
    tag[Algorithms on Arrays],
  )
  #v(-0.3em)

  *Input:* up to $2 times 10^5$ events, each either:
  - Insert a positive integer into a multiset, *or*
  - Query and remove the element at rank $floor(n\/2) + 1$ from the current multiset of size $n$

  *Output:* each queried value on its own line.

  #v(0.8em)
  #note[
    *Why not a sorted list?* \
    Insertion and rank-lookup each cost $O(n)$ — too slow for $n = 2 times 10^5$.
  ]
]

// ── Slide 9: Cookie Selection — Solution ─────────────────────────────────────
#page[
  #grid(
    columns: (1fr, auto),
    slide-title[Cookie Selection — Solution],
    tag[O(n log n)],
  )
  #v(-0.3em)

  *Coordinate compression:* map distinct values to indices $1 dots m$, preserving order.

  *Fenwick tree (BIT)* over compressed indices:
  - `bit[i]` stores the count of elements with compressed index $i$ in the multiset
  - `bit.query(i)` = number of elements $<=$ `decompress(i)` (prefix sum)

  *Rank query for rank $k$:* binary descent on the BIT — $O(log m)$, not $O(log^2 m)$

  #v(0.3em)
  Each insert/remove: one BIT update, $O(log n)$. Each rank query: one descent, $O(log n)$.

  #v(0.3em)
  #note[Empirical worst case: $10^5$ inserts then $10^5$ queries. $approx 0.67$ s (CPython 3).]
]

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

// ── Slide 12: Questions ───────────────────────────────────────────────────────
#page(fill: accent)[
  #set text(fill: white)
  #align(horizon + center)[
    #text(size: 56pt, weight: "bold")[Questions?]
    #v(1.5em)
    #text(size: 15pt)[krub\@itu.dk · krme\@itu.dk · lush\@itu.dk]
  ]
]
