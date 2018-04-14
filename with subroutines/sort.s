;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; San Jose State University
; Computer Engineering Department
; CMPE 102 - Assembly Programming
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Nickolas Schiffer
; sort.s
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Sort Subroutine
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		        AREA	sort_sub, CODE
                EXPORT	sort
		        ALIGN
sort	PROC
; Preserve Registers
		PUSH {LR}				; Preserve LR
		PUSH {r4, r5, r6, r7, r8, r9, r10, r11} ; Preserve Caller Registers
;Sort List
begin	MOV r6, r1
	MOV	r4, r0		; Loop Counter Initialization
	MOV	r2, r0		; Set Address of Entry 1
	ADD	r3, r2, #4	; Address of Entry 2
check	CMP	r6, #4
	BEQ	done
	LDR	r4, [r2]	; Read Entry n
	LDR	r5, [r3]	; Read Entry n + 1
	CMP r4, r5		; Compare both numbers
	BLE	next

swap	STR r4, [r3]	
	STR	r5, [r2]	
	B	begin
next	ADD	r2, #4
	ADD	r3, #4
	SUB	r6, #4
	B	check

done	

; Output Paramters
	LSL r0, r1, #2 		;Convert Size to Number of Elements
	
    ; Zero-out remaining return Registers
	MOV r1, #0
	MOV r2, #0
	MOV r3, #0

; Restore Caller Registers
	POP {r4,r5,r6,r7,r8,r9,r10,r11};
	POP {LR};
		
; Return to Caller
	BX LR
	
	ENDP
	END
