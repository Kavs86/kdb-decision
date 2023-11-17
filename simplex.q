\d .simplex

//simplex algorithm takes a matrix (initial tableau) and the basic variable indices (as a vector of integers) as arguments.
//returns tableau after one pass and updated basic variable indices.
//optsim applies simplex until convergence 
//eg. simplex[m;3 4] - state after one pass 
//eg. optsim[m;3 4] - state after final pass

simplex:{[m;bv]
         pci:first where l=min l:last m;                                                        //pivot column idx
         pri:first where pri=min {?[0>x;0w;x]}pri:{[pci;x](last x)% x pci}[pci]each neg[1]_ m;  //pivot row idx
         pv:m[pri;pci];                                                                         //pivot
         m:@[m;pri;%;pv];                                                                       //make pivot row  
         npr:m@npri:where not pri=til count[m];                                                 //non-pivot rows
         pr:m@pri;                                                                              //pivot row
         npr:{[pci;pr;npr]npr-(npr pci)*(pr)}[pci;pr]each npr;                                  //eliminate variable from npr
         (m:@[m;npri;:;npr];@[bv;pri;:;pci])                                                    //return m,bv
   }

optsim:{({simplex . x}/) simplex[x;y]}
   
//summarise the results of the final tableau
//eg. summarysim[`x`y`z`r`s] optsim[m;3 4]

summarysim:{[v;x]                                                                               //arg1:variable symbols,arg2:result of simplex algo
         ((enlist[`optimal_solution]!enlist last last first x),
         d:(v first 1_x)!(-1_ last each first x))
   }
