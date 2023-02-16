Title:<br/>
<b>URANDOM: Pseudo-random number generator in Fortran</b>

Description:<br/>
<p>This program implements a pseudo-random number generator (PRNG) by using the classic Mixed-Congruential Sequence (linear) method, as it was described by D. Knuth (1972) regarding proper parameter choices for high-entropy output.

The general rules for parameter choice are:
<ul>
<li>1) M (modulo) must be at most half the available bits width of the integer type used.</li>
<li>2) C (increment) should be chosen close to the value: M * (1/2 - sqrt(3)/6) = 0.2113248654051871... For example: M=2^8 => C=54 (54.09916...)</li>
<li>3) A (multiplier) should be chosen as to satisfy the following three requirements: A mod 8 = 5 , M/100 < A < M-sqrt(M) , A must not have trivial bit pattern value.</li>

Then these three values, along with a user-provided seed value X0, can be used iteratively with (n>=0):<br/>
X(n+1) = (A * X(n) + C) mod M  , X(0)=X0<br />

Provided that all constraints are satisfied, there are various 'good' choices for the triplet (A,C,M) and any one of them should provide a random sequence with a period of M before repeating. High-quality PRNG functions are crucial in simulation experiments.

Note: Older compilers keep returning arithmetic overflows even when intermediate calculations are made via REAL and IFIX or INT/NINT. Thus, the BITS internal parameter should be set no larger than half the available bits width for the integer type used for A, C, M. Larger values may return correct results, but this is not guaranteed. For faster output, the parameters can be fixed to pre-initialized well-performing set of values.

Warning: In some older versions of Microsoft's Fortran 77, the batch process 'FORT.BAT' assumed that the input filename is given as argument *without* the '.FOR' extension. If it is given, then the output is unpredictable and usually results in a corrupted *original* (source) file! Make sure to always keep backup before compiling - I had to write the source code twice because of this.
