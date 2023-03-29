
// Roots and exponentials of any order

#include <stdio.h>
#include <math.h>

// iterative exponential to integer power (no logarithms)
double raisek( double n, int k )
{
	int ssign=-(k<0);    // quick hack for sign()
	double x=1.0;
	
	//printf("raisek(): %g^%d =",n,k);
	k=abs(k);     // convert to positive for proper iterations
	while (k>0)  
	{ x *= n;  k--; }
	if (ssign<0)  x=1/x;   // adjust if negative power
	//printf("%g\n",x);

	return x;
}


// declare as global constants to avoid long parameter list (below)
const double h=1e-6, eps=1e-6;
const int    maxiter=1000;
// iterative root of integer power (no logarithms)
double rootk( double a, int k )
{
	int ssign=-(k<0);    // quick hack for sign()
	double	xn, xn1;
	int   	iter=1;
	
	k=abs(k);    // convert to positive for proper iterations
	xn=a/k;
	xn1=a;
	while ((fabs(xn1-xn)>eps)&&(iter<=maxiter))
	{
		// update current position
		xn = xn1;
		// Newton-Raphson iteration step, using derivative approximation
		xn1 = xn - 2*h*(raisek(xn,k) - a)/(raisek(xn+h,k) - raisek(xn-h,k));
		printf("\titer %d: x=%.6f\n",iter,xn);
		iter++;
	}
	if (ssign<0)  xn=1/xn;   // adjust if negative power

	return xn;
}


// ..... main routine used for unit testing .....

int main()
{
  double	num=64;    // should be large enough to hold: num^(rt)
  int   	rt=6;       // only integer-power roots are supported
  
  printf("Estimating: %g^(1/%d)  {h=%g, eps=%g, maxiter=%d}\n",num,rt,h,eps,maxiter);  
  printf("Result: %g\n",rootk(num,rt));
  
  return 0;
}
