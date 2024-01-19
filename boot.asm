	[org 0x7C00]

	mov bp, 0x8000
	mov sp, bp

	mov bx, str
	call print_string

	jmp $

str:	db "Hello, world!", 0

print_string:
	mov ah, 0x0E
print_loop:	
	mov al, [bx]
	cmp al, 0
	je print_string_ret
	int 0x10
	inc bx
	jmp print_loop
print_string_ret:
	ret

	times 510 - ($-$$) db 0
	db 0x55, 0xAA
