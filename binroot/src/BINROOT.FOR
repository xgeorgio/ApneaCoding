
      PROGRAM BINROOT

*     This program implements the dichotomy algorithm
*     for calculating the root f(x)=0 of a monotonically
*     increasing or decreasing function. Input values are 
*     the starting range [A,B], the maximum number of 
*     iterations cycles M and the precision DELTA.

      
      DOUBLE PRECISION A0, B0, A, B, D, DELTA, FD, FA, FB
      INTEGER M, K, ERR

*     Variables initialization
      ERR=0

*     Note: User input with READ() may require Ctrl+Enter, not just Enter
*           due to incorrect I/O read of <Enter> as only <LF> (as in Unix)
      WRITE(*,*)'FUNCTION ROOT FINDING BY DICHOTOMY ALGORITHM'
      WRITE(*,*)'--------------------------------------------'
      WRITE(*,*)' '
      WRITE(*,*)'Give staring range [A,B]:'
      WRITE(*,*)'        A := '
      READ(*,*) A0
      WRITE(*,*)'        B := '
      READ(*,*) B0
      WRITE(*,*)'Give max number of cycles (M):'
      WRITE(*,*)'        M := '
      READ(*,*) M
      WRITE(*,*)'Give DELTA parameter:'
      WRITE(*,*)'        DELTA := '
      READ(*,*) DELTA
      WRITE(*,*)' '

*     Check parameters for validation      
      IF ( B0 .LT. A0 ) THEN
         ERR=-1
         WRITE(*,*)'Error: Invalid field [A,B] specified.'
         GOTO 99
      ENDIF
      IF ( DELTA .LE. 0.0 ) THEN
         ERR=-2
         WRITE(*,*)'Error: DELTA must be a small positive real.'
         GOTO 99
      ENDIF
      IF ( M .LT. 1.0 ) THEN
         ERR=-3
         WRITE(*,*)'Error: M must me an integer >= 1'
         GOTO 99
      ENDIF

*     Start searching/minimizing process
      WRITE(*,*)'Reducing range [A,B]...'
      
      K=0
      A=A0
      B=B0
      FA=FX(A)
      FB=FX(B)

      D=(B+A)/2
      FD=FX(D)
      
*     Check 1: Function still has a root in current [A,B]      
60    IF ( FA*FB .GT. 0) THEN
         ERR=-4
         WRITE(*,*)'Error: Function does not change sign in [A,B]'
         GOTO 99
      ENDIF

*     Check 2: Convergence range is still larger than requested      
      IF (ABS(B-A) .LE. DELTA) GOTO 80
      
*     Check 3: Maximum number of iterations not reached yet
      IF (K .GT. M) GOTO 80

      K=K+1

*     Check 4: Sign change of function within current [A,B]
      IF ( FA*FD .GT. 0.0 ) THEN
*        case: shrink from lower bound
         A=D
         FA=FD
      ELSE
*        case: shrink from upper bound
	 B=D
         FB=FD
      ENDIF

*     evaluate FX(.) only once again, for new D
      D=(B+A)/2
      FD=FX(D)

70    FORMAT(I5,' :  [ ',F10.5,' , (',F10.5,') , ',F10.5,' ]')
      WRITE(*,70) K, A, D, B

      GOTO 60

*     Show process results
80    WRITE(*,*)'Process completed.'
      WRITE(*,*)' '
      WRITE(*,95) D, ABS(B-A)/2
95    FORMAT(' The final minimum in [A,B] is:  ',F10.5,' ( ',F10.5,' )')
      WRITE(*,*)
99    STOP
      END

*     Function-to-Use (user-defined as required)
      FUNCTION FX( X )
      DOUBLE PRECISION X

*     Note: Function must be monotonically incr/decr in [A,B]      
*     Test: Use a trivial FX(.) to validate solver, as in here:
*           FX(X)=0 => 2X-40=0 => X=20 (exact root)
      FX=2*(X-20)

      RETURN
      END


