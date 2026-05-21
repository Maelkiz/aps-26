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

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let t: Vec<&str> = input.split_whitespace().collect();
    let mut p = 0usize;

    let n = t[p].parse::<usize>().unwrap(); p += 1;
    let b = t[p].parse::<usize>().unwrap(); p += 1;

    let mut names = Vec::new();
    let mut costs = Vec::new();
    let mut golds = Vec::new();

    for _ in 0..n {
        let name = t[p].to_string(); p += 1;
        let cost = t[p].parse::<usize>().unwrap(); p += 1;
        let v = t[p].parse::<usize>().unwrap(); p += 1;
        let e = t[p].parse::<usize>().unwrap(); p += 1;
        let mut edges = Vec::new();
        for _ in 0..e {
            let u = t[p].parse::<usize>().unwrap(); p += 1;
            let w = t[p].parse::<usize>().unwrap(); p += 1;
            let cap = t[p].parse::<i64>().unwrap(); p += 1;
            edges.push((u, w, cap));
        }
        let gold = max_flow(v, &edges, 0, v - 1);
        names.push(name);
        costs.push(cost);
        golds.push(gold);
    }

    let mut dp = vec![vec![0i64; b + 1]; n + 1];
    for i in 1..=n {
        for j in 0..=b {
            dp[i][j] = dp[i - 1][j];
            if j >= costs[i - 1] {
                dp[i][j] = dp[i][j].max(golds[i - 1] + dp[i - 1][j - costs[i - 1]]);
            }
        }
    }

    let mut selected = Vec::new();
    let mut remaining = b;
    for i in (1..=n).rev() {
        if dp[i][remaining] != dp[i - 1][remaining] {
            selected.push(i - 1);
            remaining -= costs[i - 1];
        }
    }

    selected.reverse();
    for idx in &selected {
        println!("{} {}", idx, names[*idx]);
    }
}
