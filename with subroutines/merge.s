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
			LDR   r0, =listC ;Index_C
			LDR   r1, =listA ;Index_A
			LDR   r2, =listB ;Index_B
			LDR   r3, =listB ;A_boundary
			LDR   r4, =listC ;B_boundary
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
            B     merge_check
ins_B       STR   r6, [r0], #4
			ADD   r2, #4
            B     merge_check
fill_A      CMP   r1, r3
            BGE   merge_done
            LDR   r5, [r1]
            STR   r5, [r0], #4
            ADD   r1, #4
            B     fill_A

fill_B      CMP   r2, r4
            BGE   merge_done
            LDR   r6, [r2]
            STR   r6, [r0], #4
            ADD   r2, #4
            B     fill_B
merge_done	B 	  stop
stop		
	
		ENDP
		END
