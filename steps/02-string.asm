	[org 0x7C00]

	mov ah, 0x0E		; switch to teletype mode
	mov bx, str

loop:
	mov al, [bx]
	cmp al, 0
	je exit

	int 0x10

	inc bx
	jmp loop

exit:	
	jmp $

str:	db "Hello, world!", 0

	times 510 - ($-$$) db 0
	db 0x55, 0xAA
