#import "../theme.typ": accent, light-bg, slide-title, tag, note, illustration

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
    stack(spacing: 1.2em)[
      #illustration(image("../wolf_riders.png", width: 8cm))
      #block(fill: light-bg, inset: 0.8em, radius: 4pt, width: 8.35cm)[
        *Bounds* \
        #v(0.2em)
        $1 <= N <= 50$ \
        $1 <= B <= 1000$ \
        $2 <= V_i <= 15$ \
        $1 <= E_i <= 40$
      ]
    ],
  )
]

// ── Slide 3: Solution — Max-flow ─────────────────────────────────────────────
#page[
  #slide-title[Subproblem 1 — Max-flow per Stronghold]
  #grid(
    columns: (1fr, auto),
    gutter: 1.5em,
    [
      - *Algorithm:* Edmonds-Karp — BFS-augmented Ford-Fulkerson
      - BFS finds the *shortest* augmenting path in the residual graph each iteration
      - *Residual graph:* reverse edges allow later correction of committed flow

      #v(0.3em)
      *Complexity per stronghold:*
      $ O(V_i dot E_i^2) $

      With $V_i <= 15$, $E_i <= 40$: at most $24\,000$ inspections.
    ],
    illustration(image("../map_of_gold.png", width: 7cm))
  )

  #v(0.3em)
  #note[Run Edmonds-Karp independently on each stronghold. Results: gold values $g_1, g_2, dots, g_N$.]
]

// ── Slide 4: Solution — Knapsack DP ──────────────────────────────────────────
#page[
  #slide-title[Subproblem 2 — 0/1 Knapsack DP]
  #grid(
    columns: (1fr, auto),
    gutter: 1.2em,
    [
      Each stronghold now has gold value $g_i$ and warrior cost $c_i$ — classic 0/1 knapsack with capacity $B$.
    ],
    illustration(image("../grogg_planing.png", width: 6cm))
  )

  #v(-0.5em)
  *Recurrence:*
  $
    "dp"[i][j] = cases(
      "dp"[i-1][j] & "if " j < c_i,
      max("dp"[i-1][j], g_i + "dp"[i-1][j - c_i]) & "otherwise"
    ), quad "dp"[0][j] = 0
  $

  #v(0.2em)
  *Backtrack* from $"dp"[N][B]$: stronghold $i$ chosen iff $"dp"[i][j] eq.not "dp"[i-1][j]$.

  #v(0.5em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    note[DP: $O(N dot B) = 5 times 10^4$ steps],
    note[Combined: $O(N V_max E_max^2 + N B)$],
  )
]

// ── Slide 5: Foils & Test Design ─────────────────────────────────────────────
#page[
  #slide-title[Foils]
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    [
      *TLE foil — Brute force* \
      Enumerate all $2^N$ subsets \
      $O(N dot V dot E^2 + 2^N dot N)$ \
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
