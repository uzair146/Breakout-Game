
; -------------------------------------------------------------
; DATA SECTION
; -------------------------------------------------------------
line6:  db  1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,0,0,1,0,0,0,1,1,1,0,0,1,1,0,0,1,1,0,1,1,1,1,1,1
line7:  db  1,1,0,0,1,1,0,1,1,0,0,1,1,0,1,1,0,0,0,0,0,1,1,0,0,1,1,0,1,1,0,1,0,0,0,1,1,0,1,1,0,1,1,0,0,1,1,0,0,0,1,1,0,0
line8:  db  1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,0,0,0,0,1,1,0,1,1,0,1,1,0,0,1,1,0,0,0,1,1,0,0
line9:  db  1,1,0,0,1,1,0,1,1,0,0,1,1,0,1,1,0,0,0,0,0,1,1,0,0,1,1,0,1,1,0,1,0,0,0,1,1,0,1,1,0,1,1,0,0,1,1,0,0,0,1,1,0,0
line10: db  1,1,1,1,1,1,0,1,1,0,0,1,1,0,1,1,1,1,1,1,0,1,1,0,0,1,1,0,1,1,0,0,1,0,0,0,1,1,1,0,0,0,1,1,1,1,0,0,0,0,1,1,0,0

msgHelpHint:   db 'PRESS H FOR HELP'
msgCredits:    db 'MADE BY UZAIR HUSSAIN AND SAQIB ALI'
msgStartHint:  db 'PRESS ENTER TO START'
msgRulesTitle: db 'RULES AND REGULATIONS'
msgRule1:      db '=> PRESS ENTER TO START'
msgRule2:      db '=> PRESS ESC TO ESCAPE'
msgRule3:      db '=> PRESS H FOR HELP'
msgRule4:      db '=> PRESS -> FOR RIGHT MOVEMENT'
msgRule5:      db '=> PRESS <- FOR LEFT MOVEMENT'
msgRule6:      db '=> 3 LIVES PER GAME'
msgRuleBreak:  db '=> break'

; --- Scoring Legend Strings ---
msgPtsRed:     db '= 40 POINTS'    ; Red
msgPtsMag:     db '= 30 POINTS'    ; Magenta
msgPtsGrn:     db '= 20 POINTS'    ; Green
msgPtsYel:     db '= 10 POINTS'    ; Yellow

; -------------------------------------------------------------
; PROCEDURE: RunMenu
; -------------------------------------------------------------
RunMenu:
	jmp MenuDrawMainScreen

