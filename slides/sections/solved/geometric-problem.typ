#import "../../theme.typ": accent, light-bg, slide-title, tag, note

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
