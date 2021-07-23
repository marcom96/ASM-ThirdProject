;;	Author:		Marco Martinez
;;	Filename:		IndexedSortAndSearch.asm
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
;;	Marco	12/8		Create baseline for IndexedSortAndSearch.asm
;;

INCLUDE Irvine32.inc


.data
BEGIN_DEFINE BYTE	"					SEARCH AND SORT TEST ",0
BORDER_DEFINE BYTE	"===============================================================================================",0
array1 DWORD 40,-10,400,20,-300,12,10,0
index1 DWORD 0,1,2,3,4,5,6,7
length1 DWORD LENGTHOF array1
array2 DWORD 0,-10,-20,-30,50,100,200,300,-100,-80,1000,2000,-5000,60,70,550,-550,-300,-900,1010,2300
index2 DWORD 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
length2 DWORD LENGTHOF array2
array3 DWORD 50,40,30,20,10
index3 DWORD 0,1,2,3,4
length3 DWORD LENGTHOF array3
key1 DWORD -10
key2 DWORD 1000
key3 DWORD 0
location1 DWORD ?
location2 DWORD ?
location3 DWORD ?
msg1 BYTE "Unsorted array: ",0
msg2 BYTE "Sorted array: ",0
msg3 BYTE "Search found the value ",0
msg4 BYTE " at position ",0

.code
BubbleSort PROTO,
	pArray:PTR DWORD,
	pIndex:PTR DWORD,
	Count:DWORD

LinearSearch PROTO,
	pArray:PTR DWORD, 
	pIndex:PTR DWORD,
	Count:DWORD,
	key:DWORD

DisplayArray PROTO,
	pArray:PTR DWORD,
	pIndex:PTR DWORD,
	Count:DWORD

DisplaySearchResult PROTO,
	key:DWORD,
	location:DWORD

main PROC

	mov ecx,0
Begin:
	pushad
	call crlf
	mov edx,OFFSET BEGIN_DEFINE
	add ecx,1
	mov eax,ecx
	call writeString
	call writeInt
	call crlf
	popad
	push edx
	mov edx,OFFSET BORDER_DEFINE
	call writeString
	call crlf
	pop edx

	pushad
	mov edx,OFFSET msg1
	call writeString
	INVOKE DisplayArray,ADDR array1,ADDR index1,length1
	INVOKE BubbleSort,ADDR array1,ADDR index1,length1
	mov edx,OFFSET msg2
	call writeString
	INVOKE DisplayArray,ADDR array1,ADDR index1,length1
	popad

	pushad
	INVOKE LinearSearch,ADDR array1,ADDR index1,length1,key1
	mov edx,OFFSET msg3
	call writeString
	mov edx,OFFSET msg4
	mov location1,eax
	INVOKE DisplaySearchResult,key1,location1
	call crlf
	popad

	pushad
	mov edx,OFFSET msg1
	call writeString
	INVOKE DisplayArray,ADDR array2,ADDR index2,length2
	INVOKE BubbleSort,ADDR array2,ADDR index2,length2
	mov edx,OFFSET msg2
	call writeString
	INVOKE DisplayArray,ADDR array2,ADDR index2,length2
	popad

	pushad
	INVOKE LinearSearch,ADDR array2,ADDR index2,length2,key2
	mov edx,OFFSET msg3
	call writeString
	mov edx,OFFSET msg4
	mov location2,eax
	INVOKE DisplaySearchResult,key2,location2
	call crlf
	popad

	pushad
	mov edx,OFFSET msg2
	call writeString
	INVOKE DisplayArray,ADDR array3,ADDR index3,length3
	INVOKE BubbleSort,ADDR array3,ADDR index3,length3
	mov edx,OFFSET msg2
	call writeString
	INVOKE DisplayArray,ADDR array3,ADDR index3,length3
	popad

	pushad
	INVOKE LinearSearch,ADDR array3,ADDR index3,length3,key3
	mov edx,OFFSET msg3
	call writeString
	mov edx,OFFSET msg4
	mov location3,eax
	INVOKE DisplaySearchResult,key3,location3
	call crlf
	call crlf
	popad

	add key1,10
	add key2,10
	add key3,10
	inc ecx
	cmp ecx,3
	jl Begin

	exit
main ENDP

BubbleSort PROC USES eax ebx ecx edx esi edi,
	pArray:PTR DWORD, ; pointer to array
	pIndex:PTR DWORD,
	Count:DWORD ; array size
	LOCAL swap:BYTE
	mov swap,0
	mov ecx,Count
	dec ecx ; decrement count by 1
L1: 
	push ecx ; save outer loop count
	mov edi,pIndex
	mov ebx,[edi]
	shl ebx,2
L2: 
	mov esi,pArray
	add esi,ebx
	mov eax,[esi]
	mov esi,pArray
	mov ebx,[edi+4]
	shl ebx,2
	mov esi,pArray
	add esi,ebx
	cmp [esi],eax; compare a pair of values
	jg L3
	mov ebx,[edi+4]
	xchg ebx,[edi]
	mov [edi+4],ebx
	inc swap
L3: 
	add edi,4
	mov ebx,[edi]
	shl ebx,2
	loop L2 ; inner loop
	cmp swap,0
	je l4
	mov swap,0
	pop ecx ; retrieve outer loop count
	loop L1 ; else repeat outer loop
L4: 
	ret
BubbleSort ENDP

LinearSearch PROC USES ebx ecx edx esi edi,
	pArray:PTR DWORD, ; pointer to array
	pIndex:PTR DWORD,
	Count:DWORD, ; array size
	key:DWORD
	mov eax,0
	mov edx,0
	mov ecx,Count
	mov edi,pIndex
	mov ebx,[edi]
	shl ebx,2
L1:
	mov esi,pArray
	add esi,ebx
	mov eax,[esi]
	cmp eax,key
	je Found
	inc edx
	add edi,4
	mov ebx,[edi]
	shl ebx,2
	dec ecx
	cmp ecx,0
	jg L1
	mov eax,-1
	jmp Return
Found:
	mov eax,edx
Return:
	ret
LinearSearch ENDP

DisplayArray PROC USES eax ebx ecx edx esi edi,
	pArray:PTR DWORD,
	pIndex:PTR DWORD,
	Count:DWORD		

	mov ecx,Count
	mov edi,pIndex
	mov ebx,[edi]
	shl ebx,2
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

DisplaySearchResult PROC USES eax ebx ecx esi edi,
	key:DWORD,
	location:DWORD,
	
	mov eax,key
	call writeInt
	call writeString
	mov eax,location
	call writeInt
	call crlf
	mov edx,0
	ret
DisplaySearchResult ENDP
end main