; -------------------------------------------------------------
; SECTION: HELP SCREEN
; -------------------------------------------------------------
MenuShowHelp:
	call MenuClearScreen

	; --- Draw Top/Bottom Horizontal Borders ---
	mov ax, 0
	push ax
	mov ax, 160
	push ax
	mov ax, 0x4F2A
	push ax
	mov ax, 0x4F20
	push ax
	call MenuDisplayHorizontal

	mov ax, 3680
	push ax
	mov ax, 3840
	push ax
	mov ax, 0x4F2A
	push ax
	mov ax, 0x4F20
	push ax
	call MenuDisplayHorizontal

	; --- Draw Left/Right Vertical Borders ---
	mov ax, 160
	push ax
	mov ax, 3840
	push ax
	mov ax, 0x1F20
	push ax
	mov ax, 0x1F2A
	push ax
	call MenuDisplayVertical

	mov ax, 158
	push ax
	mov ax, 3838
	push ax
	mov ax, 0x1F2A
	push ax
	mov ax, 0x1F2A
	push ax
	call MenuDisplayVertical

	; --- Draw Header Separator ---
	mov ax, 240
	push ax
	mov ax, 3760
	push ax
	mov ax, 0x0F3A
	push ax
	mov ax, 0x0F3A
	push ax
	call MenuDisplayVertical

	; --- PRINT TEXT INSTRUCTIONS ---
	mov ax, msgRulesTitle
	push ax
	mov ax, 21
	push ax
	push byte 0x0F
	mov ax, 220
	push ax
	call MenuPrintString

	mov ax, msgRule1
	push ax
	mov ax, 23
	push ax
	push byte 0x0E
	mov ax, 650
	push ax
	call MenuPrintString

	mov ax, msgRule2
	push ax
	mov ax, 22
	push ax
	push byte 0x0E
	mov ax, 1130
	push ax
	call MenuPrintString

	mov ax, msgRule3
	push ax
	mov ax, 19
	push ax
	push byte 0x0E
	mov ax, 1610
	push ax
	call MenuPrintString

	mov ax, msgRule4
	push ax
	mov ax, 30
	push ax
	push byte 0x0E
	mov ax, 2090
	push ax
	call MenuPrintString

	mov ax, msgRule5
	push ax
	mov ax, 29
	push ax
	push byte 0x0E
	mov ax, 2570
	push ax
	call MenuPrintString

	mov ax, msgRule6
	push ax
	mov ax, 19
	push ax
	push byte 0x0E
	mov ax, 730
	push ax
	call MenuPrintString

	; --- "break" TEXT ---
	mov ax, msgRuleBreak
	push ax
	mov ax, 8
	push ax
	push byte 0x0E
	mov ax, 1210
	push ax
	call MenuPrintString

	mov ax, msgRuleBreak
	push ax
	mov ax, 8
	push ax
	push byte 0x0E
	mov ax, 1690
	push ax
	call MenuPrintString

	mov ax, msgRuleBreak
	push ax
	mov ax, 8
	push ax
	push byte 0x0E
	mov ax, 2170
	push ax
	call MenuPrintString

	mov ax, msgRuleBreak
	push ax
	mov ax, 8
	push ax
	push byte 0x0E
	mov ax, 2650
	push ax
	call MenuPrintString

	; --- DRAW COLORED BLOCKS ---
	; 1. RED
	mov ax, 1234
	push ax
	mov ax, 1244
	push ax
	mov ax, 0x4F20
	push ax
	mov ax, 0x4F20
	push ax
	call MenuDisplayHorizontal

	; 2. MAGENTA
	mov ax, 1714
	push ax
	mov ax, 1724
	push ax
	mov ax, 0x5F20
	push ax
	mov ax, 0x5F20
	push ax
	call MenuDisplayHorizontal

	; 3. GREEN
	mov ax, 2194
	push ax
	mov ax, 2204
	push ax
	mov ax, 0x2F20
	push ax
	mov ax, 0x2F20
	push ax
	call MenuDisplayHorizontal

	; 4. YELLOW
	mov ax, 2674
	push ax
	mov ax, 2684
	push ax
	mov ax, 0x6F20
	push ax
	mov ax, 0x6F20
	push ax
	call MenuDisplayHorizontal

	; --- DRAW POINTS TEXT ---
	mov ax, msgPtsRed
	push ax
	mov ax, 11
	push ax
	push byte 0x0E
	mov ax, 1250
	push ax
	call MenuPrintString

	mov ax, msgPtsMag
	push ax
	mov ax, 11
	push ax
	push byte 0x0E
	mov ax, 1730
	push ax
	call MenuPrintString

	mov ax, msgPtsGrn
	push ax
	mov ax, 11
	push ax
	push byte 0x0E
	mov ax, 2210
	push ax
	call MenuPrintString

	mov ax, msgPtsYel
	push ax
	mov ax, 11
	push ax
	push byte 0x0E
	mov ax, 2690
	push ax
	call MenuPrintString

	HelpKeyLoop:
		mov ah, 00h
		int 16h

		cmp al, 27          ; ESC Key
		jne CheckEnterHelp
		jmp MenuDrawMainScreen

	CheckEnterHelp:
		cmp al, 13          ; ENTER Key
		jne HelpKeyLoop
		jmp ExitMenuHandler

; -------------------------------------------------------------
; SECTION: MAIN MENU SCREEN
; -------------------------------------------------------------
MenuDrawMainScreen:
	call MenuClearScreen

	; --- Main Borders ---
	mov ax, 0
	push ax
	mov ax, 160
	push ax
	mov ax, 0x405C
	push ax
	mov ax, 0x402F
	push ax
	call MenuDisplayHorizontal

	mov ax, 3680
	push ax
	mov ax, 3840
	push ax
	mov ax, 0x405C
	push ax
	mov ax, 0x402F
	push ax
	call MenuDisplayHorizontal

	mov ax, 160
	push ax
	mov ax, 3840
	push ax
	mov ax, 0x405C
	push ax
	mov ax, 0x402F
	push ax
	call MenuDisplayVertical

	mov ax, 158
	push ax
	mov ax, 3838
	push ax
	mov ax, 0x405C
	push ax
	mov ax, 0x402F
	push ax
	call MenuDisplayVertical

	; --- Main Messages ---
	mov ax, msgHelpHint
	push ax
	mov ax, 16
	push ax
	push byte 0x5F
	mov ax, 2784
	push ax
	call MenuPrintString

	mov ax, msgCredits
	push ax
	mov ax, 35
	push ax
	push byte 0x0F
	mov ax, 3608
	push ax
	call MenuPrintString

	mov ax, msgStartHint
	push ax
	mov ax, 20
	push ax
	push byte 0x6F
	mov ax, 2460
	push ax
	call MenuPrintString

	; --- Draw Pixel Art (Logo) ---
	mov ax, line6
	push ax
	mov ax, 54
	push ax
	mov ax, 986
	push ax
	call MenuDrawPixels

	mov ax, line7
	push ax
	mov ax, 54
	push ax
	mov ax, 1146
	push ax
	call MenuDrawPixels

	mov ax, line8
	push ax
	mov ax, 54
	push ax
	mov ax, 1306
	push ax
	call MenuDrawPixels

	mov ax, line9
	push ax
	mov ax, 54
	push ax
	mov ax, 1466
	push ax
	call MenuDrawPixels

	mov ax, line10
	push ax
	mov ax, 54
	push ax
	mov ax, 1626
	push ax
	call MenuDrawPixels

	MainKeyLoop:
		mov ah, 00h
		int 16h

		cmp al, 13          ; ENTER Key
		jne CheckH
		jmp ExitMenuHandler

	CheckH:
		cmp al, 'h'
		je MenuShowHelp
		cmp al, 'H'
		je MenuShowHelp

		cmp al, 27          ; ESC Key
		jne MainKeyLoop
		jmp ExitToDOS

