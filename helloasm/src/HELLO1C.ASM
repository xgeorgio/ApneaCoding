; HELLO.ASM - single-segment, 16-bit/i8086 "hello world" program
;             ver1: using only standard directives (no .dot),
;                   fixed for creating .COM executable
;
; Borland TASM:  tasm hello.asm -> tlink /t hello.obj -> (hello.COM)
;                Alternatively, use EXE2BIN tool to convert, but only
;                when no stack declared and only 'near' addresses.
;

	TITLE	HELLO1C

;----------
CSEG	SEGMENT	'CODE'	; used for all segments
	ASSUME	CS:CSEG, SS:CSEG, DS:CSEG, ES:CSEG

	ORG	100H	; always start code at offset 256

; jump to the entry point of MAIN
START:
	JMP	MAIN

;----------
MSG	DB	"Hello from x86 Assembly",0DH,0AH
L_MSG	EQU	$-MSG

;----------
; Procedure: MAIN
MAIN	PROC	; no 'FAR' declaration

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

	END	START
