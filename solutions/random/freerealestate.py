import sys

def main():
    data = sys.stdin.buffer.read().split()
    idx = 0
    n = int(data[idx]); idx += 1
    q = int(data[idx]); idx += 1
    a = int(data[idx]); idx += 1

    tree = [0] * (n + 1)
    vals = [a] * (n + 1)

    def update(i, delta):
        while i <= n:
            tree[i] += delta
            i += i & (-i)

    def query(i):
        s = 0
        while i > 0:
            s += tree[i]
            i -= i & (-i)
        return s

    out = []
    for _ in range(q):
        op = data[idx]; idx += 1
        if op == b'update':
            i = int(data[idx]); idx += 1
            v = int(data[idx]); idx += 1
            delta = v - vals[i]
            vals[i] = v
            update(i, delta)
        else:
            s = int(data[idx]); idx += 1
            e = int(data[idx]); idx += 1
            total = (e - s + 1) * a + query(e) - query(s - 1)
            if total == 0:
                out.append("it's free real estate")
            else:
                out.append(str(total))

    sys.stdout.write('\n'.join(out))
    if out:
        sys.stdout.write('\n')

main()