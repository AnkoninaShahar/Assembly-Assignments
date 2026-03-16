COMMENT !
	Description:	Prints a character over a specified number of rows and columns. The background 
					color for the character is consistent along columns and differentiates among rows. 
					The foreground color for the character is consistent along rows and differentiates 
					among columns. After a 16x16 matrix, the colors repeat.

	Author:         SHAHAR ANKONINA
	Date:           03/24/2026	LAST EDITED: 03/15/2026
!

INCLUDE Irvine32.inc	; Includes the Irvine32.inc library

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

CHAR_VAL = 'X'									; The character printed on the screen
NUM_ROWS = 16									; The number of rows printed on the screen
NUM_COLS = 16									; The number of columns printed on the screen

.data
; Counters used to track the color of the character
lower_nib BYTE 0								; The lower nibble of the BYTE used to determine the color of the character [Represents the foreground]
upper_nib BYTE 0								; The upper nibble of the BYTE used to determine the color of the character [Represents the background]

.code
main proc
	call Clrscr									; Clears the screen

	mov ecx, NUM_ROWS							; Sets the loop counter to the number of rows
	
	; Loop that sets values for each row
	;-----------------------------------------
	rows:
		push ecx								; Push the ECX register to the stack

		; Assign values before the loop
		;-----------------------------------------
		mov ecx, NUM_COLS						; Sets the loop counter to the number of columns
		mov lower_nib, 0						; Resets the lower nibble to 0

		; Loop that sets and prints each character
		;-----------------------------------------
		columns:
			
			; Determines the background color
			movzx eax, upper_nib				; Sets the EAX register to the upper nibble value and sets the rest of the register value to 0
			shl eax, 4							; Shifts the EAX register to the left by 4 to move the value to the upper nibble [AL * 16]

			; Determines the foreground color
			movzx ebx, lower_nib				; Sets the EBX register to the lower nibble value and sets the rest of the register value to 0
			and ebx, 0Fh						; Clears any upper nibble bits
			
			or al, bl							; Combines the upper and lower nibbles into the AL register

			; Prints the character
			call SetTextColor					; Sets the color to the value stored in the AL register [Upper nibble = background & Lower nibble = foreground]
			mov al, CHAR_VAL					; Stores the character to print in the AL register
			call WriteChar						; Prints the character with the proper colors

			inc lower_nib						; Increments the lower nibble counter

			; Decrements ECX register (loop counter)
			; Checks if the ECX register is 0
			; If so -> exit loop, else -> loop columns
			loop columns

		pop ecx									; Pops the ECX register from the stack
		call Crlf								; Prints a new line
		
		inc upper_nib							; Increments the upper nibble counter

		; Decrements ECX register (loop counter)
		; Checks if the ECX register is 0
		; If so -> exit loop, else -> loop rows
		loop rows

	; Resets the text color [Foreground = White & Background = Black]
	mov eax, white + (black * 16)				; Stores the color value in the EAX register
	call SetTextColor							; Sets the color to the value stored in the EAX register

	invoke ExitProcess,0
main endp
end main
