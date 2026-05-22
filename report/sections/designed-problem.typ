= Designed Problem — The Siege (Dynamic Programming)

The Kattis-style problem "The Siege" is a problem that combines two paradigms from the course curriculum: network flow (max-flow on a directed weighted graph) and dynamic programming (0/1 knapsack). The solution requires one max-flow computation per stronghold followed by a single knapsack DP over the resulting values.
The problem statement for the issue is as follows.

```
You are Warchief Grukk, and today is a good day for war. Your Horde stands ready to crush the Dwarven Underkingdom, N strongholds carved deep into the mountains, each sitting on rich veins of gold.

Your goblin scouts (small, sneaky, and not terribly bright) have somehow wormed their way into every stronghold through cracks and drain pipes the dwarves forgot to seal. They came back clutching crumpled maps scratched onto hide scraps, giggling about "shiny rocks." The maps are crude but surprisingly accurate: each one shows the layout of tunnels inside a stronghold.

Deep inside each stronghold sits the Gold Vein (room 0), where the richest ore waits to be mined. Once you conquer a stronghold, your goblin miners will dig out the gold and load it into mine carts that run through the tunnel network to the stronghold entrance (room V_i - 1), where your wolf-riders wait with wagons.

Each tunnel is one-way: mine carts can only travel in one direction through it, carved that way to keep traffic from jamming. Each tunnel also has a weight limit: the maximum kilograms of gold ore that a mine cart can carry through it per hour. Your miners will haul as much gold as physically possible from the vein to the entrance, using every tunnel to its limit simultaneously. You need to figure out how much gold each stronghold can yield.

But strongholds do not fall for free. The dwarves fight like cornered badgers behind their stone barricades. Each assault costs orc warriors their lives. You can muster exactly B warriors for the entire campaign, and you must conquer your chosen strongholds before the elven relief army arrives. Choose which strongholds to take to maximise the total gold your miners extract. Each stronghold can only be taken once.

Present your Siege Plans to the war council: the list of strongholds the Horde will conquer.
```

The actual problem the contestant is tasked with is to compute the maximum total gold extractable from any subset of strongholds whose combined warrior cost does not exceed $B$, and to output the indices of that optimal subset in ascending order. We nominate *Dynamic Programming* as the curriculum topic this designed problem covers for exam-cancellation purposes.

== Accepted Solutions

All intended solutions decompose the problem into #highlight[two independent subproblems applied sequentially]: first compute a per-stronghold gold value via max-flow, then select the optimal stronghold subset via 0/1 knapsack DP. The Python and Rust accepted submissions implement this decomposition identically; the Rust version is included as a fast reference.

=== Per-stronghold Max-flow

For each stronghold $i$, the maximum flow from room $0$ (Gold Vein) to room $V_i - 1$ (entrance) is computed using *Edmonds-Karp*, a BFS-augmented variant of Ford-Fulkerson. BFS guarantees that each augmenting path is shortest in the residual graph, giving a running time of $O(V_i dot.c E_i^2)$ per stronghold. With the parameter bounds $V_i <= 15$ and $E_i <= 40$, this is at most $15 dot.c 40^2 = 24000$ residual-edge inspections per stronghold, and at most $N dot.c 24000 = 1.2 dot.c 10^6$ inspections across the whole input. The residual graph's reverse-edge handling is required to permit later corrections of previously committed flow.

=== 0/1 Knapsack DP

Once each stronghold has a gold value $g_i$ and a cost $c_i$, the selection problem reduces to 0/1 knapsack. A two-dimensional bottom-up DP fills the table
$
  "dp"[i][j] = cases(
    "dp"[i-1][j] & "if " j < c_i,
    max("dp"[i-1][j], space g_i + "dp"[i-1][j - c_i]) & "otherwise"
  )
$
with base case $"dp"[0][j] = 0$. The chosen indices are recovered by backtracking from $"dp"[N][B]$: stronghold $i$ was selected iff $"dp"[i][j] != "dp"[i-1][j]$. DP runs in $O(N dot.c B) = 5 dot.c 10^4$ steps, and backtracking is $O(N)$.

=== Combined Running Time

The overall accepted solution runs in $O(N dot.c V_(max) dot.c E_(max)^2 + N dot.c B)$, dominated by the $N$ max-flows for the given parameter bounds. Memory is $O(V_(max)^2)$ for each adjacency matrix plus $O(N dot.c B)$ for the DP table.

== Time Limit Exceeded Solutions

The TLE submission enumerates all $2^N$ subsets of strongholds, computes the total warrior cost and total gold for each feasible subset, and keeps the highest-gold subset within budget. It is correct on all inputs but runs in $O(2^N dot.c (N + V dot.c E^2))$, which exceeds the time limit for $N = 50$ where $2^(50) approx 10^(15)$ iterations are required. The TLE submission doubles as an oracle for verifying the DP solution on small instances ($N <= 20$).

