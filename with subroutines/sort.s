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
				IMPORT	merge
		        ALIGN
sort	PROC
; Preserve Registers
PUSH {LR};
PUSH {r4, r5, r6, r7, r8, r9, r10, r11};
;Sort List
begin	LDR	r4, r0;	; Loop Counter Initialization
		LDR	r2, r0;	; Set Address of Entry 1
		ADD	r3, r2, #4	; Address of Entry 2
check	CMP	r1, #4
		BEQ	done
		LDR	r4, [r2]	;Read Entry n
		LDR	r5, [r3]	;Read Entry n + 1
		CMP r4, r5		;Compare both numbers
		BLE	next

swap	STR r4, [r3]	;
		STR	r5, [r2]	;
		B	begin
next	ADD	r2, #4
		ADD	r3, #4
		SUB	r1, #4
		B	check

done	B	begin


