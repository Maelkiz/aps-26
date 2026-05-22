== Robert Hood Solution <app-roberthood>

```python
import math

def cross(O, A, B):
    return (A[0]-O[0])*(B[1]-O[1]) - (A[1]-O[1])*(B[0]-O[0])

def convex_hull(pts):
    pts = sorted(set(pts))
    if len(pts) <= 1:
        return pts
    lower = []
    for p in pts:
        while len(lower) >= 2 and cross(lower[-2], lower[-1], p) <= 0:
            lower.pop()
        lower.append(p)
    upper = []
    for p in reversed(pts):
        while len(upper) >= 2 and cross(upper[-2], upper[-1], p) <= 0:
            upper.pop()
        upper.append(p)
    return lower[:-1] + upper[:-1]

def dist2(a, b):
    return (a[0]-b[0])**2 + (a[1]-b[1])**2

n = int(input())
pts = [tuple(map(int, input().split())) for _ in range(n)]

hull = convex_hull(pts)
m = len(hull)

if m == 1:
    print(0.0)
elif m == 2:
    print(math.sqrt(dist2(hull[0], hull[1])))
else:
    max_d2 = 0
    j = 1
    for i in range(m):
        a, b = hull[i], hull[(i+1) % m]
        while True:
            c = hull[j]
            d = hull[(j+1) % m]
            cx = (b[0]-a[0])*(d[1]-c[1]) - (b[1]-a[1])*(d[0]-c[0])
            if cx > 0:
                j = (j+1) % m
            else:
                break
        max_d2 = max(max_d2, dist2(hull[i], hull[j]),
                              dist2(hull[(i+1)%m], hull[j]))
    print(math.sqrt(max_d2))
```
