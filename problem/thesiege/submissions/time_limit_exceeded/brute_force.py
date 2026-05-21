import sys
from collections import defaultdict, deque

input = sys.stdin.read
tokens = input().split()
pos = 0


def next_token():
    global pos
    t = tokens[pos]
    pos += 1
    return t


def next_int():
    return int(next_token())


def bfs(graph, source, sink, parent):
    visited = {source}
    queue = deque([source])
    while queue:
        u = queue.popleft()
        for v in graph[u]:
            if v not in visited and graph[u][v] > 0:
                visited.add(v)
                parent[v] = u
                if v == sink:
                    return True
                queue.append(v)
    return False


def max_flow(num_nodes, edges, source, sink):
    graph = defaultdict(lambda: defaultdict(int))
    for u, v, cap in edges:
        graph[u][v] += cap
    total_flow = 0
    while True:
        parent = {}
        if not bfs(graph, source, sink, parent):
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


n = next_int()
b = next_int()

castles = []
for _ in range(n):
    name = next_token()
    cost = next_int()
    v = next_int()
    e = next_int()
    edges = []
    for _ in range(e):
        u_node = next_int()
        v_node = next_int()
        cap = next_int()
        edges.append((u_node, v_node, cap))
    gold = max_flow(v, edges, 0, v - 1)
    castles.append((name, cost, gold))

best_gold = -1
best_subset = []

for mask in range(1 << n):
    total_cost = 0
    total_gold = 0
    subset = []
    for i in range(n):
        if mask & (1 << i):
            total_cost += castles[i][1]
            total_gold += castles[i][2]
            subset.append(i)
    if total_cost <= b:
        if total_gold > best_gold or (total_gold == best_gold and subset < best_subset):
            best_gold = total_gold
            best_subset = subset

for idx in best_subset:
    print(f"{idx} {castles[idx][0]}")