ExitToDOS:
	mov ax, 0x4c00
	int 0x21

ExitMenuHandler:
	call MenuClearScreen
	ret

; -------------------------------------------------------------
; HELPER PROCEDURES
; -------------------------------------------------------------

; --- MenuClearScreen ---
MenuClearScreen:
	push bp
	mov bp, sp
	push ax
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov ax, 0x0720      ; 07 = Light Grey on Black, 20 = Space

	ClearLoop:
		mov [es:di], ax
		add di, 2
		cmp di, 4000
		jne ClearLoop

	pop di
	pop es
	pop ax
	pop bp
	ret

; --- MenuDisplayHorizontal ---
MenuDisplayHorizontal:
	push bp
	mov bp, sp
	push ax
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, [bp+10]     ; Start Position

	DrawHorizLoop:
		test di, 2
		jz HorizEvenPos

		HorizOddPos:
			mov ax, [bp+6]
			jmp WriteHoriz

		HorizEvenPos:
			mov ax, [bp+4]

		WriteHoriz:
			mov [es:di], ax
			add di, 2
			cmp di, [bp+8]
			jne DrawHorizLoop

	pop di
	pop es
	pop ax
	pop bp
	ret 8

; --- MenuDisplayVertical ---
MenuDisplayVertical:
	push bp
	mov bp, sp
	push ax
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, [bp+10]     ; Start Position

	DrawVertLoop:
		test di, 2
		jz VertEvenPos

		VertOddPos:
			mov ax, [bp+6]
			jmp WriteVert

		VertEvenPos:
			mov ax, [bp+4]

		WriteVert:
			mov [es:di], ax
			add di, 160
			cmp di, [bp+8]
			jne DrawVertLoop

	pop di
	pop es
	pop ax
	pop bp
	ret 8

; --- MenuPrintString ---
MenuPrintString:
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
	mov di, [bp+4]      ; Screen Position
	mov cx, [bp+8]      ; String Length
	mov bx, [bp+10]     ; String Source Address
	mov ah, [bp+6]      ; Color Attribute

	MsgCharLoop:
		mov al, [bx+si]
		inc si
		mov [es:di], ax
		add di, 2
		loop MsgCharLoop

	pop si
	pop cx
	pop bx
	pop di
	pop es
	pop ax
	pop bp
	ret 8

; --- MenuDrawPixels ---
MenuDrawPixels:
	push bp
	mov bp, sp
	push ax
	push es
	push di
	push si
	push cx
	push bx

	mov ax, 0xb800
	mov es, ax
	mov si, 0
	mov bx, [bp+8]      ; Source Array
	mov cx, [bp+6]      ; Length
	mov di, [bp+4]      ; Screen Position

	LogoPixelLoop:
		cmp si, cx
		je LogoDone

		mov al, [bx+si]
		cmp al, 0
		je LogoDrawBlack
		cmp al, 1
		je LogoDrawWhite

		LogoDrawBlack:
			mov ah, 0x0F
			mov al, 0x20
			jmp WriteLogoPixel

		LogoDrawWhite:
			mov ah, 0x1F
			mov al, 0x20

		WriteLogoPixel:
			mov [es:di], ax
			inc si
			add di, 2
			jmp LogoPixelLoop

	LogoDone:
		pop bx
		pop cx
		pop si
		pop di
		pop es
		pop ax
		pop bp
		ret 6
