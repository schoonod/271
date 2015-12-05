; Title: Program6b (Program6b.asm)
; Name: Dane Schoonover
; schoonod@oregonstate.edu
; CS271-400
; Due 12/06/2015
; Description:	Program6 generates the answer to random combinatorics problems. 
;				It creates a problem from a random number r items in [1..n] from 
;				a set of n items in [3..12], then requests user input
;				for an answer to the combinatoric problem. It then evaluates 
;				the user input and provides the correct answer.


INCLUDE Irvine 32.inc

; Constants
NMIN	=	3
NMAX	= 	12
RMIN	=	1

.data
; Message Outputs
; Intro messages
	msgIntro			BYTE	"Welcome to the Random Combinatorics Problem generator, "
						BYTE    "programmed by Dane Schoonover. ",0dh,0ah
						BYTE	"This program generates random combinatorics problem. ",0dh,0ah
						BYTE	"It will provide you with r items taken from a set of n items. ",0dh,0ah
						BYTE	"You must then input the answer to the problem.",0dh,0ah,0
	msgNamePrompt		BYTE	"Please enter your first name: ", 0
	msgGreeting			BYTE	"Hello ",0
	msgProblem			BYTE	"Your combinatorics problem is as follows: ",0dh,0ah,0
	msgNItems			BYTE	"The number of n items is: ",0dh,0ah,0
	msgRItems			BYTE	"The number of r items is: ",0dh,0ah,0
	msgUserInput		BYTE	"Please input the answer to this problem: ",0

; Error message
	msgError			BYTE	"Non-digit input, try again.",0dh,0ah,0

; Results messages
	showResults1		BYTE	"There are ", 0
	showResults2		BYTE	" combinations of ",0
	showResults3		BYTE	" items from a set of "
	correctAnswer		BYTE	"You are correct.",0dh,0ah,0
	incorrectAnswer		BYTE	"You are incorrect.",0dh,0ah,0
	tryAgain			BYTE	"Another problem? Enter 'y' or 'n' for 'yes' or 'no'",0

; Goodbye message
	goodbye				BYTE	"Goodbye ",0 



; Variables
	userName			BYTE	20 DUP(?)
	randomN				DWORD	?
	randomR				DWORD	?
	result				DWORD	?
	buffer				BYTE	5 DUP(?)
	userInput 			DWORD	?
	again 				BYTE	1 DUP(?)
	y 					BYTE	"y",0dh,0ah,0
	n 					BYTE	"n",0dh,0ah,0

.code
main PROC
	
again:
	call	Randomize

	call 	introduction

	push	OFFSET randomN
	push	OFFSET randomR
	call	showProblem

	push 	OFFSET buffer
	push 	OFFSET userInput
	call	getData

	push 	OFFSET result
	push 	randomN
	push 	randomR
	call 	combinations

	push 	randomN
	push 	randomR
	push 	userInput
	push 	result
	call 	showResults

	mov 	esi, OFFSET again
	mov 	edi, OFFSET y
	cmpsb
	je		again

	mWriteString goodbye
main ENDP



introduction PROC 
; The Introduction Procedure displays a series of introduction 
; messages and greets the user by receiving their name as input.

; Display program introduction
	mWriteString 	msgIntro
	mov				eax, 1600
	call			Delay
	mWriteString 	msgNamePrompt
	mReadString		userName
	mWriteString	msgGreeting
	mWriteString	userName
	call			CrLf
	ret
introduction ENDP

showProblem PROC
	push			ebp
	mov				ebp, esp
	mov				edx, [ebp+12]
	mov				ecx, [ebp+8]
	
	sub				eax, NMIN
	inc				eax
	call			RandomRange
	add				eax, NMIN
	mov				[ecx], eax			; capture the randomR value for the problem

	mov				eax, NMAX
	sub				eax, NMIN
	inc				eax
	call			RandomRange
	add				eax, NMIN
	mov				[edx], eax			; capture the randomN value for the problem

	
	;sub				eax, [ecx]			; n - r
	;mov				[edi], eax			; capture nMinRFact

	mWriteString	msgProglem
	mWriteString	msgNItems
	mWriteString	msgRItems

	pop 			ebp
	ret 			8
showProblem ENDP

