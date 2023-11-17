\d .gametheorysk
//solves simultaneous eqns within .001
fsolve:{[x;f;m]
 .001*avg where f[m;x] within -.01 .01}[.001*til 1000]

//sets up silmultaneous eqns from 2x2 matrix
eq2by2m:{(((x[0;0])*y)+x[1;0]*1-y)-((x[0;1])*y)+x[1;1]*1-y}

//finds optimum mixed strategy (probability) for player x/y playing row/column 1
optmixA1:{[m]fsolve[eq2by2m]m}
optmixB1:{[m]fsolve[eq2by2m]neg flip m}

//value of game to A
valA:{[m]
 p:optmixA1 m;
 v:{[m;p]{((x[0;0])*y)+x[1;0]*1-y}[m;p]}[m;p];
 v}

//value of game to B
valB:{[m]
 p:optmixB1 m;
 v:{[m;p]{((x[0;0])*y)+x[1;0]*1-y}[m;p]}[neg flip m;p];
 v}
