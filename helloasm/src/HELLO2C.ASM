; HELLO.ASM - single-segment, 16-bit/i8086 "hello world" program
;             ver2: using .dot directives (see below),
;                   fixed for creating .COM
;
; Borland TASM:  tasm hello.asm -> tlink /t hello.obj -> (hello.COM)
;                Alternatively, use EXE2BIN tool to convert, but only
;                when no stack declared and only 'near' addresses.
;

	TITLE	HELLO2C

	.MODEL	TINY		; setup the memory model

; ----- code segment -----
	.DATA

MSG	DB	"Hello from x86 Assembly",0DH,0AH
L_MSG	EQU	$-MSG

	.CODE

	ORG	100H

START:
	JMP	MAIN

MAIN	PROC
; display the message
	MOV	BX,1
	LEA	DX,MSG		; load MSG address
	MOV	CX,L_MSG	; load MSG length
	MOV	AH,40H		; DOS sub-function
	INT	21H

	MAIN	ENDP

; End of program
END	START
