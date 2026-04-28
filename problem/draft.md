## Problem Title: Temporal Flux Optimization

### Problem Description
You are managing a resource distribution network that operates over $T$ discrete time steps. The network consists of $N$ nodes, labeled $1$ to $N$. Your goal is to move as much "commodity" as possible from a source node $S$ at time $t=1$ to a sink node $K$ at time $t=T$.

### Part 1: The Capacity DP
The capacity of a directed edge $(u, v)$ is not constant. It is determined by the maximum "stability score" possible between two nodes. For any pair of nodes $(u, v)$ where $u < v$, the base capacity $C_{u,v}$ is derived from a state-based recurrence:

$$dp(u, v) = w_{u,v} + \max_{u < k < v} \{ \min(dp(u, k), dp(k, v)) \}$$

Where:
* $w_{u,v}$ is a provided weight matrix.
* The base cases for adjacent indices or specific conditions are defined in the input.
* **Constraint:** The flow network for Part 2 only exists between nodes where $dp(u, v) \geq \theta$ (a given threshold).



### Part 2: The Spatio-Temporal Max Flow
Once the capacities $C_{u,v} = dp(u, v)$ are calculated, you must construct a temporal graph to account for the $T$ time steps. 
* Each node $i \in N$ at time $t$ is represented as $u_{i,t}$.
* **Intra-step edges:** For each time $t \in [1, T]$, if $dp(u, v) \geq \theta$, a directed edge exists from $u_{u,t}$ to $u_{v,t}$ with capacity $C_{u,v}$.
* **Inter-step edges:** A node can "hold" commodity over time. For each node $i$, an edge exists from $u_{i,t}$ to $u_{i,t+1}$ with a fixed storage capacity $M_i$.

**Objective:** Find the maximum flow from the super-source (node $S$ at $t=1$) to the super-sink (node $K$ at $t=T$).



---

### Mathematical Constraints & Rigor

1.  **DP Necessity:** The recurrence $dp(u, v)$ follows an optimal substructure similar to the All-Pairs Shortest Path or Matrix Chain Multiplication. Because $C_{u,v}$ depends on the maximum of minimums of intermediate states, a simple greedy approach will fail to find the correct capacity for the flow network.
2.  **Flow Necessity:** Since the network has both spatial constraints (edges between nodes) and temporal constraints (storage limits $M_i$ across time), the problem cannot be solved by a simple longest path or standard DP. The bottleneck could be either the edge capacities $C_{u,v}$ or the storage capacity $M_i$ over several time steps.
3.  **Input Bounds:**
    * $N \le 100$ (allows $O(N^3)$ DP).
    * $T \le 50$ (allows the flow graph to have $N \times T$ nodes).
    * $w_{u,v} \in [0, 10^6]$.

---

### Formal Output Requirement
Output a single integer representing the maximum volume of commodity that can reach node $K$ at $T=T$ starting from node $S$ at $t=1$.

### Implementation Note for the Author
To ensure the DP is "unavoidable," ensure the weight matrix $w_{u,v}$ is sparse, but the resulting $dp(u, v)$ table is dense. To ensure Flow is "unavoidable," set the storage capacities $M_i$ such that they frequently bottleneck the spatial capacities $C_{u,v}$, forcing the algorithm to distribute flow across both time and space.
