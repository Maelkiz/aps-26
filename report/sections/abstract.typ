= Abstract

This report documents the algorithmic problem solving work of Group H for APS 2026.

We designed *The Siege*, a problem combining two classical techniques: maximum network flow and 0/1 knapsack. Each of $N$ strongholds is modelled as a directed flow network; the gold yield equals the max-flow from source to sink. A warrior budget $B$ constrains which strongholds can be conquered. The intended solution runs Edmonds-Karp per stronghold and solves the resulting knapsack with dynamic programming in $O(N dot.c V E^2 + N B)$ time. A brute-force $O(2^N)$ subset search and a greedy ratio heuristic serve as the time-limit-exceeded and wrong-answer foils respectively.

#highlight[We solved three problems from the course problem set]. *Robert Hood* (geometry) finds the diameter of a point set using #highlight[Andrew's monotone chain convex hull followed by rotating calipers in $O(n log n)$]. *Cookie Selection* (algorithms on arrays) #highlight[maintains a dynamic multiset under insertions and median queries using a Fenwick tree with coordinate compression and binary descent in $O(n log n)$]. *Free Real Estate* (randomized algorithms) applies a #highlight[randomized approach to its core subproblem.]
