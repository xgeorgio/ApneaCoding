C
C     TRAJECTORY SOURCE FINDER
C
      PROGRAM TRAJ

      DOUBLE PRECISION X(5), Y(5), DY(5), XX, YY, H, PREC
      INTEGER NDATA, ITER, I
C
C     DEFINE SOME TEST DATA WITH F(X)=-X*(X-5) AND DF(X)=-2X+5
C
      DATA NDATA/5/
      DATA X /0.0, 1.0, 2.0, 3.0, 4.0/
      DATA Y /0.0, 4.0, 6.0, 6.0, 4.0/
      DATA DY/5.0, 3.0, 1.0, -1.0, -3.0/
      DATA H/0.001/, PREC/0.001/, ITER/100/
      DATA XX/1.5/

C     
C     EXAMPLE OF ANSI-CODE SCREEN HANDLING (CLEAR)
C
      WRITE(*,*) CHAR(27),'[2J'

C
C     MAIN ROUTINE: EXAMPLE PARABOLIC TRAJECTORY
C
      WRITE(*,*) 'TRAJECTORY SOURCE FINDER'
      WRITE(*,*) 'Example:  f(x)=-x(x-5) => df/dx=-2x+5'
      WRITE(*,*) 'Input data (X,Y,DY):'
      DO 10 I=1,NDATA
   5  FORMAT(1X,'POINT ',I2,': (',F5.2,' ,',F5.2,' ,',F5.2,')') 
  10  WRITE(*,5) I, X(I), Y(I), DY(I)

C
C     TESTING INTERPOLATION AND DERIVATIVE ROUTINES
C
      WRITE(*,*) 'TEST AT POINT: ',XX
      YY = HERMPOLY3(XX,X(2),Y(2),DY(2),X(3),Y(3),DY(3))
      WRITE(*,*) 'INTERPOLATED: ', YY
      YY = HPOLY3D1(XX,H,X(2),Y(2),DY(2),X(3),Y(3),DY(3))
      WRITE(*,*) 'DERIVATIVE: ', YY

C
C     MAIN TRAJECTORY ANALYSIS FOR SOURCE FINDING
C
      I = 2
      WRITE(*,*) 'FINDING SOURCE FROM DATA POINTS:'
      WRITE(*,*) I, I+1
      XX = FINDROOT(X(I),Y(I),DY(I),X(I+1),Y(I+1),DY(I+1),H,PREC,ITER)
      WRITE(*,*) 'ROOT: X = ', XX

      STOP
      END

C ----------------------------------------------------------
C
C     HERMITE INTERPOLATION POLYNOMIAL OF ORDER 3
C
      FUNCTION HERMPOLY3( X, X0, Y0, DY0, X1, Y1, DY1 )

      DOUBLE PRECISION X, X0, Y0, DY0, X1, Y1, DY1, H00, H01, H10, H11

      H00 = (1 - 2*(X-X0)/(X0-X1)) * ((X-X1)**2 / (X0-X1)**2)
      H01 = (1 - 2*(X-X1)/(X1-X0)) * ((X-X0)**2 / (X1-X0)**2)
      H10 = (X-X0) * (X-X1)**2 / (X0-X1)**2
      H11 = (X-X1) * (X-X0)**2 / (X1-X0)**2

      HERMPOLY3 = Y0*H00 + Y1*H01 + DY0*H10 + DY1*H11

      END

C ----------------------------------------------------------
C
C     HERMITE POLYNOMIAL DERIVATIVE OF ORDER 1
C
      FUNCTION HPOLY3D1( X, H, X0, Y0, DY0, X1, Y1, DY1 )

      DOUBLE PRECISION X, H, X0, Y0, DY0, X1, Y1, DY1, P0, P1

      P1 = HERMPOLY3(X+H,X0,Y0,DY0,X1,Y1,DY1)
      P0 = HERMPOLY3(X-H,X0,Y0,DY0,X1,Y1,DY1)

      HPOLY3D1 = (P1-P0) / (2*H)

      END

C ----------------------------------------------------------
C
C     ROOT FINDING WITH NEWTON-RAPHSON METHOD
C
      FUNCTION FINDROOT( X0, Y0, DY0, X1, Y1, DY1, H, PREC, ITER )

      DOUBLE PRECISION X0, Y0, DY0, X1, Y1, DY1, H, PREC, XX, XX1, P0, P1
      INTEGER ITER, I

      I = 0
      XX = X0
  30  P0 = HERMPOLY3(XX,X0,Y0,DY0,X1,Y1,DY1)
      P1 = HPOLY3D1(XX,H,X0,Y0,DY0,X1,Y1,DY1)
      XX1 = XX - P0/P1
      I = I+1
  35  FORMAT(1X,'ITER ',I4,': X = ',F10.6)
      WRITE(*,35) I, XX
      IF ((DABS(XX1-XX) .LT. PREC) .OR. (I .GT. ITER)) GOTO 40
      XX = XX1
      GOTO 30

  40  WRITE(*,*) 'FINISHED:  X = ', XX1
      FINDROOT = XX1

      END

