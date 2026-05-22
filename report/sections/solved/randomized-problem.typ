
== Jagged Skyline (Randomized Algorithm)

=== Problem metadata

- *Problem name / Kattis link:* #link("https://open.kattis.com/problems/jaggedskyline")[Jagged Skyline]
- *Input/Output* Interactively discover the tallest building column in a skyline of width $w$ and height $h$ using height queries of the form "is there a building at column $x$ of height at least $y$?". The interactor answers with a positive/negative response for each query.

=== Solution overview

- *Solution* We take a las vegas approach and use random sampling of the columns to reduce the likelihood of worst-case scenarios, and binary searches guided by storing the highest columns. This way we don't waste time on calculating buildings we know are shorter than what we already have. We have assurance that each confirmed positive query ("building" at $(x,y)$) is verified by binary search to determine the exact height of column $x$. The algorithm maintains the current best-known column and height and only replaces it upon finding a taller column. Since each confirmed positive query is verified by binary search, the exact height of the column is calculated. The random shuffle of columns yields good expected-time behavior against arbitrary distributions of tall columns; while not running in a deterministic runtime, the approach reduces the probability of scanning many low columns first.
In the worst case, a sampled column incurs one upward probe plus O(log h) queries for the binary search when successful. Overall the expected number of probes depends on how many columns must be sampled before finding the global maximum; for typical inputs the randomized order finds the tallest column quickly, bounding total queries by roughly O(k log h) where $k$ is the number of promising columns encountered.
To speed things up, the implementation uses an early-exit when current best height reaches $h$. Randomization prevents worst-case ordering and makes runtime stable across many test cases.
The implementation works well with interactive  since it never makes assumptions about skyline structure and always verifies heights before reporting the answer.

=== Implementation notes

- *Language used*: Python 3
- *Files*: [solutions/random/jaggedskyline.py](solutions/random/jaggedskyline.py)
- *How to run*: Run against an interactive judge that speaks the protocol. Locally, pair the script with a test interactor or use judge-provided tools. The script prints queries of the form `? x y` and expects a single-line response (e.g. `building` or other negative token), and finishes by printing `! x h`.

=== References

- *Source*: Las Vegas sampling pattern implemented in [solutions/random/jaggedskyline.py](solutions/random/jaggedskyline.py).
