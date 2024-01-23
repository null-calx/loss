	[org 0x7C00]

;;; int 0x13

;;; what disk we want to read?
	mov	[disk_num], dl

;;; CHS address? (cylinder, head, sector)
;;; C = 0, H = 0, S = 2 (S starts with 1)

;;; how many sectors?
;;; 1

;;; where to load them?
;;; 0x7E00

	mov	ah, 2
	mov	al, 1		; number of sectors
	mov	ch, 0		; C
	mov	cl, 2		; S
	mov	dh, 0		; H
	mov	dl, [disk_num]	; drive number
	;; es:bx = 0x7E00
	;; es * 16 + bx = 0x7E00
	mov	bx, 0
	mov	es, bx
	mov	bx, 0x7E00
	int	0x13

	mov	ah, 0x0E
	mov	al, [0x7E00]
	int	0x10

	jmp $

disk_num:
	db 0

	times 510 - ($-$$) db 0
	db 0x55, 0xAA

	times 512 db 'A'
