COMMENT !
	Description:	

	Author:         SHAHAR ANKONINA
	Date:           03/11/2026	LAST EDITED: 02/25/2026
!

INCLUDE Irvine32.inc	; Includes the Irvine32.inc library

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
lowerLimit dword 20
upperLimit dword 40
array_1 sdword 10,30,25,15,17,19,40,41,43    ; test case 1
array_2 sdword 10,-30,25,15,-17,55,40,41,43  ; test case 2

SumArray proto, 
	array:DWORD,
	len:DWORD,
	index:DWORD

.code
main proc
	invoke SumArray, OFFSET array_1, LENGTHOF array_1, TYPE array_1
	call DumpRegs

	call SumArray, OFFSET array_2, LENGTHOF array_2, TYPE array_2
	call DumpRegs

	invoke ExitProcess,0
main endp

SumArray proc uses ebx ecx edx esi,
	array:DWORD,
	len:DWORD,
	index:DWORD
	
	mov eax, 0
	mov edx, array
	mov ecx, len
	mov esi, 0

	sum_elements:
		mov ebx, [edx + esi]
		add esi, index

		cmp ebx, lowerLimit
		jl skip_addition

		cmp ebx, upperLimit
		jg skip_addition

		add eax, ebx

		skip_addition:
			loop sum_elements
	ret
SumArray endp
end main
