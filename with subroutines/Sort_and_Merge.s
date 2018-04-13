;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; San Jose State University
; Computer Engineering Department
; CMPE 102 - Assembly Programming
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Nickolas Schiffer
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
				IMPORT  sort
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
             
; Prepare to call sort for List A
			LDR r0, =listA;
			LDR r1, =listB;
			SUB r1, r1, r0; ;Size of List A
			BL  sort;
; Prepare to call sort for List B
			LDR r0, =listB;
			LDR r1, =listC;
			SUB r1, r1, r0; ; Size of List B
			BL	sort;
			
			B	stop		; loop here forever
			ENDP
			END
				
