# kdb-decision
My kdb implementation of algorithms used to solve mathematical and programming problems 

1) Simplex example:
   Maximise P=10x+12y+8x subject to 2x+2y<=5,  5x+3y+4z<=15,  x,y,z>=0
   Use slack variables r and s which can have index 3 and 4 respectively.
   m:0N 6# 2 2 0 1 0 5 5 3 4 0 1 15 -10 -12 -8 0 0 0;
   summarysim[`x`y`z`r`s] (simplex/)[m;3 4]
