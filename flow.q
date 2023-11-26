//utility functions
//find all possible routes through a directed network
routes:{[s;sd]                                                        //args:source,sources and destinations 
 r:raze{$[(l:last x) in y[;0];
 raze .z.s[;y] each x,/: y where l = y[;0];
 x]}[;sd]each sd where s in/: sd;
 0N 2#/:(where `s=r)cut r}

//updates table to increase capacity of network
updroutes:{$[0=count y;                                               //args:keyedtab,routes
 x;
 .z.s[@[x;first y;+;]neg[v],v:min(x first y)`for;1_ y]]
 }       

//nodes from keyed table
nfkt:{flip value flip key x}  
//------------------------------------------------------------------------------------------------------------------

//initial augmented flow routes table
augflowinit:{[s;t]
 t:2!t;
 t:updroutes[t]routes[`s] nfkt t;
 t}     

//updated augmented flow routes table
//passed two further arguments - nodes based on inspection of initial table
augflow:{[s;t;n1;n2]
 t:t upsert 2!select src:dst,dst:src,for:back,back:for from t where src=n1,dst=n2;
 t:select from t where (not src=n1) or (not dst=n2);
 t1:delete from t where for=0;
 t:updroutes[t] r where c=max c:count each r:routes[`s]nfkt t1}
