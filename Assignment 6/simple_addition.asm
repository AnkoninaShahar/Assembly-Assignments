COMMENT !
	Description:	Prompts the user for two integer values and sums the values.
					Using the Gotoxy procedure from the Irvine32 library, the program
					prints in the center of the terminal screen.

	Author:         SHAHAR ANKONINA
	Date:           03/24/2026	LAST EDITED: 03/15/2026
!

INCLUDE Irvine32.inc	; Includes the Irvine32.inc library

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
val		SDWORD ?								; Variable used to store an integer value of size SDWORD 

; Strings that prompt the user for the first and second integer values
prompt1	BYTE "Enter first integer:  ", 0
prompt2	BYTE "Enter second integer: ", 0
sum_str	BYTE "The sum is:           ", 0		; String denoting the sum of the two integers 

.code
main proc
	call Clrscr									; Clears the screen

	; Moves the cursor to the center of the screen [column x row]
	mov dl, 35									; Stores the column value in the DL register (column = 35)
	mov dh, 10									; Stors the row value in the DH register (row = 10)
	call Gotoxy									; Relocates the cursor

	; Prompts the user for the first integer
	mov edx, OFFSET prompt1						; Stores the prompt in the EDX register
	call WriteString							; Prints the prompt stored in the EDX register to the screen
	call ReadInt								; Stores the value inputed into the EAX register
	mov val, eax								; Stores the value in the EAX register into the val variable

	; Moves the cursor to the center of the screen [column x row]
	mov dl, 35									; Stores the column value in the DL register (column = 35)
	mov dh, 12									; Stors the row value in the DH register (row = 12)
	call Gotoxy									; Relocates the cursor
	
	; Prompts the user for the second integer
	mov edx, OFFSET prompt2						; Stores the prompt in the EDX register
	call WriteString							; Prints the prompt stored in the EDX register to the screen
	call ReadInt								; Stores the value inputed into the EAX register
	add eax, val								; Adds the two integers together and stores the sum in the EAX register
	
	; Moves the cursor to the center of the screen [column x row]
	mov dl, 35									; Stores the column value in the DL register (column = 35)
	mov dh, 14									; Stors the row value in the DH register (row = 14)
	call Gotoxy									; Relocates the cursor

	; Prints the sum to the screen
	mov edx, OFFSET sum_str						; Stores the string denoting the sum in the EDX register
	call WriteString							; Prints string in the EDX register to the screen
	call WriteInt								; Prints the sum stored in the EAX register to the screen

	call Crlf									; Prints a new line

	invoke ExitProcess,0
main endp
end main
