#import "../../theme.typ": accent, light-bg, slide-title, tag, note

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
