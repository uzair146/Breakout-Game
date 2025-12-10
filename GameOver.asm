
; --- Data Section ---
msgGameText:   db 'GAME'
msgOverText:   db 'OVER'
msgExitHint:   db 'PRESS ESC TO EXIT'
msgFinalScore:   db 'FINAL SCORE: '
finalScoreNum:   db '00000',0

; -------------------------------------------------------------
; PROCEDURE: RunGameOver
; -------------------------------------------------------------
RunGameOver:
	call GOClearScreen

	; --- Draw Top Horizontal Border ---
	mov ax, 0
	push ax             ; Start
	mov ax, 160
	push ax             ; End
	mov ax, 0x7F20      ; Grey Background, Space
	push ax
	mov ax, 0x0F2A      ; Black Background, Green '*'
	push ax
	call GODrawHorizontal

	; --- Draw Bottom Horizontal Border ---
	mov ax, 3680
	push ax
	mov ax, 3840
	push ax
	mov ax, 0x7F20
	push ax
	mov ax, 0x0F2A
	push ax
	call GODrawHorizontal

	; --- Draw Left Vertical Border ---
	mov ax, 160
	push ax
	mov ax, 3680
	push ax
	mov ax, 0x705C      ; Grey BG, '\'
	push ax
	mov ax, 0x702F      ; Grey BG, '/'
	push ax
	call GODrawVertical

	; --- Draw Right Vertical Border ---
	mov ax, 318
	push ax
	mov ax, 3838
	push ax
	mov ax, 0x705C
	push ax
	mov ax, 0x702F
	push ax
	call GODrawVertical

	; --- Print "GAME" ---
	mov ax, msgGameText
	push ax
	mov ax, 4           ; Length
	push ax
	push byte 0x04      ; Red Color
	mov ax, 1996        ; Position 
	push ax
	call GOPrintString

	; --- Print "OVER" ---
	mov ax, msgOverText
	push ax
	mov ax, 4
	push ax
	push byte 0x04
	mov ax, 2156
	push ax
	call GOPrintString
        ;print final score
        call PrintFinalScore

	; --- Print Hint ---
	mov ax, msgExitHint
	push ax
	mov ax, 17
	push ax
	push word 0x8F      ; Blinking White
	mov ax, 3000
	push ax
	call GOPrintString

	call Sound_GameOver

	GOWaitKey:
		mov ah, 00h
		int 16h
		cmp al, 27      ; ESC Key
		je GOExit
		cmp al, 13      ; ENTER Key
		je GOExit
		jmp GOWaitKey

	GOExit:
		ret

; -------------------------------------------------------------
; HELPER PROCEDURES
; -------------------------------------------------------------

; --- GOClearScreen ---
GOClearScreen:
	push bp
	mov bp, sp
	push ax
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov ax, 0x0F20      ; Black BG, White Text, Space

	GOClearLoop:
		mov [es:di], ax
		add di, 2
		cmp di, 4000
		jne GOClearLoop

	pop di
	pop es
	pop ax
	pop bp
	ret

; --- GODrawHorizontal ---
GODrawHorizontal:
	push bp
	mov bp, sp
	push ax
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, [bp+10]     ; Start

	GOHorizLoop:
		test di, 2
		jz GOHorizEven

		GOHorizOdd:
			mov ax, [bp+6]
			jmp GOWriteHoriz

		GOHorizEven:
			mov ax, [bp+4]

		GOWriteHoriz:
			mov [es:di], ax
			add di, 2
			cmp di, [bp+8]
			jne GOHorizLoop

	pop di
	pop es
	pop ax
	pop bp
	ret 8

; --- GODrawVertical ---
GODrawVertical:
	push bp
	mov bp, sp
	push ax
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, [bp+10]     ; Start

	GOVertLoop:
		test di, 2
		jz GOVertEven

		GOVertOdd:
			mov ax, [bp+6]
			jmp GOWriteVert

		GOVertEven:
			mov ax, [bp+4]

		GOWriteVert:
			mov [es:di], ax
			add di, 160     ; Next Row
			cmp di, [bp+8]
			jne GOVertLoop

	pop di
	pop es
	pop ax
	pop bp
	ret 8

; --- GOPrintString ---
GOPrintString:
	push bp
	mov bp, sp
	push ax
	push es
	push di
	push bx
	push cx
	push si

	mov si, 0
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+4]      ; Position
	mov cx, [bp+8]      ; Length
	mov bx, [bp+10]     ; String Offset
	mov ah, [bp+6]      ; Attribute

	GOMsgLoop:
		mov al, [bx+si]
		inc si
		mov [es:di], ax
		add di, 2
		loop GOMsgLoop

	pop si
	pop cx
	pop bx
	pop di
	pop es
	pop ax
	pop bp
	ret 8
PrintFinalScore:
	pusha
	
	mov ax, [score]                  
	mov di, finalScoreNum + 4       
	mov bx, 10
	mov cx, 5

ConvertLoop:
	xor dx, dx
	div bx
	add dl, '0'
	mov [di], dl
	dec di
	loop ConvertLoop

	; Print "FINAL SCORE: 01230"
	mov ax, msgFinalScore
	push ax
	mov ax, 18                       ; total length (13 + 5)
	push ax
	push byte 0x03                  ; Bright red color
	mov ax, 2462                   ; position 
	push ax
	call GOPrintString

	popa
	ret
