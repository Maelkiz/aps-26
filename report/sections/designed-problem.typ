= Designed Problem — The Siege

== Problem description

You are Warchief Grukk, and today is a good day for war. Your Horde stands ready to crush the Dwarven Underkingdom, $N$ strongholds carved deep into the mountains, each sitting on rich veins of gold.

Your goblin scouts (small, sneaky, and not terribly bright) have somehow wormed their way into every stronghold through cracks and drain pipes the dwarves forgot to seal. They came back clutching crumpled maps scratched onto hide scraps, giggling about "shiny rocks." The maps are crude but surprisingly accurate: each one shows the layout of tunnels inside a stronghold.

Deep inside each stronghold sits the _Gold Vein_ (room $0$), where the richest ore waits to be mined. Once you conquer a stronghold, your goblin miners will dig out the gold and load it into mine carts that run through the tunnel network to the stronghold entrance (room $V_i - 1$), where your wolf-riders wait with wagons.

Each tunnel is _one-way_: mine carts can only travel in one direction through it, carved that way to keep traffic from jamming. Each tunnel also has a _weight limit_: the maximum kilograms of gold ore that a mine cart can carry through it per hour. Some tunnels are wide enough for a troll to stroll through; others are barely goblin-sized. Your miners will haul as much gold as physically possible from the vein to the entrance, using every tunnel to its limit simultaneously. You need to figure out how much gold each stronghold can yield.

But strongholds do not fall for free. The dwarves fight like cornered badgers behind their stone barricades. Each assault costs orc warriors their lives. You can muster exactly $B$ warriors for the entire campaign, and you must conquer your chosen strongholds before the elven relief army arrives. Choose which strongholds to take to maximise the total gold your miners extract. Each stronghold can only be taken once.

Present your _Siege Plans_ to the war council: the list of strongholds the Horde will conquer.

*Input*

The first line contains two integers $N$ and $B$ $(1 <= N <= 50, 1 <= B <= 1000)$, the number of dwarven strongholds and the number of orc warriors available.

Then $N$ stronghold descriptions follow. Each stronghold starts with a line containing:

- a string $s_i$, the name of the stronghold (lowercase `a`--`z`, no whitespace, length $<= 20$),
- an integer $c_i$ $(1 <= c_i <= B)$, the number of orc warriors lost conquering it,
- an integer $V_i$ $(2 <= V_i <= 15)$, the number of rooms,
- an integer $E_i$ $(1 <= E_i <= 40)$, the number of tunnels.

The next $E_i$ lines each describe one tunnel with three integers $u$, $v$, $w$ $(0 <= u, v < V_i, u != v, 1 <= w <= 100)$, meaning a one-way tunnel from room $u$ to room $v$ with weight limit $w$.

Room $0$ is the Gold Vein (source) and room $V_i - 1$ is the entrance (sink).

*Output*

Output the strongholds you should conquer to maximise total gold extracted without exceeding the warrior budget $B$. Print one line per selected stronghold in the format:

#block(inset: (left: 1.5em))[`<index> <name>`]

where `<index>` is the 0-based position of the stronghold in the input. Lines must appear in ascending order of index. It is guaranteed that the optimal subset is unique.

*Sample input 1:*
```
3 10
ironkeep 3 3 2
0 1 5
1 2 2
stonewall 6 4 4
0 1 3
0 2 2
1 3 2
2 3 3
thornhold 4 3 2
0 1 4
1 2 3
```

*Sample output 1:*
```
1 stonewall
2 thornhold
```

Max-flows: ironkeep = 2 (bottleneck edge 1→2, cap 2), stonewall = 4 (two augmenting paths: 0→1→3 flow 2, then 0→2→3 flow 2), thornhold = 3. With $B = 10$: stonewall+thornhold costs $6+4=10 <= 10$, gold $4+3=7$. ironkeep+stonewall costs $9$, gold $2+4=6$. So optimal is stonewall+thornhold.

== Intended solution

The problem decomposes into #highlight[two independent subproblems applied sequentially]:

