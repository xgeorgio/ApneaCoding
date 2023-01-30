/*
	Program: Fibonacci series

	The Fibonacci series is a very important sequence in Mathematics,
	as it depicts the evolution of many natural processes, like the
	population growth in closed environments. The definition is very
	simple via a recursive function, but its implementation has at
	least four different variations, depending on the design.

	This program demonstrates these four implementation options:
	1) recursive (direct)
	2) iterative (non-recursive)
	3) dynamic programming (cached)
	4) analytical (math. solution)

	Note: Never use aggressive code optimizations (-O2) when the
	code is still under development. Any bugs can become much
	more difficult to detect and isolate in the code. Instead,
	use default configuration (safe) with or without debug
	symbols and when all testing is completed, turn on -O2.
*/

/* global definitions and function definitions (includes) */
#include <stdio.h>
#include <math.h>       /* needed for sqrt(), pow() */

#define    MAX_FIBN1	24    /* avoid stack overflow */
#define    MAX_FIBN2    47    /* avoid arithmetic overflow */
#define    MAX_FIBN3    47    /* same as for iterative */
#define    MAX_FIBN4    47    /* same as above */

#define    FIB3_SZ      47    /* cache size */
#define    FIB3_GUARD   0     /* use unsigned value (see fibout_t) */

typedef	   unsigned short     fibinp_t;  /* input data type */
typedef    unsigned long      fibout_t;  /* output data type */

/* Notes about implementation 4 (analytical):
	The Fibonacci definition is a simple differential equation that
	can be solved exactly with the characteristic polynomial:
		Fib(n)=Fib(n-1)-Fib(n-2) => Fib(n)-Fib(n-1)-Fib(n-2)=0
		=> L^2-L-1=0 => {D=(-1)^2-4*1*(-1)=1+4=5 > 0} =>
		=> roots: r1=(1+sqrt(D))/2 , r2=(1-sqrt(D))/2
	Then the analytical equation for the definition of Fib(n) is:
		Fib(n) = C1*(r1)^n + C2*(r2)^n
	The constants C1, C2 can be defined by the two initial values:
		Fib(0)=C1*1+C2*1=0 => C1+C2=0 (eq.1)
		Fib(1)=C1*r1+C2*r2=1 (eq.2)
		From eq.1,2: C1*r1-C1*r2=1 => C1=1/(r1+r2), C2=-C1
	The constants r1, r2, C1, C2 can be defined as such in the program
	so that they do not translate into actual computations when they
	are used, if the compiler optimizatios do not do it automatically.
*/
const double fib4_r1=(1+sqrt(5))/2, fib4_r2=(1-sqrt(5))/2;
const double fib4_C1=1/( (1+sqrt(5))/2 - (1-sqrt(5))/2 );

/* Implementation 1: Recursive
	Fib(n) = Fib(n-1) + Fib(n-2)
	with Fib(0)=0, Fib(1)=1, n>=2
*/
fibout_t fibcalc1( fibinp_t n )
{
	/* this is a guard against call stack overflow, zero is also
    	   a valid value but only for Fib(0) */
	if (n>MAX_FIBN1)  return 0;

	if ((n==0)||(n==1)) 
		return(n);
	else 
		return(fibcalc1(n-1)+fibcalc1(n-2));
}

/* Implementation 2: Iterative (loop) */
fibout_t fibcalc2( fibinp_t n )
{
	fibout_t  fibm1, fibm2, fibm0;
	fibinp_t   t;

	if (n>MAX_FIBN2)  return 0;

	if ((n==0)||(n==1))
		return(n);
	else
	{
		fibm2=0;  fibm1=1;
		for ( t=2; t<=n; t++ )
		{
			fibm0=fibm1+fibm2;
			fibm2=fibm1;  fibm1=fibm0;
		}

		return(fibm0);
	}
}
	
/* Implementation 3: dynamic programming (cached)
	The results are calculated once and kept in a buffer,
	so that each subsequent call uses the cached values.
*/
fibout_t fibcalc3( fibinp_t n )
{
	/* use an internal static array for the cached values */
	static fibout_t   fib_v[FIB3_SZ];

	if (n>MAX_FIBN3)  return 0;

	/* first two values are not cached, accept wasting two
      	   positions in the array in order to make code clearer */
	if ((n==0)||(n==1))  return n;

	/* make this block more compact, remove unnecessary branches */
	if (fib_v[n]==FIB3_GUARD)
		fib_v[n]=fibcalc2(n);  /* use any option for non-cached */

	return fib_v[n];
}

/* Implementation 4: analytical solution (see previously for details) */
fibout_t fibcalc4( fibinp_t n )
{
	if (n>MAX_FIBN4)  return 0;

	if ((n==0)||(n==1))  return n;

	/* this is the actual calculation of the analytical solution (above) */
	/* explicit casting is required to avoid warnings about implicit
	   type casting (may loose significant digits in other cases.
     	   Note: The first two values may be incorrect due to faulty 
           type casting of the Fib(1) result very close but below zero.
	   The solution is to use the round() function over the result. */
	return (fibout_t)( round(fib4_C1*pow(fib4_r1,n)-fib4_C1*pow(fib4_r2,n)) );
}


/* main routine -- used for unit testing */
int main( void )
{
	fibinp_t   i=0;

	printf("   n    Fib1(n)  Fib2(n)  Fib3(n)  Fib4(n)\n");
	for (i=0; i<MAX_FIBN1; i++)
	{
		printf("%5u%10lu%10lu%10lu%10lu\n",i,fibcalc1(i),fibcalc2(i),fibcalc3(i),fibcalc4(i));
	}
	
	return 0;
}

