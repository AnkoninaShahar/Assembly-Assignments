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
multiplicands DWORD 65531, 699050, 21
multipliers DWORD 1029, 5461, 178956970

.code
BitwiseMultiply proc
	LOCAL count: BYTE
	mov count, 0
	mov ebx, eax
	mov eax, 0
	mov cl, 0
	mov ecx, 32
	multiply:
		shr ebx, 1
		jnc continue

		push ecx
		
		push edx

		mov edx, edi
		mov cl, count
		shl edx, cl
		add eax, edx

		pop edx
		pop ecx
		continue:
			inc count
			loop multiply

	ret
BitwiseMultiply endp

main proc
	mov ecx, LENGTHOF multiplicands
	mov esi, 0
	multiplication:
		push ecx
		mov eax, multipliers[esi]
		mov edi, multiplicands[esi]
		call BitwiseMultiply
		call DumpRegs

		add esi, 4
		pop ecx
		loop multiplication

	invoke ExitProcess,0
main endp
end main