1. *Per-stronghold max-flow.* For each stronghold $i$, compute the maximum flow from room $0$ to room $V_i - 1$ using Edmonds-Karp (BFS-augmented Ford-Fulkerson). This gives the gold value $g_i$.

2. *0/1 Knapsack DP.* Treat each stronghold as a knapsack item with weight $c_i$ and value $g_i$. Find the subset of items with total weight $<= B$ that maximises total value.

```
function solve():
    for each stronghold i:
        g[i] = edmonds_karp(graph_i, source=0, sink=V_i - 1)

    dp[0..N][0..B] = 0               // dp[i][j] = best gold using first i strongholds, budget j
    for i in 1..N:
        for j in 0..B:
            dp[i][j] = dp[i-1][j]    // skip stronghold i
            if j >= c[i]:
                dp[i][j] = max(dp[i][j], g[i] + dp[i-1][j - c[i]])

    // backtrack to recover selected indices
    remaining = B
    for i from N down to 1:
        if dp[i][remaining] != dp[i-1][remaining]:
            select stronghold i-1
            remaining -= c[i-1]
    output selected in ascending order
```

*Time complexity:*
- Edmonds-Karp per stronghold: $O(V_i dot.c E_i^2)$. With $V_i <= 15$, $E_i <= 40$: at most $15 times 40^2 = 24000$ operations each.
- All $N$ max-flows: $O(N dot.c V_(max) dot.c E_(max)^2) approx 50 times 24000 = 1.2 times 10^6$.
- Knapsack DP: $O(N dot.c B) = 50 times 1000 = 50000$.
- *Overall:* $O(N dot.c V E^2 + N B)$ — effectively constant given the small bounds.

*Memory:* $O(V_(max)^2)$ for the adjacency matrix per flow computation, $O(N dot.c B)$ for the DP table.

== Test-case design

*Sample tests* (manually crafted, small enough for hand-verification):

- *1-small-manual:* 3 strongholds, $B=10$. Tests basic knapsack selection; greedy by ratio picks the wrong pair.
- *2-medium-manual:* 3 strongholds with parallel-path graphs. Verifies that multi-path flow is summed correctly.
- *3-single-manual:* $N=1$, tests single-stronghold boundary; the one stronghold is within budget so it is selected.
- *4-zeroflow-manual:* One stronghold has no $s$-$t$ path (disconnected graph, flow = 0). Tests that a zero-gold stronghold is correctly skipped when a positive-gold alternative exists within budget.

*Secret tests* (generated by `generators/generator.py` or hand-crafted for specific corner cases):

- *1-single:* $N=1$, $B$ large — single item always selected if affordable.
- *2-small:* $N <= 5$, $B <= 20$ — brute-force can verify correctness.
- *3-medium:* $N approx 20$, $B approx 200$ — exercises DP without hitting any limit.
- *4-large:* $N=50$, $B=1000$ — maximum constraint stress test; brute-force $2^(50)$ is impossible.
- *5-tiebreak:* Constructed so two subsets tie in gold before one is broken by careful cost arrangement; validator enforces uniqueness, so this test confirms no two optimal subsets exist.
- *6-zeroflow:* Multiple strongholds with disconnected graphs (no $s$-$t$ path, gold = 0); tests that zero-value items do not inflate the knapsack answer.
- *7-cycle:* Graphs containing cycles and back-edges; confirms that residual graph reverse-edge handling in Edmonds-Karp is correct (a bug here would under-count flow).

*Corner cases covered:* $N=1$; $B$ exactly equal to one item cost; all items affordable; no item affordable; zero flow; graphs that are chains, parallel paths, or contain cycles.

== Accepted and wrong solutions

*Accepted — `submissions/accepted/solution.py` (Python 3) and `solution.rs` (Rust):*
Edmonds-Karp max-flow per stronghold, then 0/1 knapsack DP with backtracking. Both produce identical output. The Python solution runs comfortably within 2 seconds given the small problem bounds; the Rust solution is included as a fast reference.

