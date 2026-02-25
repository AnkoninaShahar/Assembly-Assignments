COMMENT !
	Description:	

	Author:         SHAHAR ANKONINA
	Date:           02/25/2026	LAST EDITED: 
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

.code
SumArray proc
	mov eax, 0
	mov ecx, edi
	mov esi, 0

	sum_elements:
		mov ebx, [edx + esi]
		add esi, 4

		cmp ebx, lowerLimit
		jl continue

		cmp ebx, upperLimit
		jg continue

		add eax, ebx

		continue:
			loop sum_elements
	ret
SumArray endp

main proc
	mov edx, OFFSET array_1
	mov edi, LENGTHOF array_1
	call SumArray
	call DumpRegs

	mov edx, OFFSET array_2
	mov edi, LENGTHOF array_2
	call SumArray
	call DumpRegs

	invoke ExitProcess,0
main endp
end main
