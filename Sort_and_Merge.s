;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; San Jose State University
; Computer Engineering Department
; CMPE 102 - Assembly Programming
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Sort_and_Merge.s
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Vector table
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		AREA	vectors, CODE, READONLY
		EXPORT	__Vectors
__Vectors	
		DCD	0x20008000		; default stack space
		DCD	Reset_Handler		; reset handler addr
				
		AREA	program, CODE, READONLY
		EXPORT	Reset_Handler

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Reset handler
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Reset_Handler	LDR	R0, =__main		; jump to main program
		BLX	R0

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Memory allocation
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		AREA	myData, DATA
		ALIGN   
		; Data allocation	
listA		DCD -50, 20, 6, 0, 6, -2, -4, 2, 10, 20 ; number list A
listB		DCD 15, 25, 1, -1, 9, 1, 11, 9		; number list B
listC		DCD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; number list C (allocate Space)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Main program
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		        AREA	myCode, CODE
		        IMPORT  |myData$$Base|   ; this has to match DATA section name
                IMPORT  |Load$$ER_RW$$Base|
                IMPORT  |Load$$ER_RW$$Length|
                EXPORT	__main
		        ALIGN   4
		        ENTRY
; Main routine
__main		    PROC
; Initialize allocated data
		LDR	r1, =|myData$$Base|      ; load address WR area
		LDR	r2, =|Load$$ER_RW$$Base| ; load addr of values
		LDR	r3, =|Load$$ER_RW$$Length|
;Copy Lists A & B into memory
start_copy      CMP     r3, #0
                BEQ     end_copy
                LDR     r4, [r2], #4
                STR     r4, [r1], #4
                SUB     r3, #4
                B       start_copy
end_copy        NOP
                
;Sort List A
A_begin		LDR	r4, =listA
		LDR	r5, =listB
		SUB 	r1, r5, r4 	; Loop Counter Initialization
		LDR	r2, =listA	; Set Address of Entry 1
		ADD	r3, r2, #4	; Address of Entry 2
A_check		CMP	r1, #0
		BEQ	A_done
		LDR	r4, [r2]	;Read Entry n
		LDR	r5, [r3]	;Read Entry n + 1
		CMP 	r4, r5		;Compare both numbers
		BLE	A_next

A_swap		STR 	r4, [r3]	;
		STR	r5, [r2]	;
		B	A_begin
A_next		ADD	r2, #4
		ADD	r3, #4
		SUB	r1, #4
		B	A_check

A_done		B	B_begin

;Sort List B
B_begin		LDR	r4, =listB
		LDR	r5, =listC
		SUB 	r1, r5, r4 	; Loop Counter Initialization
		LDR	r2, =listB	; Set Address of Entry 1
		ADD	r3, r2, #4	; Address of Entry 2
B_check		CMP	r1, #0
		BEQ	B_done
		LDR	r4, [r2]	;Read Entry n
		LDR	r5, [r3]	;Read Entry n + 1
		CMP 	r4, r5		;Compare both numbers
		BLE	B_next

B_swap		STR 	r4, [r3]	;
		STR	r5, [r2]	;
		B 	B_begin
B_next		ADD	r2, #4
		ADD	r3, #4
		SUB	r1, #4
		B	B_check

B_done		NOP

;Merge A & B


stop		
		B	stop		; loop here forever
		ENDP
		END
				
