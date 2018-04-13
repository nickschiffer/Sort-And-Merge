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
			PUSH {LR} 								;Preserve LR
			PUSH {r4, r5, r6, r7, r8, r9, r10, r11} ; Preserve Caller Registers

; Extract Paramters
			MOV r7, r0			; Extract Address List A Paramter
			MOV r8, r1			; Extract Size of List A Paramter
			MOV r9, r2			; Extract Address List B Paramter
			MOV r10, r3			; Extract Size of List B Paramter
			LDR r11, [SP, #36]	; Extract List C Address Paramter from Stack
			LDR r12, [SP, #40]	; Extract List C Max Size Parameter from Stack
			
; Set up Registers for Merge Algorithm 
			MOV	  r0, r11		; Index_C
			MOV	  r1, r7		; Index_A
			MOV	  r2, r9		; Index_B
			ADD	  r3, r1, r8	; A_boundary
			ADD	  r4, r2, r10	; B_boundary
			MOV   r8, #0		; Insertion Counter used to bounds check insertion
			
merge_check CMP   r1, r3
            BGE   fill_B
            CMP   r2, r4
            BGE   fill_A
            LDR   r5, [r1]   ;Load A[i]
			LDR   r6, [r2]   ;Load B[i]
			CMP   r5, r6
			BLE   ins_A
			B	  ins_B
ins_A       STR   r5, [r0], #4
			ADD   r1, #4
			ADD   r8, #4
			CMP   r8, r12
			BGE   merge_done
			B     merge_check
ins_B       STR   r6, [r0], #4
			ADD   r2, #4
			ADD   r8, #4
			CMP   r8, r12
			BGE   merge_done
            B     merge_check
fill_A      CMP   r1, r3
            BGE   merge_done
            LDR   r5, [r1]
            STR   r5, [r0], #4
            ADD   r1, #4
			ADD   r8, #4
			CMP   r8, r12
			BGE   merge_done
            B     fill_A
fill_B      CMP   r2, r4
            BGE   merge_done
            LDR   r6, [r2]
            STR   r6, [r0], #4
            ADD   r2, #4
			ADD   r8, #4
			CMP   r8, r12
			BGE   merge_done
            B     fill_B
merge_done

; Output Parameters
			LSR r0, r8, #2 ;Convert Size to Number of Elements
			MOV r1, #0
			MOV r2, #0
			MOV r3, #0

; PRestore Caller Registers
			POP {r4, r5, r6, r7, r8, r9, r10, r11}
			POP {LR}

; Return to Caller
			BX LR
	
		ENDP
		END
