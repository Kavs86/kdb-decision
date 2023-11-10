//utility functions--------------------------------------------------------------------------------------------------

genm1:{x:(0,'x),0;
 x+flip x:((-1+reverse count each x)#\:0),'x         //arg:semi-colon-separated upper right of matrix
 }

genm:{x+flip x:((1+til n+1)#\:0),'
 (sums 0,1+reverse til n:floor sqrt 2*count x)cut x  //arg:upper right of matrix
 }

//generate distance table with columns src,dst,dist
//Argument is csv of form a-b-num,a-c-num\nb-c-num\n etc
tfd:{t:flip `src`dst`dist!flip{(`$x 0),(`$x 1),"F"$2_ x}each "-" vs/: raze ","vs/: "\n" vs x;
 t:t,select src:dst,dst:src,dist:dist from t}         //tab from dist csv

mfd:{d:tfd x;n:distinct d`src;m:cm[n;d;`inf]}         //matrix from dist csv

//main functions-----------------------------------------------------------------------------------------------------

edistm:{{{sqrt x wsum x}each x -\: y}[x]each x}      //args:coords. Finds euclidean distance between each coordinate, hence returns a square matrix.

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

cm:{[n;d;nopath]                                      //generate distance matrix from args:nodes;distance table;`zero or `inf if no direct path 
 nn:count n;                                          //this function and bridge were taken from kx`s article on linear programming   
 res:(2#nn)#(0 0Wf)`zero`inf?nopath;
 ip:flip n?/:d`src`dst;
 res:./[res;ip;:;`float$d`dist];
 ./[res;til[nn],'til[nn];:;0f]
 }

bridge:{x & x('[min;+])\: x}                          //minimum sum inner product. Essentially Dijkstra's algorithm. Minimises distances between nodes

connectn:{[n;m]                                                             //nodes and original unconnected matrix
 d:([]src:raze count[n]#/:n;dst:raze flip count[n]#/:n;dist:raze m);        //connects unconnected nodes and minimizes distances
 d:delete from d where dist=0;
 d:delete from d where dist=0w;
 m:(bridge/)cm[n;d;`inf];
 m}

ri:{[n;m]                                            //route inspection for four or less odd nodes. Args:nodes and unconnected matrix
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

