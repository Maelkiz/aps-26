use std::collections::VecDeque;
use std::io::{self, Read};

fn bfs(graph: &Vec<Vec<i64>>, source: usize, sink: usize, parent: &mut Vec<i64>) -> bool {
    let n = graph.len();
    let mut visited = vec![false; n];
    visited[source] = true;
    let mut queue = VecDeque::new();
    queue.push_back(source);
    while let Some(u) = queue.pop_front() {
        for v in 0..n {
            if !visited[v] && graph[u][v] > 0 {
                visited[v] = true;
                parent[v] = u as i64;
                if v == sink {
                    return true;
                }
                queue.push_back(v);
            }
        }
    }
    false
}

fn max_flow(num_nodes: usize, edges: &[(usize, usize, i64)], source: usize, sink: usize) -> i64 {
    let mut graph = vec![vec![0i64; num_nodes]; num_nodes];
    for &(u, v, cap) in edges {
        graph[u][v] += cap;
    }
    let mut total_flow = 0;
    let mut parent = vec![-1i64; num_nodes];
    while bfs(&graph, source, sink, &mut parent) {
        let mut path_flow = i64::MAX;
        let mut v = sink;
        while v != source {
            let u = parent[v] as usize;
            path_flow = path_flow.min(graph[u][v]);
            v = u;
        }
        let mut v = sink;
        while v != source {
            let u = parent[v] as usize;
            graph[u][v] -= path_flow;
            graph[v][u] += path_flow;
            v = u;
        }
        total_flow += path_flow;
        parent.fill(-1);
    }
    total_flow
}

struct Scanner<'a> {
    tokens: Vec<&'a str>,
    pos: usize,
}

impl<'a> Scanner<'a> {
    fn new(input: &'a str) -> Self {
        Scanner {
            tokens: input.split_whitespace().collect(),
            pos: 0,
        }
    }
    fn s(&mut self) -> &'a str {
        let t = self.tokens[self.pos];
        self.pos += 1;
        t
    }
    fn i(&mut self) -> i64 {
        self.s().parse::<i64>().unwrap()
    }
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut sc = Scanner::new(&input);

    let n = sc.i() as usize;
    let b = sc.i() as usize;

    let mut names = Vec::new();
    let mut costs = Vec::new();
    let mut golds = Vec::new();

    for _ in 0..n {
        let name = sc.s().to_string();
        let cost = sc.i() as usize;
        let v = sc.i() as usize;
        let e = sc.i() as usize;
        let mut edges = Vec::new();
        for _ in 0..e {
            let u = sc.i() as usize;
            let w = sc.i() as usize;
            let cap = sc.i();
            edges.push((u, w, cap));
        }
        let gold = max_flow(v, &edges, 0, v - 1);
        names.push(name);
        costs.push(cost);
        golds.push(gold);
    }

    let mut best_gold: i64 = -1;
    let mut best_subset: Vec<usize> = Vec::new();

    for mask in 0..(1u64 << n) {
        let mut total_cost = 0usize;
        let mut total_gold = 0i64;
        let mut subset = Vec::new();
        for i in 0..n {
            if mask & (1u64 << i) != 0 {
                total_cost += costs[i];
                total_gold += golds[i];
                subset.push(i);
            }
        }
        if total_cost <= b && (total_gold > best_gold || (total_gold == best_gold && subset < best_subset)) {
            best_gold = total_gold;
            best_subset = subset;
        }
    }

    for idx in &best_subset {
        println!("{} {}", idx, names[*idx]);
    }
}
