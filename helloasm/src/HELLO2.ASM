; HELLO.ASM - single-segment, 16-bit/i8086 "hello world" program
;             ver2: using .dot directives (see below)
;
; Borland TASM:  tasm hello.asm -> tlink /t hello.obj -> (hello.COM)
;                Alternatively, use EXE2BIN tool to convert, but only
;                when no stack declared and only 'near' addresses.
;

	TITLE	HELLO2

	.MODEL	SMALL		; setup the memory model

; ----- setup the stack -----
	.STACK

; ----- data segment -----
	.DATA

MSG	DB	"Hello from x86 Assembly",0DH,0AH
L_MSG	EQU	$-MSG

; ----- code segment -----
	.CODE

; Procedure: MAIN
MAIN	PROC	FAR

; setup the program start
	.STARTUP

; display the message
	MOV	BX,1
	LEA	DX,MSG		; load MSG address
	MOV	CX,L_MSG	; load MSG length
	MOV	AH,40H		; DOS sub-function
	INT	21H

; return to system
	.EXIT

; End of MAIN
	MAIN	ENDP

; End of program
	END