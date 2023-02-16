C
C  Estimation of the machine's FP 'epsilon', that is
C  the number of significant decimal digits, for the
C  two FP data types available in Fortran.
C

      PROGRAM EPSILON

      INTEGER D1, D2
      REAL EPS1, EPS1T
      DOUBLE PRECISION EPS2, EPS2T

      WRITE(*,*) 'EPS calculation for this machine'
      WRITE(*,*) ' '

C  Iteration 1: Estimation for REAL type
      EPS1=1.
 10   EPS1=0.5*EPS1
      EPS1T=EPS1+1.
      IF (EPS1T .GT. 1.) GO TO 10
      D1=INT(-LOG10(EPS1))
 15   FORMAT(' Type REAL: ',I2,' FP digits')
      WRITE(*,15) D1
      WRITE(*,*) EPS1

C  Iteration 2: Estimation for DOUBLE PRECISION type
      EPS2=1.
 20   EPS2=0.5*EPS2
      EPS2T=EPS2+1.
      IF (EPS2T .GT. 1.) GO TO 20
      D2=INT(-DLOG10(EPS2))
 25   FORMAT(' Type DOUBLE PRECISION: ',I2,' FP digits')
      WRITE(*,25) D2
      WRITE(*,*) EPS2

      WRITE(*,*) ' '
      STOP
      END
