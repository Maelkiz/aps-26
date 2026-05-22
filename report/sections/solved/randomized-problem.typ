
== Jagged Skyline (Randomized Algorithms)

=== Problem metadata

- *Problem name / Kattis link:* #link("https://open.kattis.com/problems/jaggedskyline")[Jagged Skyline]
- *Short formal I/O description:* Interactively discover the tallest building column in a skyline of width $w$ and height $h$ using height queries of the form "is there a building at column $x$ of height at least $y$?". The interactor answers with a positive/negative response for each query.

=== Solution overview

- *Approach*: Monte Carlo sampling of columns combined with targeted binary searches. Randomly sample column order and probe increasingly higher heights only when a sample indicates promise; then binary-search that column's height.
- *Intuition*: Randomizing the search order avoids worst-case adversarial layouts and often finds a near-optimal column quickly; once a tall column is found, further work is limited because heights are bounded by $h$.

=== Correctness argument

- *Soundness*: Each confirmed positive query ("building" at $(x,y)$) is verified by binary search to determine the exact height of column $x$. The algorithm maintains the current best-known column and height and only replaces it upon finding a taller column.
- *Randomized benefit*: Random shuffle of columns yields good expected-time behavior against arbitrary distributions of tall columns; while not deterministic, the approach reduces the probability of scanning many low columns first.

=== Complexity and time-limit reasoning

- *Queries per sampled column*: In the worst case, a sampled column incurs one upward probe plus O(log h) queries for the binary search @laaksonen2018competitive[§3.3, p. 31] when successful.
- *Overall*: Expected number of probes depends on how many columns must be sampled before finding the global maximum; for typical inputs the randomized order finds the tallest column quickly, bounding total queries by roughly O(k log h) where $k$ is the number of promising columns encountered.

=== Empirical behavior and robustness

- *Practical performance*: The implementation uses an early-exit when current best height reaches $h$. Randomization prevents pathological ordering and makes runtime stable across many test cases.
- *Robustness*: Works well in interactive judges since it never makes assumptions about skyline structure and always verifies heights before reporting the answer.

=== Implementation notes

- *Attributed to:* Kristoffer Mejborn Eliasson (krme\@itu.dk)
- *Language used*: Python 3
- *Source listing*: @app-jaggedskyline
- *How to run*: Run against the `testing_tool.py` script which is given in the problem description on the [Kattis page](https://open.kattis.com/problems/jaggedskyline).
