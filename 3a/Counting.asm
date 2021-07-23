;;	Author:		Marco Martinez
;;	Filename:		counting.asm
;;	Version:		1.0
;;	Description:	Write a procedure named CountNearMatches that receives pointers to two arrays of signed doublewords,
;;			a parameter that indicates the length of the two arrays, and a parameter that indicates the
;;			maximum allowed difference (called diff) between any two matching elements. For each element x
;;			in the first array, if the difference between it and the corresponding y in the second array is less
;;			than or equal to diff, increment a count. At the end, return a count of the number of nearly matching
;;			array elements in EAX. Write a test program that calls CountNearMatches and passes pointers
;;			to two different pairs of arrays. Use the INVOKE statement to call your procedure and pass stack
;;			parameters. Create a PROTO declaration for CountMatches. Save and restore any registers (other
;;			than EAX) changed by your procedure.
;;	Date:		12/2
;;	
;;	Program Change Log
;;	==================
;;	Name		Date		Description
;;	Marco		12/2		Create baseline for counting.asm
;;

INCLUDE Irvine32.inc

.data
array1 DWORD -10,10,20
array2 DWORD -14,12,0
array3 DWORD -100,0,100,200
array4 DWORD -100,10,100,200
diff DWORD 4
msg1 BYTE "The margin is plus or minus ",0
msg2 BYTE "The arrays {",0
msg3 BYTE "} and {",0
msg4 BYTE "} contain ",0
msg5 BYTE " near matches.",0
comma BYTE ",",0
period BYTE ".",0

.code
CountNearMatches PROTO, 
	arrayPtr1:PTR DWORD, 
	arrayPtr2:PTR DWORD, 
	arraySize:DWORD, 
	margin:DWORD

main PROC
	popad
	mov edx,OFFSET msg1
	call WriteString
	mov eax,diff
	call writeInt
	mov edx,OFFSET period
	call writeString
	call crlf
	mov edx,OFFSET msg2
	call WriteString
	mov esi,OFFSET array1
	mov ecx,0
L1:
	mov eax,[esi]
	call WriteInt
	add esi,4
	mov edx,OFFSET comma
	inc ecx
	cmp ecx,LENGTHOF array1
	je Skip1
	call writeString
Skip1:
	cmp ecx,LENGTHOF array1
	jl L1
	mov edx,OFFSET msg3
	call WriteString
	mov esi,OFFSET array2
	mov ecx,0
L2:
	mov eax,[esi]
	call WriteInt
	add esi,4
	mov edx,OFFSET comma
	inc ecx
	cmp ecx,LENGTHOF array2
	je Skip2
	call writeString
Skip2:
	cmp ecx,LENGTHOF array2
	jl L2
	mov edx,OFFSET msg4
	call writeString
	invoke CountNearMatches, OFFSET array1, OFFSET array2, LENGTHOF array1, diff
	call writeInt
	mov edx,OFFSET msg5
	call writeString
	call crlf
	pushad

	popad
	mov edx,OFFSET msg2
	call WriteString
	mov esi,OFFSET array3
	mov ecx,0
L3:
	mov eax,[esi]
	call WriteInt
	add esi,4
	mov edx,OFFSET comma
	inc ecx
	cmp ecx,LENGTHOF array3
	je Skip3
	call writeString
Skip3:
	cmp ecx,LENGTHOF array3
	jl L3
	mov edx,OFFSET msg3
	call WriteString
	mov esi,OFFSET array4
	mov ecx,0
L4:
	mov eax,[esi]
	call WriteInt
	add esi,4
	mov edx,OFFSET comma
	inc ecx
	cmp ecx,LENGTHOF array4
	je Skip4
	call writeString
Skip4:
	cmp ecx,LENGTHOF array4
	jl L4
	mov edx,OFFSET msg4
	call writeString
	invoke CountNearMatches, OFFSET array3, OFFSET array4, LENGTHOF array3, diff
	call writeInt
	mov edx,OFFSET msg5
	call writeString
	call crlf
	pushad

	exit
main ENDP

CountNearMatches PROC USES esi edi ebx ecx edx, 
	arrayPtr1:PTR DWORD, 
	arrayPtr2:PTR DWORD, 
	arraySize:DWORD, 
	margin:DWORD
	LOCAL count:DWORD

	mov count,0
	mov esi,arrayPtr1
	mov edi,arrayPtr2
	mov ecx,arraySize
L1:
	mov eax,[esi]
	mov ebx,[edi]
	cmp eax,ebx
	jg Subtraction
	mov edx,eax
	mov eax,ebx
	mov ebx,edx
Subtraction:
	sub eax,ebx
	mov edx,margin
	cmp eax,edx
	jg Reset
	mov eax,1
	add count,eax
Reset:
	add esi,4
	add edi,4
	loop L1
	mov eax,count
	ret
CountNearMatches ENDP
END main
