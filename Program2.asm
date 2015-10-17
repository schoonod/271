; Title: Program 2 (Program1.asm)
; Name: Dane Schoonover
; schoonod@oregonstate.edu
; CS271-400
; Program #1
; Due 10/18/2015

INCLUDE Irvine32.inc

.data
  msgIntro        BYTE "Program2 by Dane Schoonover", 0
  extraCredit1    BYTE "**EC: Numbers are in aligned columns", 0
  extraCredit2    BYTE "**EC: Do something incredible", 0
  msgNamePrompt   BYTE "Please enter your first name: ", 0
  userName        BYTE 20 DUP(0)
  msgGreeting     BYTE "Hello ",0
  msgFibPrompt    BYTE "Please enter the number of Fibonacci terms to be displayed as an integer between 1 - ", 0
  UPPERLIMIT      = 46;
  userFibInput    DWORD ?
  msgError        BYTE "Out of Range", 0
  msgFibs         BYTE "Fibonacci numbers are as follows: ", 0
  fibCounter      DWORD 0            ;current fib index (1,2,3..)
  fiveCounter     DWORD 0
  fib1            DWORD 1
  fib2            DWORD 1
  temp            DWORD ?
  fiveSpaces      BYTE "     ", 0
  goodbye         BYTE "Goodbye ",0


.code
main PROC

; 1. INTRO - Display intro
; Display my intro
  mov  edx, OFFSET msgIntro
  call WriteString
  call CrLf

; Get the user's first name
  mov edx, OFFSET msgNamePrompt
  call CrLf
  call WriteString
  mov edx, OFFSET userName
  mov ecx, SIZEOF userName
  call ReadString

; Greet the user
  mov edx, OFFSET msgGreeting
  call WriteString
  mov edx, OFFSET userName
  call WriteString
  call CrLf
  mov eax, 1200
  call Delay

; ---Instructions---
L1:
  mov edx, OFFSET msgFibPrompt
  call WriteString
  mov eax, UPPERLIMIT
  call WriteDec
  call CrLf

;Get User Data
  call ReadDec
  CMP eax, UPPERLIMIT
  ja ERROR
  CMP eax, 0
  jbe error
  mov userFibInput, eax
  call CrLf
  jmp Fibs

;Error Message
ERROR:
  mov edx, OFFSET msgError
  call WriteString
  call CrLf
  jmp L1

;Display Fibs
Fibs:
  mov edx, OFFSET msgFibs
  call WriteString
  call CrLf
  mov eax, 1200
  call Delay
  CMP userFibInput, 2
  jb ONEFIBS
  je TWOFIBS
  mov fibCounter, 2
  mov fiveCounter, 2
  mov eax, fib1
  mov edx, OFFSET fiveSpaces
  call WriteDec
  call WriteString
  mov eax, fib2
  call WriteDec
  call WriteString
  mov ecx, userFibInput
  jmp FIBCALCULATOR

ONEFIBS:
  mov eax, fib1
  call WriteDec
  jmp FAREWELL

TWOFIBS:
  mov eax, fib1
  mov edx, OFFSET fiveSpaces
  call WriteDec
  call WriteString
  mov eax, fib2
  call WriteDec
  jmp FAREWELL

FIBCALCULATOR:
  inc fiveCounter
  CMP fiveCounter, 5
  ja NEWLINE
  inc fibCounter
  mov eax, fibCounter
  CMP eax, userFibInput
  ja FAREWELL
  mov eax, fib1
  add eax, fib2
  call WriteDec
  mov edx, OFFSET fiveSpaces
  call WriteString
  mov temp, eax
  push fib2
  pop fib1
  mov fib2, eax
  loop FIBCALCULATOR

NEWLINE:
  call CrLf
  mov fiveCounter, 0
  jmp FIBCALCULATOR

; ---Farewell---
FAREWELL:
  call CrLf
  mov edx, OFFSET goodbye
  call WriteString
  mov edx, OFFSET userName
  call WriteString
  call CrLf

;no. of spaces on both sides could equal (12 - LENGTHOF fibNumber)/2

exit
main ENDP
END main
