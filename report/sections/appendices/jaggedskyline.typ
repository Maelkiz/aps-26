== Jagged Skyline Solution <app-jaggedskyline>

```python
import sys
import random

def query(x: int, y: int) -> str:
    print(f"? {x} {y}", flush=True)
    return sys.stdin.readline().strip()

def solve() -> None:
    w, h = map(int, sys.stdin.readline().split())

    columns = list(range(1, w + 1))
    random.shuffle(columns)

    best_x = 1
    best_h = 0

    for x in columns:
        if best_h == h:
            break

        y = best_h + 1
        if y > h:
            break

        if query(x, y) == "building":
            lo, hi = y, h
            while lo < hi:
                mid = (lo + hi + 1) // 2
                if query(x, mid) == "building":
                    lo = mid
                else:
                    hi = mid - 1
            best_x = x
            best_h = lo

    print(f"! {best_x} {best_h}", flush=True)

if __name__ == "__main__":
    solve()
```
