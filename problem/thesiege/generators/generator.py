#!/usr/bin/env python3
import random
import sys

if len(sys.argv) < 5:
    print("Usage: generator.py <seed> <N> <B> <max_V> [max_E] [max_cap] [max_cost]", file=sys.stderr)
    sys.exit(1)

random.seed(int(sys.argv[1]))
n = int(sys.argv[2])
b = int(sys.argv[3])
max_v = int(sys.argv[4])
max_e = int(sys.argv[5]) if len(sys.argv) > 5 else 40
max_cap = int(sys.argv[6]) if len(sys.argv) > 6 else 100
max_cost = int(sys.argv[7]) if len(sys.argv) > 7 else b

NAMES = [
    "ashfort", "blackspire", "coldholm", "darkwall", "elderkeep",
    "frostgate", "grimhold", "highcrest", "ironpeak", "jadekeep",
    "knightfall", "longmere", "mirestone", "northwatch", "oakveil",
    "pinewood", "quartzburg", "redmarch", "stormvale", "thornwick",
    "underhill", "voidreach", "westmoor", "xenolith", "yewfort",
    "zenithkeep", "ashenmoor", "bleakrock", "cragspire", "duskhollow",
    "embervault", "fellwatch", "gloomkeep", "havenwall", "icevein",
    "jarstone", "kragmore", "lichgate", "mosshaven", "nightholm",
    "obsidian", "palefort", "quietmere", "ravenpeak", "shadowfen",
    "tidebreak", "urnfield", "vinekeep", "wormwood", "xanthkeep",
]

used_names = random.sample(NAMES, min(n, len(NAMES)))
while len(used_names) < n:
    length = random.randint(3, 12)
    name = "".join(random.choices("abcdefghijklmnopqrstuvwxyz", k=length))
    if name not in used_names:
        used_names.append(name)

print(f"{n} {b}")

for i in range(n):
    v = random.randint(2, max_v)
    cost = random.randint(1, max_cost)

    edges = set()
    for node in range(v - 1):
        target = random.randint(node + 1, v - 1)
        cap = random.randint(1, max_cap)
        edges.add((node, target, cap))

    num_extra = random.randint(0, min(max_e - len(edges), v * (v - 1) - len(edges)))
    for _ in range(num_extra):
        attempts = 0
        while attempts < 20:
            u = random.randint(0, v - 1)
            w = random.randint(0, v - 1)
            if u != w and (u, w) not in {(a, b) for a, b, _ in edges}:
                cap = random.randint(1, max_cap)
                edges.add((u, w, cap))
                break
            attempts += 1

    edge_list = list(edges)
    random.shuffle(edge_list)
    e = len(edge_list)

    print(f"{used_names[i]} {cost} {v} {e}")
    for u, w, cap in edge_list:
        print(f"{u} {w} {cap}")
