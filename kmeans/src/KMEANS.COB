000100 IDENTIFICATION DIVISION.
       PROGRAM-ID.   KMEANS.
           THIS PROGRAM IS A SIMPLE DEMO FOR ILLUSTRATING HOW EVEN
           MODERN DATA ANALYTICS ALGORITHMS CAN BE IMPLEMENTED IN
           VERY OLD PROGRAMMING LANGUAGES LIKE COBOL.
       AUTHOR.       MYSELF.
       DATE-WRITTEN. 1 JANUARY 1960.
       SECURITY.     NONE.

000200 ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  TRS-80.
       OBJECT-COMPUTER.  TRS-80.

000300 DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  N-DATA     PIC 99 VALUE 10.
       77  N-MAXITER  PIC 9999 VALUE 100.
       77  N-ITER     PIC 9999.
       77  N-CHANGED  PIC 99.
       77  N-CALC     PIC 999999.

       01  DATA-FIELDS.
       02  DATA-X     PIC 99 OCCURS 10 TIMES.
       02  DATA-Y     PIC 99 OCCURS 10 TIMES.
       02  DATA-C     PIC 99 OCCURS 10 TIMES.
       02  CL1-X      PIC 99.
       02  CL1-Y      PIC 99.
       02  N-CL1      PIC 99.
       02  CL2-X      PIC 99.
       02  CL2-Y      PIC 99.
       02  N-CL2      PIC 99.
       02  SUM1-X     PIC 9999.
       02  SUM1-Y     PIC 9999.
       02  SUM2-X     PIC 9999.
       02  SUM2-Y     PIC 9999.
       02  DC1        PIC 9999.
       02  DC2        PIC 9999.
       02  DX         PIC 9999.
       02  DY         PIC 9999.
       02  N-T        PIC 99.

