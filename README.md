# Sudoku Solver

A sudoku solver written in assembly x86.

It takes the file `sudoku.txt` as input where we have a sudoku puzzle represented with 0's instead of blank spaces and uses a backtracking algorithm 
to solve it, generating a file with the solution.

To run the program use the following commands (you will need gcc-multilib installed):

```bash
as --32 sudoku-solver.asm -o sudoku-solver.o
gcc -m32 sudoku-solver.o -o sudoku-solver
./sudoku-solver
```

