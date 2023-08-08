
      PROGRAM LINSOLVE

      INTEGER NDIM, ERR
      DOUBLE PRECISION A(3,3), B(3), X(3)

      DATA NDIM /2/
C     ... NOTE: DATA ARE FILLED COLUMN-WISE ...
C     ... TEST SET 1: TRIVIAL SOLUTION X(I)=B(I) ...
C      DATA A /1.0,0.0,0.0, 0.0,1.0,0.0, 0.0,0.0,1.0/
C      DATA B /1.0,2.0,3.0/
C     ... TEST SET 2: FULLY DETERMINED 3x3 SYSTEM ...
      DATA A /3.0,5.0,-2.0, -2.0,2.0,3.0, 4.0,-9.0,3.0/
      DATA B /7.0,-5.0,1.0/
C     ... INITIALIZE SOLUTION VECTOR ...
      DATA X /0.0,0.0,0.0/


C     ... DISPLAY CURRENT LINEAR SYSTEM TO SOLVE ...
      WRITE(*,*) 'TEST LINEAR 3x3 SYSTEM:'
   5  FORMAT(1X,F7.3,'*X +',F7.3,'*Y +',F7.3,'*Z =',F7.3)
      WRITE(*,5) A(1,1), A(1,2), A(1,3), B(1)
      WRITE(*,5) A(2,1), A(2,2), A(2,3), B(2)
      WRITE(*,5) A(3,1), A(3,2), A(3,3), B(3)

C     ... SOLVE THE 2x2 SUB-SYSTEM (TOP-LEFT) ...
      ERR = SOLVE2(A,B,X)      
  10  FORMAT(1X,'SOLUTION (CODE=',I1,') :  X = ',F10.6,' , Y = ',F10.6)
      WRITE(*,10) ERR, X(1), X(2)

C     ... SOLVE THE 3x3 SYSTEM (FULL) ...
      ERR = SOLVE3(A,B,X)
  15  FORMAT(1X,'SOLUTION (CODE=',I1,') :  X = ',F10.6,' , Y = '
     *,F10.6,' , Z = ',F10.6)
      WRITE(*,15) ERR, X(1), X(2), X(3)

      STOP
      END

C     ... DETERMINANT-BASED 2x2 LINEAR SYSTEM SOLVER ...
      FUNCTION SOLVE2( A, B, X )

      DOUBLE PRECISION A(3,3), B(3), X(3), DA
      INTEGER RES

C     ... CHECK THE SYSTEM'S CONDITION ...
      DA = A(1,1)*A(2,2) - A(2,1)*A(1,2)
      IF (DA .EQ. 0.0) GOTO 82
C     ... SYSTEM IS FULL RANK, CALCULATE SOLUTIONS ...
  80  X(1) = ( B(1)*A(2,2) - B(2)*A(1,2) ) / DA
      X(2) = ( A(1,1)*B(2) - A(2,1)*B(1) ) / DA
      RES = 0
      GOTO 85
C     ... SYSTEM IS ILL-DEFINED, REPORT ERROR ...
  82  RES = 1

  85  SOLVE2 = RES

      RETURN
      END


C     ... DETERMINANT-BASED 3x3 LINEAR SYSTEM SOLVER ...
      FUNCTION SOLVE3( A, B, X )
  
      DOUBLE PRECISION A(3,3), B(3), X(3), DA, DX

C     ... CHECK THE SYSTEM'S CONDITION ...
      DA = A(1,1)*( A(2,2)*A(3,3) - A(3,2)*A(2,3) )
      DA = DA - A(1,2)*( A(2,1)*A(3,3) - A(3,1)*A(2,3) )
      DA = DA + A(1,3)*( A(2,1)*A(3,2) - A(3,1)*A(2,2) )

      IF (DA .EQ. 0.0) GOTO 92

C     ... SYSTEM IS FULL-RANK, CALCULATE SOLUTIONS ...
  90  DX = B(1)*( A(2,2)*A(3,3) - A(3,2)*A(2,3) )
      DX = DX - A(1,2)*( B(2)*A(3,3) - B(3)*A(2,3) )
      DX = DX + A(1,3)*( B(2)*A(3,2) - B(3)*A(2,2) )
      X(1) = DX / DA

      DX = A(1,1)*( B(2)*A(3,3) - B(3)*A(2,3) )
      DX = DX - B(1)*( A(2,1)*A(3,3) - A(3,1)*A(2,3) )
      DX = DX + A(1,3)*( A(2,1)*B(3) - A(3,1)*B(2) )
      X(2) = DX / DA

      DX = A(1,1)*( A(2,2)*B(3) - A(3,2)*B(2) )
      DX = DX - A(1,2)*( A(2,1)*B(3) - A(3,1)*B(2) )
      DX = DX + B(1)*( A(2,1)*A(3,2) - A(3,1)*A(2,2) )
      X(3) = DX / DA

      RES = 0
      GOTO 95

C     ... SYSTEM IS ILL-CONDITIONED, REPORT ERROR ...
  92  RES = 1

  95  SOLVE3 = RES

      RETURN
      END