000400 PROCEDURE DIVISION.
       START-INIT.
           DISPLAY (1, 1) "KMEANS CLUSTERING EXAMPLE" ERASE.
           DISPLAY (3, 1) "PROCESSING DATA..."

      *** INITIALIZE CLUSTER CENTERS ***
           MOVE 1 TO CL1-X.
           MOVE 1 TO CL1-Y.
           MOVE 80 TO CL2-X.
           MOVE 25 TO CL2-Y.

      *** SET UP THE DATA POINTS ***
           MOVE 13 TO DATA-X(1).
           MOVE  5 TO DATA-Y(1).
           MOVE ZERO TO DATA-C(1).

           MOVE 10 TO DATA-X(2).
           MOVE  3 TO DATA-Y(2).
           MOVE ZERO TO DATA-C(2).

           MOVE  5 TO DATA-X(3).
           MOVE 20 TO DATA-Y(3).
           MOVE ZERO TO DATA-C(3).

           MOVE 17 TO DATA-X(4).
           MOVE 17 TO DATA-Y(4).
           MOVE ZERO TO DATA-C(4).

           MOVE  9 TO DATA-X(5).
           MOVE 13 TO DATA-Y(5).
           MOVE ZERO TO DATA-C(5).

           MOVE 43 TO DATA-X(6).
           MOVE 15 TO DATA-Y(6).
           MOVE ZERO TO DATA-C(6).

           MOVE 50 TO DATA-X(7).
           MOVE 13 TO DATA-Y(7).
           MOVE ZERO TO DATA-C(7).

           MOVE 45 TO DATA-X(8).
           MOVE 20 TO DATA-Y(8).
           MOVE ZERO TO DATA-C(8).

           MOVE 57 TO DATA-X(9).
           MOVE 17 TO DATA-Y(9).
           MOVE ZERO TO DATA-C(9).

           MOVE 69 TO DATA-X(10).
           MOVE 11 TO DATA-Y(10).
           MOVE ZERO TO DATA-C(10).

      *** MAIN LOOP: KMEANS ITERATIONS ***
       START-ITER.
           MOVE ZERO TO N-CALC.
           MOVE ZERO TO N-ITER.
       CONT-ITER.
           ADD 1 TO N-ITER.
           IF N-ITER GREATER THAN N-MAXITER GO TO END-ITER2.

           MOVE ZERO TO N-CL1.
           MOVE ZERO TO SUM1-X.
           MOVE ZERO TO SUM1-Y.
           MOVE ZERO TO N-CL2.
           MOVE ZERO TO SUM2-X.
           MOVE ZERO TO SUM2-Y.
           MOVE ZERO TO N-CHANGED.

      *** INNER LOOP: SCAN DATA POINTS ***
       START-SCAN.
           MOVE 1 TO N-T.
       CONT-SCAN.
           IF N-T GREATER THAN N-DATA GO TO END-SCAN.

      *** STEP 1: CALCULATE DISTANCES TO CENTROIDS ***
           COMPUTE DX = DATA-X(N-T) - CL1-X.
           COMPUTE DY = DATA-Y(N-T) - CL1-Y.
           COMPUTE DC1 = DX * DX + DY * DY.

           COMPUTE DX = DATA-X(N-T) - CL2-X.
           COMPUTE DY = DATA-Y(N-T) - CL2-Y.
           COMPUTE DC2 = DX * DX + DY * DY.

           ADD 1 TO N-CALC.

      *** STEP 2: SELECT CLOSEST CLUSTER ***
           IF DC1 GREATER THAN DC2 GO TO SELECT-CL2.
       SELECT-CL1.
           ADD DATA-X(N-T) TO SUM1-X.
           ADD DATA-Y(N-T) TO SUM1-Y.
           ADD 1 TO N-CL1.
           IF DATA-C(N-T) EQUAL 1 GO TO LOOP-SCAN.
           MOVE 1 TO DATA-C(N-T).
           ADD 1 TO N-CHANGED.
           GO TO LOOP-SCAN.
       SELECT-CL2.
           ADD DATA-X(N-T) TO SUM2-X.
           ADD DATA-Y(N-T) TO SUM2-Y.
           ADD 1 TO N-CL2.
           IF DATA-C(N-T) EQUAL 2 GO TO LOOP-SCAN.
           MOVE 2 TO DATA-C(N-T).
           ADD 1 TO N-CHANGED.

       LOOP-SCAN.
           ADD 1 TO N-T.
           GO TO CONT-SCAN.

      *** STEP-3: UPDATE CENTROIDS ***
       END-SCAN.
           COMPUTE CL1-X = SUM1-X / N-CL1.
           COMPUTE CL1-Y = SUM1-Y / N-CL1.
           COMPUTE CL2-X = SUM2-X / N-CL2.
           COMPUTE CL2-Y = SUM2-Y / N-CL2.

           IF N-CHANGED EQUAL ZERO GO TO END-ITER1.
           GO TO CONT-ITER.

      *** PROCESSING FINISHED, SHOW RESULTS ***
       END-ITER1.
           DISPLAY(19, 1) "RESULT: STABLE SOLUTION FOUND".
           GO TO SHOW-RES.
       END-ITER2.
           DISPLAY(19, 1) "RESULT: MAX ITERATIONS REACHED".

       SHOW-RES.
           DISPLAY (4, 1) " "
           DISPLAY " "
           MOVE ZERO TO N-T.
       CONT-RES.
           ADD 1 TO N-T.
           DISPLAY "(" DATA-X(N-T) "," DATA-Y(N-T) "): C=" DATA-C(N-T).
           IF N-T NOT EQUAL N-DATA GO TO CONT-RES.

           DISPLAY(20, 1) "CLUSTER 1: (" CL1-X "," CL1-Y ") N=" N-CL1.
           DISPLAY(21, 1) "CLUSTER 2: (" CL2-X "," CL2-Y ") N=" N-CL2.
           DISPLAY(23, 1) N-CALC " DIST.EVAL. IN " N-ITER " ITERATIONS".
           DISPLAY " ".

           STOP RUN.
