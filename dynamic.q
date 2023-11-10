//utility functions

//gentri generates a triangle from a vector of numbers
gentri:{(sums til floor sqrt 2*count x)_ x}           

//----------------------------------------------------------------------------------------------------------------
//f - Dynamic function to generate a list for any denomination.
//Args are previous list, the beginning of this list (known), and coin denominations (2 5 10 ...)

f:{$[(count x)>count y;
 .z.s[x;y,x[count y]+y[neg[first z]+count y];z];
 (y;first[1_z,2000]#y;1_z)]
 }

//perms - Finds the number of permutations for any given value (in pence)
//recurses on f as many times as needed

perms:{[n]
 c:2 5 10 20 50 100 200;
 a:(n+1)#1;
 b:2#a;
 last first(((til count c)!c) bin n) {f . x}/ f[a;b;c]
 }

// minpt,maxpt - finds the min sum/max sum path through a triangle 

minpt:{{(1_ 2 mmin x)+y}/[reverse x]}
maxpt:{{(1_ 2 mmax x)+y}/[reverse x]}
