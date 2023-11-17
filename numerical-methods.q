\d .numericalsk

//utility function
//converts initial x (x0), final x (x1), initial y (y0), step length (h) into an argument list. 
//Used within emfxxyh

xxyh:{[x0;xl;y0;h](enlist[y0],x0 + h*til "i"$(xl-x0)%h;h)}
//-------------------------------------------------------------------------------------------------------------------
//Euler's method used to estimate the value of the particular solution of a first order 
//differential equation (f) at a certain point (x1) given the initial conditions (x0,y0) and step length (h)
//Intermediate values also given. If you want only the last value use "over" instead of "scan"
//Format is em.fxxyh[func] . x0 x1 y0 h

emfxxyh:{[f;x0;x1;y0;h]
 {[f;x]f[x 1]scan x 0}[f]xxyh[x0;x1;y0;h]
 }
//-------------------------------------------------------------------------------------------------------------------
//subject differential equations are defined as d
//augmented to include the fact they will have to return the next y-value

f1:{[h;y;x]
 d:(y+x*x)%(neg[x]+y*y);
 y:y+h*d;
 y}

f2:{[h;y;x]
 d:(x*x)+y*y;
 y:y+h*d;
 y}

f3:{[h;y;x]
 d:sqrt exp[x] + 2*exp y;
 y:y+h*d;
 y}

f4:{[h;v;t]
 d:(v-t)%(t*v-t*t);
 v:v+h*d
 v}

f5:{[h;theta;t]
 d:sqrt 9.8*-1+2*cos theta;
 theta:theta+h*d;
 theta}
