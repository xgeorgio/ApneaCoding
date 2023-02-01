; HELLO.ASM - single-segment, 16-bit/i8086 "hello world" program
;             ver1: using only standard directives (no .dot)
;
; Borland TASM:  tasm hello.asm -> tlink /t hello.obj -> (hello.COM)
;                Alternatively, use EXE2BIN tool to convert, but only
;                when no stack declared and only 'near' addresses.
;

	TITLE	HELLO1

;----------
SSEG	SEGMENT	STACK
	DB	32 DUP("STACK---")
SSEG	ENDS

;----------
DSEG	SEGMENT
MSG	DB	"Hello from x86 Assembly",0DH,0AH
L_MSG	EQU	$-MSG
DSEG	ENDS

;----------
CSEG	SEGMENT	'CODE'
ASSUME	CS:CSEG, SS:SSEG, DS:DSEG

;----------

; Procedure: MAIN
MAIN	PROC	FAR

; save address for exit
	PUSH	DS
	PUSH	0

; setup seg register
	MOV	AX,DSEG
	MOV	DS,AX		; set DS=DSEG via AX

; display the message
	MOV	BX,1
	LEA	DX,MSG		; load MSG address
	MOV	CX,L_MSG	; load MSG length
	MOV	AH,40H		; DOS sub-function
	INT	21H

; return to system
	RET

; End of MAIN
	MAIN	ENDP

; End of Code segment
CSEG	ENDS

	END	MAIN
