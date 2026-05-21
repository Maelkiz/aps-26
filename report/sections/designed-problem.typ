= Designed Problem

Provide a self-contained problem that can be used for automated judging. Make sure `verifyproblem` accepts your files.

== Problem description

Give the problem statement as you would present it to contestants. Include input and output formats, constraints, and examples.

== Intended solution

Describe the algorithmic idea behind an intended (accepted) solution. Use pseudocode and a short complexity analysis (time and memory). Example:

```text
function solve(input):
  parse input
  // algorithmic steps
  return output
```

 - *Time complexity:* O(...)
 - *Memory:* O(...)

== Test-case design

Explain how you generated sample and secret inputs. For each test group, state the purpose, parameter ranges, and expected corner cases.

- *Sample tests:* small cases for manual checking.
- *Secret tests:* randomized and worst-case instances to exercise complexity.

== Accepted and wrong solutions

Include at least one accepted solution and one or more wrong/inefficient variants. For each wrong solution, explain why it fails (e.g., incorrect logic, TLE, memory).

== Input validation & formatting

Specify how your judge should treat malformed input and which assumptions contestants may rely on.

== Verify notes

Confirm that `verifyproblem` runs cleanly. If it produced warnings, document them and the fixes applied.

== Testing and Validation

- Describe your testing strategy
- Provide commands to reproduce tests.

Example commands:

== Source for Designed Problem

Provide a compact description of the repository layout and how to run the judge and tests locally.

- *Files to include in zip:* problem statement, solutions, test generator(s), verifyproblem configuration, README.
- *Run locally:* provide exact commands used to generate and run tests.
