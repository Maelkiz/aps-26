import sys
import re
from collections import defaultdict, deque


def exit_error(message):
    print(message, file=sys.stderr)
    sys.exit(43)


def max_flow(num_nodes, edges, source, sink):
    graph = defaultdict(lambda: defaultdict(int))
    for u, v, cap in edges:
        graph[u][v] += cap
    total_flow = 0
    while True:
        parent = {}
        visited = {source}
        queue = deque([source])
        found = False
        while queue:
            u = queue.popleft()
            for v in graph[u]:
                if v not in visited and graph[u][v] > 0:
                    visited.add(v)
                    parent[v] = u
                    if v == sink:
                        found = True
                        break
                    queue.append(v)
            if found:
                break
        if not found:
            break
        path_flow = float("inf")
        v = sink
        while v != source:
            u = parent[v]
            path_flow = min(path_flow, graph[u][v])
            v = u
        v = sink
        while v != source:
            u = parent[v]
            graph[u][v] -= path_flow
            graph[v][u] += path_flow
            v = u
        total_flow += path_flow
    return total_flow


line = sys.stdin.readline()
if not re.match(r"^[1-9][0-9]* [1-9][0-9]*\n$", line):
    exit_error("Expected two positive integers on line 1")

parts = line.split()
n = int(parts[0])
b = int(parts[1])

if n < 1 or n > 50:
    exit_error(f"N={n} out of range [1, 50]")
if b < 1 or b > 1000:
    exit_error(f"B={b} out of range [1, 1000]")

seen_names = set()
castles = []

for i in range(n):
    line = sys.stdin.readline()
    if not line:
        exit_error(f"Expected castle {i}, hit EOF")

    if not re.match(r"^[a-z]+ [1-9][0-9]* [1-9][0-9]* [1-9][0-9]*\n$", line):
        exit_error(f"Invalid castle header on castle {i}")

    parts = line.split()
    name = parts[0]
    cost = int(parts[1])
    v = int(parts[2])
    e = int(parts[3])

    if len(name) > 20:
        exit_error(f"Castle name too long: {name}")
    if name in seen_names:
        exit_error(f"Duplicate castle name: {name}")
    seen_names.add(name)
    if cost < 1 or cost > b:
        exit_error(f"Cost {cost} out of range [1, {b}]")
    if v < 2 or v > 15:
        exit_error(f"V={v} out of range [2, 15]")
    if e < 1 or e > 40:
        exit_error(f"E={e} out of range [1, 40]")

    seen_edges = set()
    edges = []
    for j in range(e):
        eline = sys.stdin.readline()
        if not eline:
            exit_error(f"Expected edge {j} of castle {i}, hit EOF")
        if not re.match(r"^(0|[1-9][0-9]*) (0|[1-9][0-9]*) [1-9][0-9]*\n$", eline):
            exit_error(f"Invalid edge format on castle {i}, edge {j}")

        eparts = eline.split()
        u = int(eparts[0])
        ev = int(eparts[1])
        cap = int(eparts[2])

        if u < 0 or u >= v:
            exit_error(f"u={u} out of range [0, {v-1}]")
        if ev < 0 or ev >= v:
            exit_error(f"v={ev} out of range [0, {v-1}]")
        if u == ev:
            exit_error(f"Self-loop: u=v={u}")
        if (u, ev) in seen_edges:
            exit_error(f"Duplicate edge ({u}, {ev}) in castle {i}")
        seen_edges.add((u, ev))
        if cap < 1 or cap > 100:
            exit_error(f"cap={cap} out of range [1, 100]")
        edges.append((u, ev, cap))

    gold = max_flow(v, edges, 0, v - 1)
    castles.append((cost, gold))

if sys.stdin.readline() != "":
    exit_error("Trailing content after input")

dp = [(0, 1)] * (b + 1)
for cost_i, gold_i in castles:
    new_dp = list(dp)
    for j in range(cost_i, b + 1):
        val = gold_i + dp[j - cost_i][0]
        if val > new_dp[j][0]:
            new_dp[j] = (val, dp[j - cost_i][1])
        elif val == new_dp[j][0]:
            new_dp[j] = (val, new_dp[j][1] + dp[j - cost_i][1])
    dp = new_dp

_, num_ways = dp[b]
if num_ways != 1:
    exit_error(f"Optimal solution not unique: {num_ways} optimal subsets")

sys.exit(42)
