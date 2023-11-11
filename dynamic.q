//utility functions--------------------------------------------------------------------------------------------------

//generate distance matrix from upper-right of matrix with lines separated by semi-colon
//No path = 0w 
genm1:{x:(0,'x),0;
 x+flip x:((-1+reverse count each x)#\:0),'x         //arg:semi-colon-separated upper right of matrix
 }

//generate distance matrix from upper-right of matrix as a single vector of numbers.
//No path = 0w
genm:{x+flip x:((1+til n+1)#\:0),'
 (sums 0,1+reverse til n:floor sqrt 2*count x)cut x  //arg:upper right of matrix
 }

//generate distance table with columns src,dst,dist
//Argument is csv of form a-b-num,a-c-num\nb-c-num\n etc
tfd:{t:flip `src`dst`dist!flip{(`$x 0),(`$x 1),"F"$2_ x}each "-" vs/: raze ","vs/: "\n" vs x;
 t:t,select src:dst,dst:src,dist:dist from t}         //tab from dist csv

//generate distance matrix
//Argument is csv of form a-b-num,a-c-num\nb-c-num\n etc
mfd:{d:tfd x;n:distinct d`src;m:cm[n;d;`inf]}         //matrix from dist csv


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

//permscn takes coin denominations as arg1
permscn:{[c;n]
 c:1_c
 a:(n+1)#1;
 b:2#a;
 last first(((til count c)!c) bin n) {f . x}/ f[a;b;c]
 }
//-------------------------------------------------------------------------------------------------------------------

// minpt,maxpt - finds the min sum/max sum path through a triangle 

minpt:{{(1_ 2 mmin x)+y}/[reverse x]}
maxpt:{{(1_ 2 mmax x)+y}/[reverse x]}
