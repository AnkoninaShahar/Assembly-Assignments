COMMENT !
	Description:	This program multiplies two integers together using only "bitwise multiplication".
					Shifting an integer to the left multiplies it by 2^[the amount shifted].
					Using the formula:		
									
									multiplicand * 2^[bit degree of the multiplier]
									(in other words shifting a multiplicand to the left
									by the amount of time equivelant to the degree of a 
									bit within a multiplier)

					and adding the sums together for each bit of the multiplier, the computer
					is able to multiply integers in the most efficient way possible. By the end of the
					process, the product is stored in the EAX register.

					This lab relates to the lessons learned in chapter 7 of the textbook as this assignment 
					requires the use of bitwise shifting and knowledge on its affect on a integer.
					It further relates to lessons learned in chapter 5 and 8 of the textbook as writing a 
					procedure is also a requirement for this assigment.
					It also relates to lessons learned in chapter 6 of the textbook through the necessity 
					of conditional jumps used within the loop to determine whether a bit is 1 or 0.

	Author:         SHAHAR ANKONINA
	Date:           03/11/2026	LAST EDITED: 02/25/2026
!

INCLUDE Irvine32.inc	; Includes the Irvine32.inc library

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

MULTIPLIER_BIT_SIZE EQU 32						; Size of the multiplier in bits

.data
; Given test data
multiplicand DWORD 65531, 699050, 21
multiplier DWORD 1029, 5461, 178956970

.code
; ------------------------------------------------------------------
;	BitwiseMultiply
;	Multiplies two DWORD integers together using bitwise operations
;	Receives: EAX: multiplier
;			  EBX: multiplicand
;	Returns: EAX: calculated product
; ------------------------------------------------------------------
BitwiseMultiply proc
	LOCAL shift_count: BYTE						; Local variable to hold the amount to shift by depending on the degree of the bit

	; Pushing all the used registers onto the stack
	;--------------------------------------------------------
	push ecx									; ECX: the count for the number of loops (MULTIPLIER_BIT_SIZE) 						
	push edx									; EDX: stores the value of the multiplier

	; Presets registers and variables for the loop
	;--------------------------------------------------------
	mov edx, eax								; Stores the multiplier value in the EDX register
	mov eax, 0									; Resets the EAX register
	mov ecx, MULTIPLIER_BIT_SIZE				; Sets the loop count to the bit size of the multiplier
	mov shift_count, 0							; Initializes the shift_count local variable to 0

	; Loop that calculates the product of the integers
	;--------------------------------------------------------
	multiply:
		; Early exit test: 
		; If the multiplier is small, the loop won't waste time looping over the extra zeros
		cmp edx, 0								; Checks if EDX is zero
		jz exit_loop							; If so -> exits loop

		shr edx, 1								; Shifts the bits of the multiplier to the right by 1
		jnc skip_multiplication					; If a 0 is shifted into the Carry Flag -> skips the multiplication

		; Pushes all the used registers in this section onto the stack
		push ecx								; CL: stores the amount to shift by
		push ebx								; EBX: makes copy in stack so original multiplicand value is not affected

		; Bitwise shifting operations to multiply values
		mov cl, shift_count						; Stores the amount to shift by in the CL register
		shl ebx, cl								; Shifts the value in the EBX register by the value in the CL register
		add eax, ebx							; Adds the value in the EBX register to the total product in the EAX register

		; Returns all the used registers in this section from the stack
		pop ebx	
		pop ecx

		skip_multiplication:					; Code label to skip multiplication process
			inc shift_count						; Increments the amount to shift by to match the degree of the current bit
			; Decrements ECX register (loop counter)
			; Checks if the ECX register is 0
			; If so -> exit loop, else -> loop multiply
			loop multiply

	; Returns all the used registers from the stack
	;--------------------------------------------------------
	exit_loop:
		pop edx
		pop ecx

	ret											; Returns back to the call statment
BitwiseMultiply endp

main proc
	; Presets registers for the loop
	mov ecx, LENGTHOF multiplicand				; Sets the loop count to the length of multiplicand
	mov esi, 0									; Sets the starting index to 0

	; Loop that runs the multiply procedure over every pair of multiplicand and multiplier 
	main_loop:
		mov eax, multiplier[esi]				; Stores the value of the multiplier in the EAX register
		mov ebx, multiplicand[esi]				; Stores the value of the multiplicand in the EBX register
		call BitwiseMultiply					; Calls the BitwiseMultiply procedure using the values stored in the EAX and EBX registers
		call DumpRegs							; Displays every register

		add esi, TYPE multiplicand				; Increments the index to the next element
		; Decrements ECX register (loop counter)
		; Checks if the ECX register is 0
		; If so -> exit loop, else -> loop main_loop
		loop main_loop

	invoke ExitProcess,0
main endp
end main
