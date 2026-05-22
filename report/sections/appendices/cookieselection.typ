== Cookie Selection Solution <app-cookieselection>

```python
import sys

class FenwickTree:
    def __init__(self, n: int):
        self.n = n
        self.tree = [0] * (n + 1)

    def update(self, i: int, delta: int) -> None:
        while i <= self.n:
            self.tree[i] += delta
            i += i & (-i)

    def query(self, i: int) -> int:
        s = 0
        while i > 0:
            s += self.tree[i]
            i -= i & (-i)
        return s

    def kth(self, k: int) -> int:
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

    values = sorted({int(x) for x in data if x != '#'})
    compress   = {v: i + 1 for i, v in enumerate(values)}
    decompress = {i + 1: v for i, v in enumerate(values)}

    bit = FenwickTree(len(values))
    n = 0
    out = []

    for token in data:
        if token == '#':
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
```
