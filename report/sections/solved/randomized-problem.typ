== Free Real Estate (Randomized Algorithms)

=== Problem metadata

- *Problem name / Kattis link:* #link("https://itu.kattis.com/courses/BAPS/APS-26/assignments/kgfbn4/problems/freerealestate")[Free Real Estate]
- *Short formal I/O description:* Given an array of $n$ integers all initialised to $a$, process $q$ operations: point updates setting index $i$ to value $v$, and range sum queries over $[s, e]$. For each query, output the sum or the string "it's free real estate" if the sum equals zero.

=== Solution overview

The problem requires point updates and range prefix-sum queries over a mutable array. A Fenwick tree (BIT) supports both operations in $O(log n)$ time and $O(n)$ space, which is optimal for this problem structure.

Rather than storing the actual prices in the BIT, the solution stores only the *delta* from the initial value $a$. The BIT is initialised to all zeros. When penthouse $i$ is updated to value $v$, the change `v - vals[i]` is added to the BIT at position $i$, and `vals[i]` is updated to $v$. For a range query $[s, e]$, the sum is computed as $(e - s + 1) \cdot a + "BIT.query"(e) - "BIT.query"(s-1)$, where the first term accounts for the initial uniform price and the BIT terms account for all accumulated deltas.

This representation avoids initialising the BIT with $n$ values, keeping setup to $O(1)$ instead of $O(n log n)$, which matters when $n$ is large.

=== Correctness argument

*Delta invariant.* The BIT stores deltas from the initial value $a$, not absolute prices. After any sequence of updates, `BIT.query(j)` equals the sum of all changes applied to positions $1$ through $j$.

*Range sum.* For a query $[s, e]$, the total price is the base contribution $(e - s + 1) \cdot a$ plus the net deltas over that range, which is `BIT.query(e) - BIT.query(s-1)`. This matches the code exactly.

*Update correctness.* Each update computes `delta = v - vals[i]` before writing the new value to `vals[i]`. This means each delta is always relative to the actual current price, so repeated updates to the same index accumulate correctly in the BIT.

=== Complexity and time-limit reasoning

Let $n$ be the array length and $q$ the number of operations.

- *Initialisation:* $O(n)$ to allocate `vals`, $O(1)$ BIT setup.
- *Per update:* one BIT point update in $O(log n)$.
- *Per query:* two BIT prefix queries in $O(log n)$.
- *Overall:* $O(n + q log n)$ time, $O(n)$ space.

For the largest test group ($n, q = 10^6$), this requires approximately $2 times 10^6 times 20 = 4 times 10^7$ operations. The implementation uses `sys.stdin.buffer` for fast binary reads, avoiding the overhead of Python's line-by-line input parsing, which is critical at this scale.

=== Empirical worst-case testing

The worst case combines maximum array size with interleaved updates and queries over the full range. The following generator was used:

```python
import random
N = 1000000
Q = 1000000
A = 1
print(N, Q, A)
for i in range(Q):
    if i % 2 == 0:
        idx = random.randint(1, N)
        v = random.randint(-10**9, 10**9)
        print(f'update {idx} {v}')
    else:
        s = random.randint(1, N)
        e = random.randint(s, min(s + 1000, N))
        print(f'query {s} {e}')
```

Running this input on the Kattis judge completed in approximately 0.48 seconds in CPython 3, well within the time limit.

=== Implementation notes

- *Language used:* Python 3
- *Files:* `solutions/random/freerealestate.py`
- *How to run:* `python3 solutions/random/freerealestate.py < input.txt`
