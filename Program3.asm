; Title: Program3 (Program3.asm)
; Name: Dane Schoonover
; schoonod@oregonstate.edu
; CS271-400
; Due 10/31/2015
; Description:	Program3 receives negative numbers from user input, counts them until a non-negative
;				number is entered, then calculates the average of the negative numbers. It then displays the following:
;				1. The number of negative numbers entered, or a message if none were entered.
;				2. The sum of the negative integers
;				3. The average, rounded to the nearest integer
;				4. A parting message

INCLUDE Irvine32.inc

; CONSTANTS
	LOWERLIMIT			=			-101
	UPPERLIMIT			=			0

.data
	; Message Outputs
	msgIntro				BYTE		"Welcome to the Integer Accumulator by Dane Schoonover", 0
	extraCredit1			BYTE		"**EC1: Number the lines during user input.", 0
	extraCredit2			BYTE		"**EC2: ", 0
	msgNamePrompt	BYTE		"Please enter your first name: ", 0
	userName				BYTE		20 DUP(0)
	msgGreeting			BYTE		"Hello ",0
	msgIntPrompt		BYTE		"Please enter as many negative integers as you like from the range -1 to -100. ", 0
	msgIntPrompt2		BYTE		"When you are finished, enter a non-negative number, or press enter.", 0
	msgIntPrompt3		BYTE		"Enter negative integer number ", 0
	msgColon				BYTE      ": ", 0
	msgError				BYTE		"Out of range.", 0
	msgSpecial			BYTE		"No negatives were entered.", 0
	msgAccumulator	BYTE		"The total number of valid integers you entered is: ", 0
	msgSum					BYTE		"The sum of valid integers is: ", 0
	msgAverage			BYTE		"The average of valid integers is: ", 0
	goodbye					BYTE		"Goodbye ",0

	
	; Data variables
	userIntInput			SDWORD	?		; recorded negative integers from user input
	accumulator			DWORD	1		; counts valid user inputs
	sum							SDWORD ?
	arraySum				SDWORD ?


.code
main PROC

; 1. INTRO - Display intro
; Display my intro
	mov			edx, OFFSET msgIntro
	call			WriteString
	call			CrLf
	mov			edx, OFFSET extraCredit1
	call			WriteString
	call			CrLf


; Get the user's first name
	mov			edx, OFFSET msgNamePrompt
	call			CrLf
	call			WriteString
	mov			edx, OFFSET userName
	mov			ecx, SIZEOF userName
	call			ReadString

; Greet the user
	mov			edx, OFFSET msgGreeting
	call			WriteString
	mov			edx, OFFSET userName
	call			WriteString
	call			CrLf
	mov			eax, 1200
	call			Delay

; 2. Instructions
INSTRUCTIONS:
	mov			edx, OFFSET msgIntPrompt
	call			WriteString
	call			CrLf
	mov			edx,	OFFSET msgIntPrompt2
	call			WriteString
	call			CrLf

; 3. Get Data
GET_DATA: 
	mov			ecx, 2													; loop again until user exits
	mov			edx,	OFFSET msgIntPrompt3			; Enter number..
	call			WriteString
	mov			eax, accumulator								; Write String for number line
    call			WriteDec
    mov			edx, OFFSET msgColon
    call			WriteString
	call			ReadInt												; value goes to EAX
	cmp			eax, LOWERLIMIT
	jle			OUT_OF_RANGE
	cmp			eax, UPPERLIMIT
	jge			DISPLAY_COUNTER						
	add			sum, eax											; add input to the sum
	inc			accumulator
	loop			GET_DATA

OUT_OF_RANGE:
	mov			edx, OFFSET msgError
	call			WriteString
	call			CrLf
	mov			eax, 1200
	call			Delay
	jmp			GET_DATA

; 4. Display Counter
DISPLAY_COUNTER:
	dec			accumulator
	cmp			accumulator, 0
	je				SPECIAL_MESSAGE
	mov			edx, OFFSET msgAccumulator
	call			WriteString
	mov			eax, accumulator
	call			WriteDec
	call			CrLf
	mov			eax, 0												; set sum to 0
	jmp			DISPLAY_SUM

; 5. Special message for no integers entered
SPECIAL_MESSAGE:
	mov			edx,	OFFSET msgSpecial				
	call			WriteString
	call			CrLf
	jmp			PARTING_MESSAGE

; 6. Display calculations
DISPLAY_SUM:
	mov			edx, OFFSET msgSum
	call			WriteString
	mov			eax, sum
	call			WriteInt
	call			CrLf

CALC_AVERAGE:
	cdq
	mov			ebx, accumulator
	idiv			ebx
	 
DISPLAY_AVERAGE:
	mov			edx, OFFSET msgAverage
	call			WriteString
	call			WriteInt
	call			CrLf

; 7. Goodbye
PARTING_MESSAGE:
	call			CrLf
	mov			edx, OFFSET goodbye
	call			WriteString
	mov			edx, OFFSET userName
	call			WriteString
	call			CrLf

exit
main ENDP
END main
