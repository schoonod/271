; Title: Program4 (Program5.asm)
; Name: Dane Schoonover
; schoonod@oregonstate.edu
; CS271-400
; Due 11/08/2015
; Description:	Program5


INCLUDE Irvine32.inc

; CONSTANTS
	MIN		=	10
	MAX		=	200
	LO		=	100
	HI		=	999

.data
	; Message Outputs
		; Intro messages
		msgIntro	BYTE	"Welcome to the Sorting Random Integers Thingy, programmed by Dane Schoonover. "
				BYTE	"This program generates random numbers in the range [100 .. 999], "
				BYTE	"displays the original list, sorts the list, and calculates the "
				BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
		msgNamePrompt		BYTE	"Please enter your first name: ", 0
		userName			BYTE	20 DUP(0)
		msgGreeting			BYTE	"Hello ",0
		msgDecPrompt		BYTE	"How many numbers should be generated? [10 .. 200]: ", 0			

		; Error message
		msgError			BYTE	"Invalid Input, try again.", 0

		; Display messages
		titleUnsorted		BYTE	"The unsorted random numbers are: ", 0
		titleSorted			BYTE	"The sorted random numbers are: ", 0
		msgMedian			BYTE	"The median is: ", 0
	
		; Goodbye message
		goodbye				BYTE	"Goodbye ",0 

	; Variables
		userNumber			DWORD	?
		array				DWORD	MAX DUP(?)			
		;counter1			WORD	4
		;counter2			BYTE	0
		numbersPerLine		BYTE	0
		threeSpaces			BYTE	"   ", 0
					

.code
main PROC
	call		Randomize 
	
	call		Introduction

	push		OFFSET userNumber
	call		GetData
	
	push		OFFSET array
	push		userNumber
	call		FillArray

	push		OFFSET titleUnsorted
	push		OFFSET array
	push		userNumber
	call		DisplayList

	push		OFFSET array
	push		userNumber
	call		SortList

	push		OFFSET msgMedian
	push		OFFSET array
	push		userNumber
	call		DisplayMedian

	push		OFFSET titleSorted
	push		OFFSET array
	push		userNumber
	call		DisplayList

	call		Farewell
 exit
main ENDP

Introduction PROC 
	
	; Display program introduction
	;mov		edx, OFFSET extraCredit1
	;call		WriteString
	;call		CrLf
	mov			edx, OFFSET msgIntro
	call		WriteString
	call		CrLf

	
	; Get the user's first name
	mov			edx, OFFSET msgNamePrompt
	call		CrLf
	call		WriteString
	mov			edx, OFFSET userName
	mov			ecx, SIZEOF userName
	call		ReadString
	
	; Greet the user
	mov			edx, OFFSET msgGreeting
	call		WriteString
	mov			edx, OFFSET userName
	call		WriteString
	call		CrLf
	mov			eax, 1200
	call		Delay
	
	ret			
Introduction ENDP


GetData PROC 
	push		ebp
	mov			ebp, esp
		
	; Get user data loop
	BEGINWHILE:
	mov			ebx, [ebp + 8]
	mov			edx, OFFSET msgDecPrompt	; ask user for number of random numbers to generate
	call		WriteString					
	call		ReadDec						; read input into EAX
	cmp			eax, MIN					; compare to MIN
	jl			INVALID
	cmp			eax, MAX					; compare to MAX
	ja			INVALID							
	mov			[ebx], eax					; input has been validated
	call		CrLf
	jmp			ENDWHILE					

	INVALID:
	mov			edx, OFFSET msgError		; invalid input
	call		WriteString
	call		CrLf
	jmp			BEGINWHILE

	ENDWHILE:
	pop			ebp	
	ret			4
GetData ENDP

FillArray PROC  
	push		ebp
	mov			ebp, esp
	mov			esi, [ebp+12]
	mov			ecx, [ebp+8]

	FillLoop:
	mov			eax, HI
	sub			eax, LO
	inc			eax
	call		RandomRange
	add			eax, lo
	mov			[esi], eax
	add			esi, 4
	loop		FillLoop
	
	pop ebp
	ret 8 
FillArray ENDP

DisplayList PROC  
	push		ebp
	mov			ebp, esp
	mov			edx, [ebp+16]				; title
	mov			esi, [ebp+12]				; array address
	mov			ecx, [ebp+8]				; array count
	call		WriteString					; print title

	; resets the 10 per line counter
	NewLine:
	call		CrLf
	mov			numbersPerLine, 0

	DisplayLoop:
	cmp			numbersPerLine, 10
	jae			NewLine
	mov			eax, [esi]
	call		WriteDec
	mov			edx, OFFSET threeSpaces
	call		WriteString
	inc			numbersPerLine
	add			esi, 4
	loop		DisplayLoop
	
	pop ebp
	ret 12 
DisplayList ENDP

SortList PROC
; citation: Irvine BUBBLESORT
	push		ebp
	mov			ebp, esp
	mov			ecx, [ebp+8]				; array count
	dec			ecx							; decrement count by 1

L1:	
	push		ecx							; save outer loop count
	mov			esi, [ebp+12]				; array address
			
L2:	
	mov			eax,[esi]					; get array value
	cmp			[esi+4],eax					; compare a pair of values
	jge			L3							; if [esi] <= [edi], don't exch
	xchg		eax,[esi+4]					; exchange the pair
	mov			[esi],eax

L3:	
	add			esi,4						; move both pointers forward
	loop		L2							; inner loop

	pop			ecx							; retrieve outer loop count
	loop		L1							; else repeat outer loop

L4:	
	pop			ebp
	ret			8	
SortList ENDP

DisplayMedian PROC
	push		ebp
	mov			ebp, esp
	mov			edx, [ebp + 16]
	mov			esi, [ebp + 12]
	mov			ecx, [ebp + 8]

	call		CrLf
	call		WriteString
	mov			edx, 0
	mov			eax, ecx
	mov			ebx, 2
	div			ebx							; store userNumber/2 in EAX
	mov			ebx, SIZEOF DWORD
	mul			ebx							; position of array median + 1 in eax
	sub			eax, SIZEOF	DWORD			; correctd to array median
	mov			eax, [esi+eax]				; move the position of the median into ebx
	call		WriteDec
	call		CrLf

	pop			ebp
	ret			12
DisplayMedian ENDP
		
		
	

Farewell PROC
	call			CrLf
	mov				edx, OFFSET goodbye
	call			WriteString
	mov				edx, OFFSET userName
	call			WriteString
	call			CrLf
	ret
Farewell ENDP
			


END main



