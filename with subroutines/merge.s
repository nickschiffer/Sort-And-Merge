;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; San Jose State University
; Computer Engineering Department
; CMPE 102 - Assembly Programming
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 
; Nickolas Schiffer
; merge.s
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Merge Subroutine
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		AREA	merge_sub, CODE
                EXPORT	merge
		ALIGN
merge	PROC
; Preserve Caller Registers
	    PUSH {LR} 				    ; Preserve LR
	    PUSH {r4, r5, r6, r7, r8, r9, r10, r11} ; Preserve Caller Registers

; Extract Paramters
	    MOV r7, r0			; Extract Address List A Paramter
	    MOV r8, r1			; Extract Size of List A Paramter
	    MOV r9, r2			; Extract Address List B Paramter
	    MOV r10, r3			; Extract Size of List B Paramter
			
; Set up Registers for Merge Algorithm 
	    LDR	  r0, [SP, #36]	        ; Extract List C Address Paramter from Stack with offset of what was just pushed
	    MOV	  r1, r7		; Index_A
	    MOV	  r2, r9		; Index_B
	    ADD	  r3, r1, r8	        ; A_boundary
	    ADD	  r4, r2, r10	        ; B_boundary
	    MOV   r8, #0		; Insertion Counter used to bounds check insertion
	    LDR   r9, [SP, #40]	        ; Extract List C Max Size Parameter from Stack with offset of what was just pushed

; Merge Algorithm			
merge_check CMP   r1, r3		; Check if A still has Elements
            BGE   fill_B		; If A is out of Elements, Fill with B
            CMP   r2, r4		; Check if B still has Elements
            BGE   fill_A		; If B is out of Elements, Fill with A
            LDR   r5, [r1]   	        ; Load A[i]
	    LDR   r6, [r2]   	        ; Load B[i]
	    CMP   r5, r6		; Comapare A[i] with B[i]
            BLE   ins_A			; If A[i] is Less Than B[i], insert A[i]
	    B	  ins_B			; If A[i] is Greater Than B[i], insert B[i]

ins_A       STR   r5, [r0], #4	        ; Insert A[i] into C[i]
	    ADD   r1, #4		; Increment A indx
	    ADD   r8, #4		; Increment Insertion Counter
            CMP   r8, r9		; Compare Insertion Counter with C max size
            BGE   merge_done	        ; If Greater Than or Equal To, Branch to merge_done
            B     merge_check	        ; If not, Move on to Next Comparison

ins_B       STR   r6, [r0], #4	        ; Insert B[i] into C[i]
	    ADD   r2, #4		; Increment B indx
            ADD   r8, #4		; Increment Insertion Counter
            CMP   r8, r9		; Compare Insertion Counter with C max size
            BGE   merge_done	        ; If Greater Than or Equal To, Branch to merge_done
            B     merge_check	        ; If not, Move on to Next Comparison

fill_A      CMP   r1, r3		; Check if A still has Elements
            BGE   merge_done	        ; If A has no more Elements, Branch to merge_done
            LDR   r5, [r1]		; Load A[i]
            STR   r5, [r0], #4          ; Store A[i] into C[i]
            ADD   r1, #4		; Increment A indx
            ADD   r8, #4		; Increment Insertion Counter
            CMP   r8, r9		; Compare Insertion Counter with C max size
            BGE   merge_done	        ; If Greater Than or Equal To, Branch to merge_done
            B     fill_A		; B has no more Elements, Loop fill_A until A runs out of Elements or C max is reached

fill_B      CMP   r2, r4		; Check if B still has Elements
            BGE   merge_done	        ; If B has no more Elements, Branch to merge_done
            LDR   r6, [r2]		; Load B[i]
            STR   r6, [r0], #4	        ; Store B[i] into C[i]
            ADD   r2, #4		; Increment B indx
            ADD   r8, #4		; Increment Insertion Counter
            CMP   r8, r9		; Compare Insertion Counter with C max size
            BGE   merge_done	        ; If Greater Than or Equal To, Branch to merge_done
            B     fill_B		; A has no more Elements, Loop fill_B until B runs out of Elements or C max is reached
merge_done

; Output Parameters
            LSR r0, r8, #2              ; Convert Size to Number of Elements
			
	; Zero-out remaining return Registers
            MOV r1, #0	
            MOV r2, #0
            MOV r3, #0

; Restore Caller Registers
            POP {r4, r5, r6, r7, r8, r9, r10, r11}
            POP {LR}
			
; Increment SP twice to account for two input Parameters not being popped
            ADD SP, #8

; Return to Caller
            BX LR
	
	    ENDP
	    END
