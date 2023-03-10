000100 IDENTIFICATION DIVISION.
       PROGRAM-ID.   MULTABL.
           THIS PROGRAM IS A SIMPLE DEMO FOR
           ILLUSTRATING BASIC USER I/O AND
           ARITHMETIC OPERATIONS IN COBOL.
       AUTHOR.       MYSELF.
       DATE-WRITTEN. 1 JANUARY 1960.
       SECURITY.     NONE.

000200 ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  TRS-80.
       OBJECT-COMPUTER.  TRS-80.

000300 DATA DIVISION.
       WORKING-STORAGE SECTION.
       01   ACCEPT-FIELDS.
            03   TIT-LE    PIC X(24) VALUE "TYPE IN THE UPPER LIMIT".
            03   TIT-LE2   PIC X(18) VALUE "THAT YOU REQUIRE:".
            03   QUES-1    PIC X(1).
            03   NUM-1     PIC 99.
            03   NUM-2     PIC 99.
            03   NUM-3     PIC 9999.

000400 PROCEDURE DIVISION.
       START-N1.
            DISPLAY(1, 1) TIT-LE ERASE.
            DISPLAY(2, 1) TIT-LE2.
            ACCEPT NUM-1.
            MOVE ZERO TO NUM-2.
            DISPLAY " ".

       START-N2.
            ADD 1 TO NUM-2.
            MULTIPLY NUM-1 BY NUM-2 GIVING NUM-3.
            DISPLAY NUM-1 " X " NUM-2 " = " NUM-3.
            IF NUM-2 EQUAL 15 GO TO START-N3.
            GO TO START-N2.

       START-N3.
            DISPLAY(20, 1) "MORE (Y/N)? "
            ACCEPT QUES-1.
            IF QUES-1 EQUAL "Y" OR "y" GO TO START-N1.
            DISPLAY "PROGRAM COMPLETED."

            STOP RUN.
