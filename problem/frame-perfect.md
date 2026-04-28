This problem is inspired by the "Tight Words" DP challenge. Instead of digits, we use **Move Sets**, and instead of a numerical difference of 1, we use **Frame Advantage**.

---

# Frame Perfect

In the high-stakes world of "Kattis Fighter V," winning isn't just about button mashing—it's about **frame data**. Every move a character performs consists of three distinct phases:

1.  **Windup ($W$):** The number of frames before the move's hitbox becomes active.
2.  **Active ($A$):** The frames where the move can actually hit the opponent. (For simplicity, we assume the hit connects on the very first active frame).
3.  **Recovery ($R$):** The frames after the hit where your character is stuck in an animation and cannot move.

When a move hits an opponent, they enter **Hitstun ($H$)**. This is a period during which the opponent is completely immobilized. 

A **True Combo** is a sequence of moves where the opponent is never given a single frame to recover or retaliate. For a move $M_1$ to combo into $M_2$, the **Windup** of $M_2$ must be less than or equal to the **Frame Advantage** of $M_1$.



### The Math
The **Frame Advantage ($F$)** of a move is calculated as:
$$F = H - R$$
A sequence of moves $\{M_1, M_2, \dots, M_L\}$ is a **True Combo** if for every adjacent pair of moves $(M_i, M_{i+1})$:
$$W_{i+1} \le F_i$$

### The Problem
Given a set of $K$ possible moves and a desired combo length $L$, calculate the **total number of unique True Combos** that can be formed.

---

## Input
The input consists of multiple test cases.
* The first line of each test case contains two integers: $K$ (the number of moves, $1 \le K \le 50$) and $L$ (the length of the combo, $1 \le L \le 100$).
* The next $K$ lines each describe a move with a name (a single string) and three integers: $W$ (Windup), $R$ (Recovery), and $H$ (Hitstun). All frame values are between $1$ and $100$.

## Output
For each test case, output the total number of unique True Combos of length $L$. Since this number can be very large, output it **modulo $10^9 + 7$**.

---

## Sample Walkthrough

**Moves Available:**
* **Jab:** $W=3, R=5, H=10$ (Advantage $F = 5$)
* **Kick:** $W=6, R=10, H=15$ (Advantage $F = 5$)
* **Smash:** $W=10, R=20, H=25$ (Advantage $F = 5$)

If $L=2$:
* **Jab** can combo into **Jab** ($3 \le 5$) or **Kick** ($6 \le 5$ is False). Wait, $6$ is not $\le 5$. So **Jab $\to$ Kick** is NOT a combo.
* In this specific set, because all moves have $F=5$, only moves with $W \le 5$ can follow any other move.

---

### Sample Input 1
```text
2 2
Jab 3 5 10
Kick 6 10 15
```

### Sample Output 1
```text
2
```
*(Explanation: The only valid combos of length 2 are "Jab $\to$ Jab" and "Kick $\to$ Jab". "Jab $\to$ Kick" and "Kick $\to$ Kick" fail because the Kick's windup (6) is greater than the advantage (5) provided by either move.)*

---

## Design Hint for the Solver
To solve this using **Dynamic Programming**:
1.  Represent the moves as an adjacency matrix (or list) where an edge exists from $M_i$ to $M_j$ if $W_j \le (H_i - R_i)$.
2.  Define $DP[i][j]$ as the number of combos of length $i$ that end with move $j$.
3.  The transition: $DP[i][j] = \sum DP[i-1][p]$ for all moves $p$ that can transition into move $j$.
4.  The base case: $DP[1][j] = 1$ for all $j$ (any single move is a combo of length 1).

How many moves and what combo length would you like to use for a more complex test case?
