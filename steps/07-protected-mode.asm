	[org 0x7C00]

	mov	[BOOT_DISK], dl

	CODE_SEG equ code_descriptor - GDT_start
	DATA_SEG equ data_descriptor - GDT_start

	cli
	lgdt	[GDT_descriptor]
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	jmp	CODE_SEG:start_protected_mode

	jmp	$

;;; descriptor:
;;;   list of properties of a segment

;;; segment descriptor

	;; (location, size) = (base, limit)
	;; base (32 bit), limit (24 bit)
	;; base = 0, limit = max

	;; ppt:
	;; present = 1 for used segments
	;; privilege = 00 | 01 | 10 | 11 (00 for highest)
	;; type = 1 for code or data segment

	;; type flags: (code segments)
	;; (code?, conforming?, readable?, accessed!)
	;; conforming: should segment be executable by lower privileges
	;; readable: allows us to read constants
	;; accessed: set to 1 by cpu, when accessing, we set it to 0

	;; type flags: (data segments)
	;; (code?, direction?, writable?, accessed!)
	;; direction: expand down segment

	;; other flags:
	;; (granularity, uses 32 bit memory?, 64 bits?, AVL)
	;; granularity => limit *= 0x1000

;;; this should be at the end of real mode code
GDT_start:
null_descriptor:
	dd 0			; four times 0000 0000
	dd 0			; four times 0000 0000
code_descriptor:
	;; base: 0 (32 bits)
	;; limit: 0xFFFFF (20 bits)
	;; ppt: 1 00 1 (4 bits)
	;; type flags: 1010 (4 bits)
	;; other flags: 1100 (4 bits)
	dw 0xFFFF		; first 16 bits of limit
	dw 0			; first 24 bits of base
	db 0			; 16 bits + 8 bits = 24 bits
	db 0b10011010		; ppt, type flags
	db 0b11001111		; other flags + last 4 bits of limit
	db 0			; last 8 bits of base
data_descriptor:
	dw 0xFFFF
	dw 0
	db 0
	db 0b10010010
	db 0b11001111
	db 0
GDT_end:

GDT_descriptor:
	dw GDT_end - GDT_start - 1 ; size
	dd GDT_start		; start

	[bits 32]
start_protected_mode:
	mov	al, 'A'
	mov	ah, 0x0F
	mov	[0xB8000], ax

	jmp	$

BOOT_DISK:
	db 0

	times 510 - ($-$$) db 0
	db 0x55, 0xAA
