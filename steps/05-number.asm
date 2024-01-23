	[org 0x7C00]

	mov	bp, 0x8000
	mov	sp, bp

	mov	bx, str
	call	print_string
	mov	bx, newline
	call	print_string

	mov	si, 0xFFFF
number_loop:
	inc	si
	call	print_number
	mov	bx, newline
	call	print_string
	cmp	si, 0xFFFF
	jne	number_loop

	jmp	$

str:	db "Hello, world!", 0
newline:db 10, 13, 0
space:	db ' ', 0
print_number_buffer:
	times 6 db 0

;;; si = byte
print_number:
	mov	bx, print_number_buffer + 5
	mov	ax, si
	mov	cx, 10
print_number_loop:
	dec	bx
	xor	dx, dx
	div	cx
	add	dl, '0'
	mov	[bx], dl
	cmp	ax, 0
	jne	print_number_loop

;;; bx = *cstring
print_string:
	mov	ah, 0x0E
print_string_loop:	
	mov	al, [bx]
	cmp	al, 0
	je	print_string_exit
	int	0x10
	inc	bx
	jmp	print_string_loop
print_string_exit:
	ret

	times 510 - ($-$$) db 0
	db 0x55, 0xAA
