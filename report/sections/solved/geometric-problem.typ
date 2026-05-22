== Robert Hood (Geometric Algorithms)

=== Problem metadata

- *Problem name / Kattis link:* #link("https://open.kattis.com/problems/roberthood")[Robert Hood]
- *Short formal I/O description:* Given $n$ points in the plane with integer coordinates, output the maximum Euclidean distance between any two points, as a floating-point number.

=== Solution overview

The maximum distance between any two points in a finite set is always achieved by two points on the convex hull of the set. This reduces the problem to two steps: compute the convex hull, then find the diameter of the hull polygon.

The convex hull is computed using Andrew's monotone chain algorithm @laaksonen2018competitive[§30.3, p. 278], which sorts the points lexicographically and constructs the lower and upper hull in two linear passes. The result is the vertices of the hull in counter-clockwise order.

The diameter of the convex polygon is then found using the rotating calipers technique. For each edge of the hull, the algorithm advances an antipodal pointer $j$ as long as the next vertex is farther from the edge than the current one. The cross product of the edge direction and the vector between consecutive candidate points determines the direction to move $j$. Both endpoints of the current edge are checked against $j$ at each step, so no antipodal pair is missed.

This approach was chosen because it achieves optimal asymptotic complexity and avoids the $O(m^2)$ brute-force over hull vertices, which could be slow when all input points lie on the hull.

=== Correctness argument

*Reduction to hull.* Any point strictly inside the convex hull cannot be a diameter endpoint, since projecting it outward to the hull boundary only increases distance. Therefore the maximum distance is realised by two hull vertices.

*Rotating calipers.* The algorithm maintains the invariant that $j$ is the index of the vertex farthest from the directed edge between `hull[i]` and `hull[i+1]`, among all indices not yet "passed" by $i$. The cross product check `cx > 0` advances $j$ when the next vertex is strictly farther, and stops otherwise. Because the hull is convex, the distance from an edge is unimodal over consecutive vertices, so the pointer $j$ never needs to retreat. Both `hull[i]` and `hull[(i+1) % m]` are compared to `hull[j]` at each step to cover all antipodal pairs correctly.

*Edge cases.* When $m = 1$ (all points identical) the distance is 0. When $m = 2$ (collinear or just two distinct points) the distance is computed directly. These are handled before the calipers loop.

=== Complexity and time-limit reasoning

Let $n$ be the number of input points and $m$ the number of hull vertices, with $m <= n$.

- *Convex hull:* $O(n log n)$ dominated by the initial sort.
- *Rotating calipers:* $O(m)$ since each pointer advances at most $m$ times.
- *Overall:* $O(n log n)$ time and $O(n)$ space.

For $n = 10^5$, this is approximately $10^5 times 17 approx 1.7 times 10^6$ operations for the sort, plus a linear pass. The implementation avoids square roots until the final step by comparing squared distances, eliminating floating-point overhead from the inner loop.

=== Empirical worst-case testing

The worst case for the rotating calipers occurs when all input points lie on the convex hull, maximising $m$. A set of $n$ points uniformly distributed on a large circle achieves this. The following generator was used:

```python
import math
N = 100000
print(N)
for i in range(N):
    angle = 2 * math.pi * i / N
    x = round(1e9 * math.cos(angle))
    y = round(1e9 * math.sin(angle))
    print(x, y)
```

Running this input on the solution completed in approximately 0.73 seconds in CPython 3, which is within the Kattis time limit.

=== Implementation notes

- *Attributed to:* Lukas Shaghashvili-Johanesson (lush\@itu.dk)
- *Language used:* Python 3
- *Source listing:* @app-roberthood
- *How to run:* pipe the input file into the script via standard input.
