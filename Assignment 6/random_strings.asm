COMMENT !
	Description:	Generates a specified number N of strings [containing a random assortment capital letters]
					of a specified length L and prints the list to the screen.

	Author:         SHAHAR ANKONINA
	Date:           03/24/2026	LAST EDITED: 03/15/2026
!

INCLUDE Irvine32.inc	; Includes the Irvine32.inc library

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

STR_COUNT = 20								; Number N of strings generated
STR_SIZE = 10								; Length L of strings generated

.data
rand_str BYTE STR_SIZE dup(0), 0			; Variable that holds the value of the strings

.code
; ---------------------------------------------------------------------------------------
;	GenerateRandomString
;	Generates a string of Length L containing a random assortment of capital letters.
;	Receives:	EAX: Length L of the string 
;				ESI: Offset memory address the variable used to hold the string	
;	Returns:	EDX: The string generated of random capital characters
; ---------------------------------------------------------------------------------------
GenerateRandomString proc
	LOCAL range: DWORD						; Represents the number of possible characters in the string
	LOCAL ascii_offset: DWORD				; Represents the offset value to retrieve the proper ascii values

	; Push the registers used in this procedure to the stack
	push ebx
	push ecx

	mov ecx, eax							; Set the loop count to the length L of the string
	push eax								; Push the EAX register to the stack

	; Assign values before the loop
	;-----------------------------------------
	mov eax, 0								; Reset the EAX register to 0	[Used to store the character generated]
	mov ebx, 0								; Reset the EBX register to 0	[Used as the string index counter]
	mov range, 26							; Set the range of possible characters to 26
	mov ascii_offset, 65					; Set the offset for the ascii table to 65

	; Loop that generates the string
	;-----------------------------------------
	generate_characters:
		mov eax, range						; Store the range of possible characters in the EAX register

		; Generates a random number within the provided range stored in the EAX register
		; Stores the random value generated back in the EAX register
		call RandomRange

		add eax, ascii_offset				; Adds the offset to the random number within the range to translate it a capital letter

		mov [esi + ebx], al					; Stores capital letter generated into an index of the string
		inc ebx								; Increments the index counter

		; Decrements ECX register (loop counter)
		; Checks if the ECX register is 0
		; If so -> exit loop, else -> loop generate_characters
		loop generate_characters

	mov BYTE ptr [esi + ebx], 0				; Adds a null character to the end of the string
	mov edx, esi							; Stores the generated string into the EDX register to return it

	; Pops the registers used from the stack
	pop eax
	pop ecx
	pop ebx

	ret										; Returns to the call instruction
GenerateRandomString endp

main proc
	call Randomize							; Randomizes the seed to ensure the same strings are not generated each run of the program
	
	mov ecx, STR_COUNT						; Sets the loop counter to the number N of strings to generate

	; Loop that generates the list of strings
	;-----------------------------------------
	generate_string:
		mov eax, STR_SIZE					; Stores the length L of each string in the EAX register
		mov esi, OFFSET rand_str			; Stores the offset memory address of the variable used to store the string in the ESI resgister
		call GenerateRandomString			; Calls the procedure that generates a string of a random set of capital letters

		call WriteString					; Prints the string returned from the procedure and stored in the EDX register to the screen
		call Crlf							; Prints a new line

		; Decrements ECX register (loop counter)
		; Checks if the ECX register is 0
		; If so -> exit loop, else -> loop generate_string
		loop generate_string
	invoke ExitProcess,0
main endp
end main
