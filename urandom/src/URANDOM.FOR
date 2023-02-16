C
C   Pseudo-random number generator by using the classic
C   Mixed-Congruential Sequence (linear) method, as it
C   was described by D. Knuth (1972) regarding proper
C   parameter choices for high-entropy output.
C
C   The general rules for parameter choice are:
C   1) M (modulo) must be at most half the available
C      bits width of the integer type used.
C   2) C (increment) should be chosen close to the
C      value: M * (1/2 - sqrt(3)/6) = 0.2113248654051871...
C      For example: M=2^8 => C=54 (54.09916...)
C   3) A (multiplier) should be chosen as to satisfy the
C      following three requirements:
C        A mod 8 = 5
C        M/100 < A < M-sqrt(M)
C        A must not have trivial bit pattern value
C   Then these three values, along with a user-provided
C   seed value X0, can be used iteratively with (n>=0):
C      X(n+1) = (A * X(n) + C) mod M  , X(0)=X0
C   Provided that all constraints are satisfied, there
C   are various 'good' choices for the triplet (A,C,M)
C   and any one of them should provide a random sequence
C   with a period of M before repeating. High-quality 
C   PRNG functions are crucial in simulation experiments.
C

      PROGRAM URANDOM

      INTEGER IY, N, SEED, RND

C   Change seed X0 and number of repetitions as needed.
      DATA SEED/0/, N/15/

      WRITE(*,*) 'PRNG via Mixed Congruential Sequence'
      WRITE(*,*)

C   Main loop for generating N random integers
      IY=SEED
      DO 10 I=1,N
C   Note: Input parameter is changed with each call
        RND=URAND(IY)
 5      FORMAT('PRNG next: ',I5)
        WRITE(*,5) RND
 10   CONTINUE

      STOP
      END


C   URAND function is the core PRNG as described above.
C   Note: Older compilers keep returning arithmetic
C   overflows even when intermediate calculations are 
C   made via REAL and IFIX or INT/NINT. Thus, the BITS
C   internal parameter should be set no larger than
C   half the available bits width for the integer type
C   used for A, C, M. Larger values may return correct 
C   results, but this is not guaranteed.
C   For faster output, the parameters can be fixed to 
C   pre-initialized well-performing set of values.

      INTEGER FUNCTION URAND( IY )

      INTEGER IY, IA, IC, IM, ST, BITS

      DATA BITS/15/

C   Check for previous initialization
      IF (ST .NE. 0) GO TO 70

C   Set the initialization flag (ST), M and C values
      WRITE(*,*) 'PRNG initializing...'
      ST=1
      IM=2**BITS
      IC=IFIX(IM*(0.5-SQRT(3.0)/6.0))

C   Estimate best A as the largest valid value against
C   the upper bound that is also divisible by 5
      IA=IM-SQRT(FLOAT(IM))
 10   IA=IA-1
      IF (MOD(IA,8) .NE. 5) GO TO 10

C   Initialization finished, display the configuration
      WRITE(*,*) 'PRNG configuration:'
 20   FORMAT(' bits=',I2,' , A=',I5,' , C=',I5,' , M=',I5)
      WRITE(*,20) BITS,IA,IC,IM

C   Main iteration formula with the selected parameters
 70   IY=MOD( IY*IA+IC , IM )

      URAND=IY
      RETURN
      END
