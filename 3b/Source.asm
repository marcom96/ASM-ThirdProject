;;	Author:		Marco Martinez
;;	Filename:		determineLargest.asm
;;	Version:		1.0
;;	Description:	Create a procedure named FindLargest that receives two parameters: a pointer to a signed
;;				doubleword array, and a count of the array’s length. The procedure must return the value of
;;				the largest array member in EAX. Use the PROC directive with a parameter list when declaring
;;				the procedure. Preserve all registers (except EAX) that are modified by the procedure.
;;				Write a test program that calls FindLargest and passes three different arrays of different
;;				lengths. Be sure to include negative values in your arrays. Create a PROTO declaration for
;;				FindLargest.
;;	Date:		12/2
;;	
;;	Program Change Log 
;;	==================
;;	Name		Date		Description
;;	Marco	12/2		Create baseline for findLargest.asm
;;

INCLUDE Irvine32.inc

.data
array1 DWORD 0,10,20
array2 DWORD -10,0,10
array3 DWORD 400,200,3000,-2000,40
prompt BYTE "The highest number is ",0

.code
FindLargest PROTO, arrayPtr:PTR DWORD, arraySize:DWORD

main PROC

	invoke FindLargest, OFFSET array1, LENGTHOF array1
	mov edx, OFFSET prompt
	call WriteString
	call WriteInt 
	call Crlf
	call Crlf
	invoke FindLargest, OFFSET array2, LENGTHOF array2
	mov edx, OFFSET prompt
	call WriteString
	call WriteInt
	call Crlf
	call Crlf
	invoke FindLargest, OFFSET array3, LENGTHOF array3
	mov edx, OFFSET prompt
	call WriteString
	call WriteInt
	call Crlf
	call Crlf

	exit
main ENDP

FindLargest PROC USES ecx,
	arrayPtr:PTR DWORD,
	arraySize:DWORD
	mov esi,arrayPtr
	mov eax,[esi]
	mov ecx,arraySize
	cmp ecx,1
	je Conclude
L1:
	cmp eax,[esi]
	jge GreaterOrEquals
	mov eax,[esi]
GreaterOrEquals:
	add esi,4
	loop L1
Conclude:
	ret
FindLargest ENDP
END main