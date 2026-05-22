import sys
import random

def query(x: int, y: int) -> str:
    """Send a query and read the interactor's response."""
    print(f"? {x} {y}", flush=True)
    return sys.stdin.readline().strip()

def solve() -> None:
    w, h = map(int, sys.stdin.readline().split())
    
    # Monte Carlo: randomize column order to avoid worse-case scenario
    columns = list(range(1, w + 1))
    random.shuffle(columns)
    
    best_x = 1
    best_h = 0
    
    for x in columns:
        if best_h == h:
            break  # Cannot improve further
        
        y = best_h + 1
        if y > h:
            break
        
        # Single-query check: is this column taller than our current best?
        if query(x, y) == "building":
            # Binary search exact height in [y, h]
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