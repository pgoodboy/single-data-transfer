    .data
	.balign 4
LDRsign:	.asciz "LDR"
	.balign 4
STRsign:		.asciz "STR"
	.balign 4
Bsign:	.asciz "B"
	.balign 4
tokjai:	.asciz	"!"
        .balign 4
newLine:	.asciz "\n"
        .balign 4
openBrac:	.asciz "["
        .balign 4
closeBrac:	.asciz "]"
        .balign 4
sharpSign:	.asciz "#"
        .balign 4
percentD:	.asciz "%d"
        .balign 4
percentX:	.asciz "%x"
        .balign 4
percentC:	.asciz "%c"
        .balign 4
condition:	.asciz "EQNECSCCMIPLVSVCHILSGELTGTLE"
        .balign 4
shiftIns:	.asciz "LSLLSRASRROR"
        .balign 4
byteSign:	.asciz "B"
        .balign 4
spaceSign:	.asciz " "
        .balign 4
regSign:	.asciz "R"
        .balign 4
commaSign:	.asciz ","
		.balign 4
return:		.word 0
		.balign 4
testValue:
        LDR R1,[R2,#8]
        LDR R2,[R2,R5]!
        LDR R3,[R6,R8,LSR#2]
        LDRB R4,[R5,#0]
        LDREQB R3,[R5,#0]
        STRNE R6,[R2]
        STR R1,[R2]
        STR R3,[R2,#8]
        STR R3,[R2],R4
        STRB R4,[R2,#0]
        .word 0 @ end of list
    .text
    .global main
    .global printf
main:
	LDR     r1,=return
	STR     lr,[r1]	@save return address
	MOV     r9,#0	@set testValue index 0
_start:
        MOV     r8,#0
        LDR     r3, =testValue
        LDR     r4, [r3,r9]	@testValue indexing
        CMP	r4, #0		@ check end
        BEQ	_end
        BL      _printLS
        BL      _printCond
        BL      _printByte
        LDR     r0,=spaceSign   @print space
        BL      printf
        BL      _printDest
        LDR     r0,=commaSign   @print comma
        BL      printf
        LDR     r0,=openBrac   @print open bracket
        BL      printf
        BL      _printBase
        BL      _checkPre
        BL      _checkI
        BL      _printShift
        CMP     r8,#0
        LDR     r0,=closeBrac
        BLEQ    printf
        BL      _printW
        
        LDR     r0,=newLine
        BL      printf
        ADD	r9,r9,#4        @move testValue list index
        B       _start
_printLS:
        SUB 	sp,sp,#8
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]
        LSL     r1,r4,#11
        LSR     r1,r1,#31
        CMP     r1,#0
        LDREQ   r0, =STRsign              @STR instruction
        LDRNE   r0, =LDRsign              @LDR instruction
        BL      printf
        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_printCond:
        SUB 	sp,sp,#20     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]
        STR     r2,[sp,#8]
        STR     r3,[sp,#12]
        STR     r4,[sp,#16]
        
        LSR     r1,r4,#28
        CMP     r1,#14
        
        LDREQ   r4,[sp,#16]
        LDREQ   r3,[sp,#12]
        LDREQ   r2,[sp,#8]
        LDREQ	r1,[sp,#4]
	LDREQ	lr, [sp,#0]
	ADDEQ 	sp,sp,#20
	MOVEQ 	pc, lr
        MOV     r2,#2
        MUL     r4,r2,r1
        LDR     r3,=condition
        LDRB    r1,[r3,r4]
        LDR     r0,=percentC
        BL      printf

        ADD     r4,r4,#1
        LDR     r3,=condition
        LDRB    r1,[r3,r4]
        LDR     r0,=percentC
        BL      printf

        LDR     r4,[sp,#16]
        LDR     r3,[sp,#12]
        LDR     r2,[sp,#8]
        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#20
	MOV 	pc, lr

_printByte:
        SUB 	sp,sp,#8    
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]

        LSL     r1,r4,#9
        LSR     r1,r1,#31
        CMP     r1,#0

        LDREQ	r1,[sp,#4]
	LDREQ	lr, [sp,#0]
	ADDEQ 	sp,sp,#8
	MOVEQ 	pc, lr
        
        LDR     r0,=byteSign
        BL      printf

        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_printDest:
        SUB 	sp,sp,#8     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]
       
        LDR     r0,=regSign
        BL      printf
        LSL     r1,r4,#16
        LSR     r1,r1,#28
        LDR     r0,=percentD
        BL      printf

        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_printBase:
        SUB 	sp,sp,#8     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]
       
        LDR     r0,=regSign
        BL      printf
        LSL     r1,r4,#12
        LSR     r1,r1,#28
        LDR     r0,=percentD
        BL      printf

        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_checkPre:
        SUB 	sp,sp,#8     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]
        
        LSL     r1,r4,#7
        LSR     r1,r1,#31
        CMP     r1,#0
        MOVEQ   r8,#1
        LDREQ   r0,=closeBrac
        BLEQ    printf
        LDR     r0,=commaSign
        BL      printf

        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_checkI:
        SUB 	sp,sp,#12     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]
        STR     r5,[sp,#8]
        
        LSL     r1,r4,#6
        LSR     r1,r1,#31
        MOV     r5,r1
        CMP     r1,#0
        LDREQ   r0,=sharpSign
        LDRNE   r0,=regSign
        BL      printf
        CMP     r5,#0
        BLEQ    _printIm
        BLNE    _printOffsetReg

      
        LDR     r5,[sp,#8]
        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#12
	MOV 	pc, lr
_printIm:
        SUB 	sp,sp,#8     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]

        LSL     r1,r4,#20
        LSR     r1,r1,#20
        LDR     r0,=percentD
        BL      printf

        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_printOffsetReg:
        SUB 	sp,sp,#8     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]

        LSL     r1,r4,#28
        LSR     r1,r1,#28
        LDR     r0,=percentD
        BL      printf

        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_printShift:
        SUB 	sp,sp,#16    
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]
        STR     r5,[sp,#8]
        STR     r6,[sp,#12]

        LSL     r1,r4,#20
        LSR     r1,r1,#27
        CMP     r1,#0

        LDREQ     r6,[sp,#12]
        LDREQ     r5,[sp,#8]
        LDREQ	r1,[sp,#4]
	LDREQ	lr, [sp,#0]
	ADDEQ 	sp,sp,#8
	MOVEQ 	pc, lr

        LDR     r0,=commaSign
        BL      printf
        LSL     r1,r4,#25
        LSR     r1,r1,#30
        MOV     r5,#3
        MUL     r6,r1,r5
        LDR     r5,=shiftIns
        LDRB    r1,[r5,r6]
        LDR     r0,=percentC
        BL      printf
        ADD     r6,r6,#1
        LDRB    r1,[r5,r6]
        LDR     r0,=percentC
        BL      printf
        ADD     r6,r6,#1
        LDRB    r1,[r5,r6]
        LDR     r0,=percentC
        BL      printf

        LDR     r0,=sharpSign
        BL      printf
        LSL     r1,r4,#20
        LSR     r1,r1,#27
        LDR     r0,=percentD
        BL      printf

        LDR     r6,[sp,#12]
        LDR     r5,[sp,#8]
        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_printW:
        SUB 	sp,sp,#8     
	STR 	lr,[sp,#0]
	STR	r1,[sp,#4]

        LSL     r1,r4,#10
        LSR     r1,r1,#31
        CMP     r1,#0
        LDR     r0,=tokjai
        BLNE    printf

        LDR	r1,[sp,#4]
	LDR	lr, [sp,#0]
	ADD 	sp,sp,#8
	MOV 	pc, lr

_end:
        ldr lr, =return
        ldr lr, [lr]
        bx lr
