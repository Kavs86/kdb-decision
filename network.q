\d .networksk

//kx functions--------------------------------------------------------------------------------------------------
//cm and bridge were taken from kx`s article on linear programming

//generate distance matrix from args:nodes;distance table;`zero or `inf if no direct path
cm:{[n;d;nopath]                                       
 nn:count n;                                             
 res:(2#nn)#(0 0Wf)`zero`inf?nopath;
 ip:flip n?/:d`src`dst;
 res:./[res;ip;:;`float$d`dist];
 ./[res;til[nn],'til[nn];:;0f]
 }

//minimum sum inner product. Minimises distances between nodes
bridge:{x & x('[min;+])\: x}  

//utility functions--------------------------------------------------------------------------------------------                       

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

//generate distance matrix from csv of a-b-num,a-c-num\nb-c-num\n etc
mfd:{d:tfd x;
 n:distinct d`src;
 m:cm[n;d;`inf];
 m}       

//generate nodes and matrix from csv of from a-b-num,a-c-num etc
nmfd:{d:tfd x;
 n:distinct d`src;
 m:cm[n;d;`inf];
 (n;m)}  

//main functions-----------------------------------------------------------------------------------------------------

//Euclidean distance between each coordinate. Returns a square matrix.
edistm:{{{sqrt x wsum x}each x -\: y}[x]each x}      //args:coords 


//minimum spanning tree
mst:{[m;x;y;v]                                       //arg:distance matrix
 m:@[m;last x;:;(c:count m)#0Wf];
 x:x,(i:first where r=w:min r:raze{[m;x]m[;x]}[m]each x)mod c;  //dst
 y:y,x i div c;                                                 //src
 v:v,w;
 $[0W>last v;.z.s[m;x;y;v];:-1_/: 1_/:(y,'x;v)]                 //src-dst-dist
 }[;0;0;0]

arc:{[n;mst](n mst 0),'mst 1}

weight:{raze(x;sum x[;2])}

nw:{[n;m]weight arc[n] mst m}

//network from distances csv
nwfd:{nw . nmfd x}

//connect unconnected nodes and minimize distances
connectn:{[n;m]                                                             //nodes and original unconnected matrix
 d:([]src:raze count[n]#/:n;dst:raze flip count[n]#/:n;dist:raze m);        
 d:delete from d where dist=0;
 d:delete from d where dist=0w;
 m:(bridge/)cm[n;d;`inf];
 m}

//connect nodes from distances csv
//connect unconnected nodes and minimize distances from csv of form a-b-num,a-c-num etc
connectnfd:{connectn . nmfd x}

//route inspection for four or less odd nodes
ri:{[n;m]                                                                  // Args:nodes and unconnected matrix
 d:([]src:raze count[n]#/:n;dst:raze flip count[n]#/:n;dist:raze m); 
 d:delete from d where dist=0;
 d:delete from d where dist=0w;
 m:(bridge/)cm[n;d;`inf];
 d1:([]src:raze nx;dst:raze flip nx:count[n]#'n;dist:raze m);
 d1:select from d1 where dist >0;
 x:d1(d1[`src],'d1[`dst])?/:
 0N 2#{raze distinct each ((x 0)cross 1_x),\:x}
 where 1=(count each group d`src)mod 2;                                         //perms of odd indices
 d2:raze y where x=min x:{sum x`dist}each y:(0N 2#x);                           //min sums of these arcs
 (`repeated_arcs,d2;`total_weight,sum d2[`dist],.5*d`dist)                      //format return
 }

//route inspection from distances csv of form a-b-num,a-c-num etc
rifd:{ri . nmfd x}



