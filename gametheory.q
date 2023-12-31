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

//probability and value of playing row/column 1 
probval:{[m]
 m:flip m;
 f:{p:.0001*avg where((((y 0)*x)+(y 1)*1-x)-(((z 0)*x)+(z 1)*1-x))within -.001 .001;
 v:((y 0)*p)+(y 1)*1-p;(p;v)}[.0001*til 10000]'[m];
 r:f[1 rotate m];
 r:r,f[2 rotate m];
 i:last where -1=signum{(x 1)%x 0}each deltas r:distinct asc .001*`int$1000*r;
 `prob_play_1`value!r i}
