== Cookie Selection (Algorithms on Arrays)

=== Problem metadata

- *Problem name / Kattis link:* #link("https://open.kattis.com/problems/cookieselection")[Cookie Selection]
- *Short formal I/O description:* Given a sequence of up to $2 times 10^5$ events, each either inserting a positive integer into a multiset or querying and removing the element at rank $floor(n/2) + 1$ (1-indexed) from the sorted multiset of current size $n$, output each queried value on its own line.

=== Solution overview

The core challenge is maintaining a dynamic multiset that supports two operations in sublinear time: insertion of an element and extraction of the element at a given rank. A naive sorted list achieves $O(n)$ per operation, which is too slow for $n = 2 times 10^5$.

The solution uses a Fenwick tree over coordinate-compressed values. Because cookie diameters are up to $10^9$ but there are at most $2 times 10^5$ distinct values in the input, all values are mapped to contiguous indices $1, 2, dots, m$ where $m$ is the number of distinct values. The BIT stores counts: position $i$ holds how many cookies with compressed value $i$ are currently in the holding area. A prefix sum query then gives the number of cookies with value at most $i$.

To answer a rank query for rank $k$, the solution uses a binary descent on the BIT structure, finding the smallest index $i$ such that the prefix sum up to $i$ is at least $k$. This descent runs in $O(log m)$ rather than $O(log^2 m)$ compared to binary searching over prefix sum queries.

This approach was selected because the BIT offers simple, cache-friendly implementation while achieving the necessary $O(log n)$ per operation.

=== Correctness argument

*Coordinate compression.* All values are read before processing begins. The mapping $"compress": v mapsto i+1$ is a bijection from the set of distinct input values to ${1, dots, m}$, preserving order. Thus rank in the compressed BIT equals rank in the original multiset.

*BIT invariant.* After each insertion of value $v$, the BIT count at position $"compress"(v)$ is incremented by one. After each removal, it is decremented by one. Therefore, at any point, `bit.query(i)` equals the number of cookies currently in the holding area with compressed index at most $i$, which equals the number of cookies with diameter at most $"decompress"(i)$.

*Rank formula.* The problem specifies that for $n$ cookies the cookie sent is at position $floor(n/2) + 1$ in sorted order for both odd and even $n$. Setting `rank = n // 2 + 1` before each removal matches this specification exactly.

*kth correctness.* The binary descent in `kth(k)` maintains the invariant that `prefix_sum[1..pos] < k` throughout the loop and terminates with the smallest `pos + 1` satisfying `prefix_sum[1..pos+1] >= k`, which is exactly the $k$-th occupied position.

=== Complexity and time-limit reasoning

Let $N$ be the number of input lines and $m <= N$ the number of distinct cookie diameters.

- *Preprocessing:* sorting the distinct values takes $O(N log N)$.
- *Per event:* each insertion and each rank query performs one BIT update or descent, each costing $O(log m) = O(log N)$.
- *Overall:* $O(N log N)$ time and $O(N)$ space.

For $N = 2 times 10^5$ and a typical time limit of 1-2 seconds, roughly $2 times 10^5 times 17 approx 3.4 times 10^6$ elementary operations are required, which is well within budget even in Python given the constant factor of the BIT operations.

=== Empirical worst-case testing

A worst-case input inserts $N$ cookies then issues $N$ queries, exercising the BIT at maximum size. The following generator was used:

```python
N = 100000
for i in range(1, N + 1):
    print(i)
for _ in range(N):
    print('#')
```

This produces $2 times 10^5$ lines: $10^5$ insertions followed by $10^5$ queries, exercising both the coordinate compression and the BIT at maximum size. Running this input on the solution completed in approximately 0.67 seconds in CPython 3, which is within the Kattis time limit.

=== Implementation notes

- *Attributed to:* Karl Theodor Ruby (krub\@itu.dk)
- *Language used:* Python 3
- *Files:* `solutions/arrays/cookieselection.py`
- *How to run:* `python3 solutions/arrays/cookieselection.py < input.txt`
