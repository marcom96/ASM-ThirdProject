;;	Author:		Marco Martinez
;;	Filename:		IndexedBubbleSort.asm
;;	Version:		1.0
;;	Description:	Add a variable to the BubbleSort procedure in Section 9.5.1 that is set to 1 whenever a pair of 
;;				values is exchanged within the inner loop. Use this variable to exit the sort before its normal
;;				completion if you discover that no exchanges took place during a complete pass through the
;;				array. (This variable is commonly known as an exchange flag.)
;;	Date:		12/8
;;	
;;	Program Change Log
;;	==================
;;	Name		Date		Description
;;	Marco	12/8		Create baseline for IndexedBubbleSort.asm
;;

INCLUDE Irvine32.inc


.data
array DWORD 40,-10,400,20,-300,12,10,4
index DWORD 0,1,2,3,4,5,6,7
arrayLength DWORD LENGTHOF array

.code
BubbleSort PROTO,
	pArray:PTR DWORD,
	pIndex:PTR DWORD,
	Count:DWORD

DisplayArray PROTO,
	pArray:PTR DWORD,
	pIndex:PTR DWORD,
	Count:DWORD

main PROC 
	INVOKE DisplayArray,ADDR array,ADDR index,arrayLength
	INVOKE BubbleSort,ADDR array,ADDR index,arrayLength
	INVOKE DisplayArray,ADDR array,ADDR index,arrayLength
	exit
main ENDP

BubbleSort PROC USES eax ecx esi edi,
	pArray:PTR DWORD, ; pointer to array
	pIndex:PTR DWORD,
	Count:DWORD ; array size
	mov ecx,Count
	dec ecx ; decrement count by 1
L1: 
	push ecx ; save outer loop count
	mov edi,pIndex
L2: 
	mov esi,pArray
	mov ebx,0
	add esi,ebx
	mov eax,[esi] ; get array value
	cmp [esi+4],eax ; compare a pair of values
	jg L3 ; if [ESI] <= [ESI+4], no exchange
	mov eax,[edi]
	xchg eax,[edi+4] ; exchange the pair
	mov [edi],eax
L3: 
	add edi,4 ; move both pointers forward
	mov ebx,[edi]
	shl ebx,2
	loop L2 ; inner loop
	pop ecx ; retrieve outer loop count
	loop L1 ; else repeat outer loop
L4: 
	ret
BubbleSort ENDP

DisplayArray PROC USES eax ebx ecx edx esi edi,
	pArray:PTR DWORD,
	pIndex:PTR DWORD,
	Count:DWORD		

	mov ecx,Count
	mov edi,pIndex
	mov ebx,0
L1:
	mov esi,pArray
	add esi,ebx
	mov eax,[esi]
	call writeInt
	add edi,4
	mov ebx,[edi]
	shl ebx,2
	dec ecx
	cmp ecx,0
	jg L1
	call crlf
	ret
DisplayArray ENDP
end main