getData PROC
; Citation: ASCII character comparison and string conversion taken from demo6.asm
	push	ebp
	mov		ebp, esp
	pushad

	mov 	edi, [ebp+12]				; buffer in edi

	; Get user input/get new input
	getNewNumb:

		mov				eax, 0
		mov				ebx, [ebp+8]	; userInput
		mov				[ebx], eax 		; move 0 into userinput

		mWriteString	msgUserInput	; enter your answer
		mReadString 	edi				; read input into edi (buffer)
		mov				ecx, eax 		; sets loop counter to size of buffer


	getNextChar:
		mov				ebx, [ebp+8]	
		mov				eax, [ebx]		; move value of ebp+8 into eax for multiplication
		mov				ebx, 10 		
		mul				ebx 		 
		
		mov				ebx, [ebp+8]	; move userInput offset into ebx
		mov				[ebx], eax 		; move eax into first position of user input
		mov				al, [edi]		; move first position of buffer into al
		cmp				al, 48
		jl				nonDigit 		; if not a digit

		cmp				al, 57
		jg				nonDigit 		; if not a digit

		inc				edi 			; is a digit, move to next buffer position
		sub				al, 48 			; get actual value
			
		mov				ebx, [ebp+8]	; mov userInput offset into ebx
		add				[ebx], al 		; add actual to 10*x

		loop			getNextChar		; move to next character
		jmp				quit

	nonDigit:
		mWriteString	msgError
		jmp				getNewNumb

	quit:
		popad
		pop				ebp
		ret				4
getData ENDP

combinations PROC
					;OFFSET result = ebp+16
					;randomR = ebp+12
					;randomN = ebp+8
	LOCAL			nFact:DWORD, 	;[ebp-4]
					rFact:DWORD, 	;[ebp-8]
					nMinR:DWORD, 	;[ebp-4]
					nMinRFact:DWORD ;[ebp-16]

	push			ebp
	mov				ebp, esp
	pushad

	mov 			esi, [ebp+16]
	
; r! calculation
	push 			rFact
	push 			[ebp+12]		;randomR
	call 			factorial
	;mov			rFact, ebx		;capture r!

; n! calculation
	push 			nFact
	push 			[ebp+8]			;randomN
	call 			factorial 	
	;mov			nFact, ebx		;capture n!

; nMinR! calculation
	mov				eax, [ebp+8]	; n
	sub				eax, [ebp+12]	; n-r
	mov				nMinR, eax 		; move (n-r) into LOCAL var
	push 			nMinRFact
	push 			nMinR
	call 			factorial


; answer calculation
	mov 			eax, nFact
	div				rFact 			; eax = n!/r!
	div				nMinRFact 		; eax = (n!/r!)/nMinR!
	mov 			[esi], eax 		; set result

	popad
	pop 			ebp
	ret 			12
combinations ENDP


factorial PROC
; factorial code from page 305, Irvine
	push 			ebp
	mov				ebp, esp
	pushad

	mov				edx, [ebp+12]	; LOCAL from combination to capture factorial
	mov				eax, [ebp+8] 	; EAX contains randomR
	com 			eax, 0 			; BASE CASE
	ja 				L1				; n > 0, continue
	mov				eax, 1 			; BASE CASE IS MET, return 1 as the value of 0!
	jmp				L2				; now return eax to caller

  L1:
	dec 			eax
	push 			eax 			; factorial is now one less
	call 			factorial
  
  returnFactorial:
  	mov				ebx,[ebp+8]		; return current! to call (n=1 at base case)
  	mul				ebx				; multiplies total! by current!
  	mov				edx, ebx		; capture the factorial

  L2:
  	popad
    pop 			ebp
    ret 			8
factorial ENDP

showResults PROC
	push ebp
	mov ebp, esp
	pushad

	mov 			ebx, [ebp+20]	; user answer
	mov 			edx, [ebp+8] 	; correct answer

	mWriteString	showResults1
	mov 			eax, edx
	call 			WriteDec
	mWriteString 	showResults2
	mov 			eax, [ebp+12]
	call 			WriteDec
	mWriteSTring 	showResults3
	mov 			eax, [ebp+16]
	call 			WriteDec

	cmp 			edx, ebx
	je 				correct
  	mWriteString 	incorrectAnswer
  	jmp				done

  correct:
	mWriteString 	correctAnswer  
 
  done:
  	mWriteString 	tryAgain
	mReadString		again

	popad
	pop 			ebp
	ret 			16
showResults ENDP

END main



