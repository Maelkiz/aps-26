#-------------------------------------------------------------------------------
# Solution for https://open.kattis.com/problems/cookieselection
#-------------------------------------------------------------------------------

import sys

class FenwickTree:
    def __init__(self, n: int):
        self.n = n
        self.tree = [0] * (n + 1)

    def update(self, i: int, delta: int) -> None:
        """Add delta at position i (1-indexed)."""
        while i <= self.n:
            self.tree[i] += delta
            i += i & (-i)

    def query(self, i: int) -> int:
        """Return prefix sum [1..i]."""
        s = 0
        while i > 0:
            s += self.tree[i]
            i -= i & (-i)
        return s

    def kth(self, k: int) -> int:
        """
        Return the smallest index i such that prefix_sum[1..i] >= k.
        Uses O(log n) BIT descent instead of binary-searching query().
        """
        pos = 0
        log = self.n.bit_length()
        for i in range(log, -1, -1):
            nxt = pos + (1 << i)
            if nxt <= self.n and self.tree[nxt] < k:
                k -= self.tree[nxt]
                pos = nxt
        return pos + 1

def main():
    data = sys.stdin.read().split()

    # Coordinate compression (read all values first)
    values = sorted({int(x) for x in data if x != '#'})
    compress   = {v: i + 1 for i, v in enumerate(values)}   # value -> BIT index
    decompress = {i + 1: v for i, v in enumerate(values)}   # BIT index -> value

    bit = FenwickTree(len(values))
    n = 0 # cookies currently in holding area
    out = []

    for token in data:
        if token == '#':
            # Find cookie at rank floor(n/2) + 1
            rank = n // 2 + 1
            idx  = bit.kth(rank)
            out.append(decompress[idx])
            bit.update(idx, -1)
            n -= 1
        else:
            idx = compress[int(token)]
            bit.update(idx, 1)
            n += 1

    print('\n'.join(map(str, out)))


if __name__ == "__main__":
    main()