*TLE — `submissions/time_limit_exceeded/brute_force.py` / `brute_force.rs`:*
Enumerates all $2^N$ subsets, computes total cost and gold for each, and keeps the best feasible subset. Correct for small $N$ but $2^(50) approx 10^(15)$ iterations makes it infeasible for $N = 50$. Used to verify correctness of the DP solution on small inputs.

*WA — `submissions/wrong_answer/greedy.py`:*
Sorts strongholds by the gold-per-warrior ratio $g_i / c_i$ descending and greedily adds items as long as they fit in the remaining budget. This is the optimal strategy for *fractional* knapsack but fails for 0/1 knapsack. Counter-example from sample 2 ($B=10$): ravencrest has ratio $5/4=1.25$, wolfgate $4/4=1.0$, dragonspire $6/6=1.0$. Greedy picks ravencrest ($c=4$, $g=5$) then wolfgate ($c=4$, $g=4$), total gold $= 9$. Optimal is dragonspire + ravencrest ($c=10$, $g=11$): the lower-ratio dragonspire contributes more absolute gold than wolfgate, which the ratio heuristic cannot see.

== Input validation & formatting

`input_validators/validator.py` enforces all constraints via regex and range checks, then runs a full knapsack over all test inputs to confirm the optimal solution is *unique* (exits with code 43 if $>= 2$ optimal subsets exist, exits with code 42 on success). Specific checks:

- Line 1 matches `^[1-9][0-9]* [1-9][0-9]*\n$`; $N in [1,50]$, $B in [1,1000]$.
- Each castle header: name lowercase letters only, length $<= 20$, globally unique; $c_i in [1, B]$; $V_i in [2, 15]$; $E_i in [1, 40]$.
- Each edge line: $u, v in [0, V_i - 1]$, $u != v$, no duplicate $(u, v)$ pair within the same stronghold; $w in [1, 100]$.
- No trailing content after the last edge.

Contestants may assume all input is well-formed and within these bounds.

== Verify notes

`verifyproblem` was run from the `problem/thesiege/` directory. All sample and secret test cases pass the validator (exit 42). The accepted solutions pass all tests. The brute-force solution is correctly flagged TLE on `4-large` and the greedy is correctly flagged WA on `1-small-manual`. No warnings were produced.

== Testing and Validation

Run the accepted Python solution on a sample test:

```bash
python3 submissions/accepted/solution.py < data/sample/1-small-manual.in
```

Run the validator on an input (exit code 42 = valid and unique-optimal, 43 = invalid):

```bash
python3 input_validators/validator.py < data/sample/1-small-manual.in; echo "exit $?"
```

Generate a large random test and time the accepted solution:

```bash
python3 generators/generator.py 42 50 1000 15 40 100 > /tmp/large.in
time python3 submissions/accepted/solution.py < /tmp/large.in
```

Diff DP against brute-force on a small instance:

```bash
python3 generators/generator.py 7 5 20 8 15 50 > /tmp/small.in
python3 submissions/accepted/solution.py < /tmp/small.in > /tmp/dp.out
python3 submissions/time_limit_exceeded/brute_force.py < /tmp/small.in > /tmp/bf.out
diff /tmp/dp.out /tmp/bf.out
```

== Source for Designed Problem

Repository layout under `problem/thesiege/`:

```
problem/thesiege/
  problem.yaml                       problem metadata (name, type, uuid)
  problem_statement/problem.en.tex   LaTeX problem statement
  submissions/
    accepted/solution.py             Python 3 accepted solution
    accepted/solution.rs             Rust accepted solution
    time_limit_exceeded/brute_force.py
    time_limit_exceeded/brute_force.rs
    wrong_answer/greedy.py
  generators/generator.py            parametric random generator
  input_validators/validator.py      constraint + uniqueness checker
  data/
    sample/   4 hand-crafted sample cases (.in / .ans)
    secret/   7 generated/hand-crafted secret cases (.in / .ans)
```

Run locally with `verifyproblem` (requires the `problemtools` package):

```bash
cd problem/
verifyproblem thesiege/
```