== Wrong Solutions

The WA submission sorts strongholds by the gold-per-warrior ratio $g_i / c_i$ in descending order and greedily adds strongholds while the warrior budget allows. This is the optimal strategy for *fractional* knapsack but fails on 0/1 knapsack whenever a high-ratio item blocks a more profitable lower-ratio combination. A concrete counter-example with $B = 10$: items with $(c, g) = (4, 5), (4, 4), (6, 6)$ are taken by greedy in ratio order as $(4, 5) + (4, 4)$ for gold $9$, whereas the optimal $(4, 5) + (6, 6)$ has gold $11$. The WA submission therefore fails on any test case where the ratio ordering disagrees with the optimal subset; sample test `1-small-manual` is constructed to trigger this directly.

== Input Generation

Input generation is handled by `generators/generator.py`, a parameterised random generator that takes a seed and the parameters $(N, B, V_(max), E_(max), w_(max))$ and produces a syntactically valid problem instance. The generator chooses each stronghold's name from a fixed lowercase-letter dictionary, rejecting duplicates; picks each stronghold's warrior cost $c_i$ uniformly in $[1, B]$; and builds each tunnel graph by sampling $V_i$ and $E_i$ within bounds and emitting random directed edges with weight in $[1, w_(max)]$, rejecting duplicate $(u, v)$ pairs and self-loops.

The bulk of the secret tests are produced by running this generator with different seeds across four scale tiers ($N=1$, $N <= 5$, $N approx 20$, $N = 50$). Generated inputs are post-processed by the validator (see _Validation_ below) which enforces uniqueness of the optimal subset and rejects test cases where two distinct subsets tie on gold.

=== Edge Case Inputs

A small number of secret tests were hand-crafted (or hand-edited after generation) to cover behaviours that random sampling rarely produces. A single-stronghold input ($N = 1$ with the lone stronghold within budget) exercises the smallest-input boundary. A zero-flow stronghold input contains one stronghold whose graph is disconnected from sink to source so its max-flow is $0$; the DP must correctly treat it as a zero-value item. A cycle / back-edge input contains directed cycles that exercise Edmonds-Karp's residual-edge bookkeeping — a buggy implementation that omits reverse-edge updates under-counts flow here. A tie-break input was constructed so two subsets nearly tie on gold; the validator's uniqueness check rejects exact ties to keep the answer well-defined.

== Parameters

Two parameters were chosen carefully; the remaining graph parameters scale with them. The stated bounds are $1 <= N <= 50$, $1 <= B <= 1000$, $2 <= V_i <= 15$, $1 <= E_i <= 40$.

=== Stronghold count $N$

$N$ was capped at $50$ to ensure that the brute-force submission ($2^N$) is decisively infeasible at the upper bound while remaining tractable for the DP submission at $O(N dot.c B + N dot.c V dot.c E^2)$ work. Lower values of $N$ would allow brute-force to pass and weaken the TLE category; higher values would inflate the DP table beyond what the time limit comfortably permits in Python.

=== Warrior budget $B$

$B$ was capped at $1000$ so that the DP table size $N dot.c B = 5 dot.c 10^4$ is small enough to fit easily in memory and fast enough to fill in well under the time limit. Setting $B$ higher would shift the bottleneck from the max-flow step to the DP, which is undesirable because the curriculum focus we want to emphasise (knapsack DP) is meant to be visible but not the run-time pain point.

=== Graph parameters $V_i$, $E_i$

The per-stronghold graph is intentionally tiny ($V_i <= 15$, $E_i <= 40$). This keeps each Edmonds-Karp run effectively constant-time and prevents the max-flow step from dominating run-time across $N = 50$ strongholds. Larger graphs would also weaken the curriculum framing by making the problem feel like a pure flow problem rather than a flow-plus-DP composition.

== Validation

The input validator `input_validators/validator.py` enforces all syntactic constraints (regex-checked first line, name format and uniqueness, integer ranges for $c_i$, $V_i$, $E_i$, $u$, $v$, $w$, and absence of duplicate edges or self-loops within a stronghold), and then runs a full knapsack over the validated input to confirm that the optimal subset is *unique*. The validator exits with code $42$ on success and $43$ on either a syntactic violation or a tie on the optimal subset. This uniqueness check is what allows test inputs to specify a single canonical answer.

== Verifyproblem

`verifyproblem` was run from the `problem/thesiege/` directory. All sample and secret test cases pass the validator (exit code $42$). The accepted Python and Rust solutions pass all tests within the time limit; the brute-force submission is correctly flagged TLE on the $N = 50$ case and the greedy submission is correctly flagged WA on `1-small-manual`. No warnings were produced.
