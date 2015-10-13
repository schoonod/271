; Title: Program 1 (Program1.asm)
; Name: Dane Schoonover
; schoonod@oregonstate.edu
; CS271-400
; Program #1
; Due 10/11/2015
; Description: This program receives two integers from the user and computes the
; sum, difference, product, and quotient/remainder of the two numbers. The program
; then outputs these computations.

INCLUDE Irvine32.inc

.data
dIntro BYTE "Prog1 by Dane Schoonover", 0
dInstructions BYTE "Enter a number between 1 and 255: ", 0
uInput1 DWORD ?
uInput2 DWORD ?
sum DWORD ?
diff DWORD ?
product DWORD ?
quotient DWORD ?
remainder DWORD ?
dResult BYTE "Results are as follows: ",0
dSum BYTE "Sum: ",0
dDifference BYTE "Difference: ",0
dProduct BYTE "Product: ",0
dQuotient BYTE "Quotient: ",0
dRemainder BYTE "Remainder: ",0
goodBye BYTE "Goodbye",0


.code
main PROC

; 1. INTRO - Display intro
mov  EDX, OFFSET dIntro
call WriteString
call CrLf

; 2. GET DATA - Prompt for inputs
mov EDX, OFFSET dInstructions
call WriteString
call ReadInt
mov  uInput1, EAX
call WriteString
call ReadInt
mov  uInput2, EAX
call CrLf

; 3. CALCULATE THE VALUES
; Sum
mov  EAX, uInput1
add  EAX, uInput2
mov  sum, EAX

; Difference
mov  EAX, uInput1
mov  EBX, uInput2
sub  EAX, EBX
mov  diff, EAX

; Product
mov  EAX, uInput1
mov  EBX, uInput2
mul  EBX
mov  product, EAX

; Quotient/Remainder
mov  EAX, uInput1
mov  EBX, uInput2
mov  EDX, 0
div  EBX
mov  quotient, EAX
mov  remainder, EDX

; 4. DISPLAY THE VALUES
; Result message
mov  EDX, OFFSET dResult
call WriteString
call CrLf

; Sum
mov  EDX, OFFSET dSum
mov  EAX, sum
call WriteString
call WriteDec
call CrLf

; Difference
mov  EDX, OFFSET dDifference
mov  EAX, diff
call WriteString
call WriteInt
call CrLf

; Product
mov  EDX, OFFSET dProduct
mov  EAX, product
call WriteString
call WriteInt
call CrLf

; Display quotient and remainder
mov  EDX, OFFSET dQuotient
mov  EAX, quotient
call WriteString
call WriteInt
call CrLf
mov  EDX, OFFSET dRemainder
mov	 EAX, remainder
call WriteString
call WriteInt
call CrLf

; Say goodbye
mov  EDX, OFFSET goodBye
call WriteString
call CrLf

exit
main ENDP
END main
