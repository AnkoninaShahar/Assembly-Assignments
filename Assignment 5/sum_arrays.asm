COMMENT !
	Description:	This program adds up all the values in an array within a given limit (in this case
					20 <= x <= 40). It does this by looping through the given array, checking each element, 
					and adding it to the total sum (EAX register) if the integer falls within the limits 
					provided.

					This lab relates to lessons learned in chapter 6 of the textbook when using conditional 
					jumps to determine if an integer falls within the limit alongside the compare instruction.
					It further relates to lessons learned in chapter 5 and 8 of the textbook as writing a 
					procedure is handy in keeping the code clean, readable, and reusable.

	Author:         SHAHAR ANKONINA
	Date:           03/11/2026	LAST EDITED: 02/25/2026
!

INCLUDE Irvine32.inc	; Includes the Irvine32.inc library

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
; Given test data
lowerLimit DWORD 20
upperLimit DWORD 40
array_1 SDWORD 10,30,25,15,17,19,40,41,43		; test case 1
array_2 SDWORD 10,-30,25,15,-17,55,40,41,43		; test case 2

; Sums up elements within a given array
SumArray proto, 
	array_offset: DWORD,						; The offset address of the array
	array_length: DWORD,						; The number of elements in the array
	element_size: DWORD							; The size of each element within the array

.code
main proc
	; Calls the SumArray procedure with the given arguments for array_1
	invoke SumArray, OFFSET array_1, LENGTHOF array_1, TYPE array_1
	call DumpRegs								; Displays every register

	; Calls the SumArray procedure with the given arguments for array_2
	invoke SumArray, OFFSET array_2, LENGTHOF array_2, TYPE array_2
	call DumpRegs								; Displays every register

	invoke ExitProcess,0
main endp

; ------------------------------------------------------------------
;	SumArray
;	Calculates the sum of a given SDWORD array within a given range.
;	Receives: array_offset (DWORD): The starting address of the array
;			  array_length (DWORD): The number of elements to process
;			  element_size (DWORD): The byte size of each element
;	Returns: EAX: calculated sum within [lowerLimit, upperLimit]
; ------------------------------------------------------------------
SumArray proc uses ebx ecx edx esi,
	array_offset: DWORD,						; The offset address of the array
	array_length: DWORD,						; The number of elements in the array
	element_size: DWORD							; The size of each element within the array

	; Presets registers for the loop
	;--------------------------------------------------------
	mov eax, 0									; Resets the EAX register
	mov edx, array_offset						; Stores the memory address of the array in the EDX register
	mov ecx, array_length						; Sets the loop count to the length of the array
	mov esi, 0									; Sets the starting index to 0

	; Loop that sums the elements of the array
	;--------------------------------------------------------
	sum_elements:
		mov ebx, [edx + esi]					; Stores an element in the EBX register
		add esi, element_size					; Increments the ESI register to the next element index

		; Comparison Checks
		cmp ebx, lowerLimit						; Compares the value in the EBX register to the lower limit
		jl skip_addition						; If EBX < lowerLimit -> skips the addition of this particular element
		cmp ebx, upperLimit						; Compares the value in the EBX register to the upper limit
		jg skip_addition						; If EBX > upperLimit -> skips the addition of this particular element

		add eax, ebx							; Adds the value in the EBX register to the total sum in the EAX register			

		skip_addition:							; Code label to skip addition process
			; Decrements ECX register (loop counter)
			; Checks if the ECX register is 0
			; If so -> exit loop, else -> loop sum_elements
			loop sum_elements

	ret											; Returns back to the call statment
SumArray endp
end main
