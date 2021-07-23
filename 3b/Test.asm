; Structures (ShowTime.ASM)
INCLUDE Irvine32.inc
.data
sysTime SYSTEMTIME <>
XYPos COORD <10,5>
consoleHandle DWORD ?
colonStr BYTE ":",0

.code
main PROC
; Get the standard output handle for the Win32 Console.
INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov consoleHandle,eax
; Set the cursor position and get the system time.
INVOKE SetConsoleCursorPosition, consoleHandle, XYPos
INVOKE GetLocalTime, ADDR sysTime
; Display the system time (hh:mm:ss).
movzx eax,sysTime.wHour ; hours
call WriteDec
mov edx,OFFSET colonStr ; ":"
call WriteString
movzx eax,sysTime.wMinute ; minutes
call WriteDec
call WriteString
movzx eax,sysTime.wSecond ; seconds
call WriteDec
call Crlf
call WaitMsg ; "Press any key..."
exit
main ENDP
END main