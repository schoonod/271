; Title: Program4 (Program4.asm)
; Name: Dane Schoonover
; schoonod@oregonstate.edu
; CS271-400
; Due 11/08/2015
; Description:	Program4 receives a user input number that specifies the number of composites
;				to display. The program valiates user input and diplays the number of composites
;				once valid input is established.


INCLUDE Irvine32.inc


; CONSTANTS
	LOWERLIMIT	=	1
	UPPERLIMIT	=	400

.data
	; Message Outputs
		; Intro messages and sizes (for stack addressing)
			msgIntro			BYTE	"Welcome to the Composite Diplay Thingy by Dane Schoonover", 0
			msgNamePrompt		BYTE	"Please enter your first name: ", 0
			userName			BYTE	20 DUP(0)
			msgGreeting			BYTE	"Hello ",0
			msgDecPrompt		BYTE	"Enter the number of composites to display [1 - 400]: ", 0			

		; Error message
			msgError			BYTE	"Out of range. Try again.", 0
	
		; Goodbye message
			goodbye				BYTE	"Goodbye ",0 

		; Variables
			userComposite		DWORD	?
			testComposite		WORD	4
			compositeCounter	BYTE	0
			compositesPerLine	BYTE	0
			divArray			BYTE	2, 3, 5, 7
			threeSpaces			BYTE	"   ", 0
					

.code
main PROC
	call		Introduction
	call		GetUserData
	call		ShowComposites
	call		Farewell
exit
main ENDP

Introduction PROC
	
	; Display program introduction
	mov			edx, OFFSET msgIntro
	call		WriteString
	call		CrLf
	;mov		edx, OFFSET extraCredit1
	;call		WriteString
	;call		CrLf
	
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


GetUserData PROC
	; Get user data loop
	L1:
		mov			ecx, 1					; set ecx to 1 to deactivate L1; loop may activate during validation
		mov			edx, OFFSET msgDecPrompt
		call		WriteString
		call		ReadInt											
		call		Validate
		loop		L1
	
	mov			userComposite, eax			; user input is valid
	ret
GetUserData ENDP


Validate PROC	
	cmp			eax, LOWERLIMIT
	jb			L2							; set ecx counter to loop L1
	cmp			eax, UPPERLIMIT
	ja			L2							
	ret
	
	; Display error for invalid input
	L2:
		mov			edx, OFFSET msgError
		call		WriteString
		call		CrLf
		mov			eax, 1200
		call		Delay
		mov			ecx, 2					; activate L1 to get user input again
	
	ret
Validate ENDP
		

ShowComposites PROC USES ebx ecx
	mov		ecx, userComposite				; L1 counter
	
	L1:
		call IsComposite
		loop L1
		
	ret
ShowComposites ENDP


IsComposite PROC USES eax ebx ecx edx esi
	Start:
		mov		ebx, 0
		mov		esi, OFFSET divArray		; bl is the divisor; increment after each composite test
		mov		bl, [esi]					; dereference ESI and move value to bl

	BeginWhile:
		cmp		testComposite, bx	
		jz		NextDivisor					; dividend equals divisor (potential prime); make sure jz is working
		mov		ax, testComposite
		div 	bl							; divides ax/bl
		cmp 	ah, 0 						; check if it's a composite
		jz		FoundComposite
			
	NextDivisor:
		cmp 	bl, 7						; if they are not equal, determine if divisor counter is at end (signals not a composite)
		jz	 	FoundSeven					; if not a composite, end the test and return to showComp loop
		inc		esi							; increment to the next array position
		mov		bl, [esi]					; dereference ESI and move value to bl
		jmp		BeginWhile
		
	FoundSeven:
		inc		testComposite
		jmp		Start

	; displays testComposite (only 10 per line) and jumps to EndWhile to return back to showComposites and loop again
	FoundComposite:
		cmp		compositesPerLine, 10
		jae		TenCompositesReset
		movzx	eax, testComposite
		call	WriteDec
		mov		edx, OFFSET threeSpaces
		call	WriteString
		inc		compositesPerLine
		inc		testComposite
		jmp		EndWhile
		
	; resets the 10 per line counter
	TenCompositesReset:
		mov		CompositesPerLine, 0
		call	CrLf
		jmp		FoundComposite
		
	EndWhile:
	
	ret
IsComposite ENDP


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
