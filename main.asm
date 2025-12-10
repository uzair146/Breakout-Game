[org 0x0100]
	jmp MainEntry

	%include "menu.asm"
	%include "sound.asm"
	%include "GameOver.asm"

MainEntry:
	mov ax, 0x0003
	int 0x10

	call RunMenu

	; Hide Cursor
	mov ah, 0x01
	mov cx, 0x2607
	int 0x10

	jmp start

; ---------------------------------------------------------
; UI SECTION
; ---------------------------------------------------------
txtScore:	db 'SCORE:', 0
txtLevel:	db 'LEVEL:', 0
txtLives:	db 'LIVES:', 0

score:		dw 000
level:		dw 1
lives:		dw 3

; 0x0E = Yellow/Black, 0x1F = White/Blue, 0x1C = Red/Blue
colBorder:	db 0x0E
colHUDText:	db 0x1F
colHeart:	db 0x1C

customHeart:
	db 00h, 00h, 00h, 00h, 00h
	db 66h, 0FFh, 0FFh, 0FFh, 7Eh, 3Ch, 18h
	db 00h, 00h, 00h, 00h

LoadCustomHeart:
	pusha
	push cs
	pop es
	mov bp, customHeart
	mov cx, 1
	mov dx, 1
	mov bh, 16
	mov bl, 0
	mov ax, 0x1100
	int 0x10
	popa
	ret

DrawArcadeFrame:
	pusha
	mov ax, 0xB800
	mov es, ax
	mov ah, [colBorder]

	; Top Border
	mov al, 205
	mov di, 0
	mov cx, 80
	rep stosw

	; HUD Separator
	mov di, 320
	mov cx, 80
	rep stosw

	; Bottom Border
	mov di, 3840
	mov cx, 80
	rep stosw

	; Side Walls
	mov al, 186
	mov cx, 23
	mov di, 160
	
	SideLoop:
		mov [es:di], ax
		mov [es:di+158], ax
		add di, 160
		loop SideLoop

	; Corners
	mov di, 0
	mov byte [es:di], 201
	mov di, 158
	mov byte [es:di], 187
	mov di, 320
	mov byte [es:di], 204
	mov di, 478
	mov byte [es:di], 185
	mov di, 3840
	mov byte [es:di], 200
	mov di, 3998
	mov byte [es:di], 188
	popa
	ret

FillHUDBackground:
	pusha
	mov ax, 0xB800
	mov es, ax
	mov di, 162
	mov cx, 78
	mov ah, [colHUDText]
	mov al, ' '
	rep stosw
	popa
	ret

UpdateHUD:
	pusha

	; Score
	mov si, txtScore
	mov di, 166
	mov ah, [colHUDText]
	call PrintString
	mov ax, [score]
	mov di, 182
	call PrintNumber

	; Separator
	mov di, 204
	mov word [es:di], 0x1FB3

	; Level
	mov si, txtLevel
	mov di, 230
	mov ah, [colHUDText]
	call PrintString
	mov ax, [level]
	mov di, 244
	call PrintNumberTwoDigits

	; Separator
	mov di, 266
	mov word [es:di], 0x1FB3

	; Lives
	mov si, txtLives
	mov di, 288
	mov ah, [colHUDText]
	call PrintString

	; Erase existing hearts
	mov cx, 3
	mov di, 304
	mov ah, [colHUDText]
	mov al, ' '
	
	ClearHeartsLoop:
		mov [es:di], ax
		add di, 4
		loop ClearHeartsLoop

	; Draw remaining lives
	cmp word [lives], 0
	je HudDone
	
	mov cx, [lives]
	mov di, 304
	
	DrawLivesLoop:
		mov ax, 0xB800
		mov es, ax
		mov al, 1
		mov ah, [colHeart]
		mov [es:di], ax
		add di, 4
		loop DrawLivesLoop

	HudDone:
		popa
		ret

PrintString:
	pusha
	mov bx, 0xB800
	mov es, bx
	
	StrLoop:
		mov al, [si]
		cmp al, 0
		je StrEnd
		mov [es:di], ax
		inc si
		add di, 2
		jmp StrLoop
		
	StrEnd:
		popa
		ret

PrintNumber:
	pusha
	mov bx, 0xB800
	mov es, bx
	mov cx, 0
	mov bx, 10
	
	DivLoop:
		xor dx, dx
		div bx
		push dx
		inc cx
		cmp ax, 0
		jne DivLoop
		
	mov bx, 5
	sub bx, cx
	
	PadLoop:
		cmp bx, 0
		jle PopLoop
		mov al, '0'
		mov ah, [colHUDText]
		mov [es:di], ax
		add di, 2
		dec bx
		jmp PadLoop
		
	PopLoop:
		pop ax
		add al, '0'
		mov ah, [colHUDText]
		mov [es:di], ax
		add di, 2
		loop PopLoop
		
	popa
	ret

PrintNumberTwoDigits:
	pusha
	mov bx, 10
	xor dx, dx
	div bx
	add ax, '0'
	add dx, '0'
	mov bx, ax
	mov ax, 0xB800
	mov es, ax
	mov al, bl
	mov ah, [colHUDText]
	mov [es:di], ax
	mov al, dl
	mov [es:di+2], ax
	popa
	ret

; ---------------------------------------------------------
; BRICKS SECTION
; ---------------------------------------------------------
Colors:			db 0x04, 0x05, 0x06, 0x02
startRow:		dw 3
startCol:		dw 2
brickWidth:		dw 11
brickGap:		dw 0
rand:			dw 1234h

brickScanRowStart:	dw 3
brickScanRowEnd:	dw 6
brickScanColStart:	dw 1
brickScanColEnd:	dw 79
speedIncrement:		db 2

Random:
	push bx
	push dx
	mov ax, [rand]
	mov bx, 25173
	mul bx
	add ax, 13849
	mov [rand], ax
	mov al, ah
	and ax, 0x03
	pop dx
	pop bx
	ret

DrawBricksMain:
	pusha
	mov ax, 0xb800
	mov es, ax
	xor si, si
	mov dx, [startRow]
	
	RowLoop:
		cmp si, 4
		je DoneDrawing
		mov cx, 7
		mov di, [startCol]
		
		BrickLoop:
			push cx
			call Random
			push si
			xor ah, ah
			mov si, ax
			mov al, [Colors + si]
			pop si
			mov ah, al

			; Draw Brick
			mov cx, [brickWidth]
			
			DrawCharLoop:
				push ax
				push dx
				push di
				mov ax, dx
				mov bx, 80
				mul bx
				add ax, di
				shl ax, 1
				mov bx, ax
				pop di
				pop dx
				pop ax
				mov al, 219
				mov [es:bx], ax
				inc di
				loop DrawCharLoop

			add di, [brickGap]
			pop cx
			loop BrickLoop

		inc dx
		inc si
		jmp RowLoop
		
	DoneDrawing:
		popa
		ret

CheckLevelComplete:
	push es
	push bx
	push cx
	push dx
	push di
	mov ax, 0xB800
	mov es, ax
	mov dx, [brickScanRowStart]
	
	RowScanLoop:
		cmp dx, [brickScanRowEnd]
		jg LevelClear
		mov cx, [brickScanColStart]
		
		ColScanLoop:
			cmp cx, [brickScanColEnd]
			jg NextRow
			push dx
			push cx
			mov ax, dx
			mov bx, 80
			mul bx
			add ax, cx
			shl ax, 1
			mov di, ax
			pop cx
			pop dx
			mov al, [es:di]
			cmp al, 219
			je BricksFound
			inc cx
			jmp ColScanLoop
			
		NextRow:
			inc dx
			jmp RowScanLoop
			
	BricksFound:
		mov al, 0
		jmp DoneScan
		
	LevelClear:
		mov al, 1
		
	DoneScan:
		pop di
		pop dx
		pop cx
		pop bx
		pop es
		ret

LevelUpHandler:
	pusha
	inc word [level]
	mov word [lives], 3
	mov byte [ballLaunched], 0
	mov word [paddleX], 35

	; Reset ball manual coordinates
	mov word [ballX], 40
	mov word [ballY], 22

	; Increase speed
	mov al, [speedIncrement]
	sub byte [ballSpeed], al
	cmp byte [ballSpeed], 2
	jge SpeedSafe
	mov byte [ballSpeed], 2
	
	SpeedSafe:
		call Sound_LevelUp
		call clscr
		call DrawArcadeFrame
		call FillHUDBackground
		call UpdateHUD
		call DrawBricksMain
		call DrawPaddle
		popa
		ret

CheckBrickCollision:
	pusha
	mov si, 2
	
	CollisionLoop:
		xor bx, bx

		; Check Y-Axis
		mov ax, [ballY]
		add ax, [velY]
		mov cx, [ballX]
		call AttemptDestroy
		cmp al, 1
		jne CheckX
		neg word [velY]
		mov bx, 1

		CheckX:
			mov ax, [ballY]
			mov cx, [ballX]
			add cx, [velX]
			call AttemptDestroy
			cmp al, 1
			jne CheckLoopEnd
			neg word [velX]
			mov bx, 1

	CheckLoopEnd:
		cmp bx, 0
		je EndCollision
		dec si
		jnz CollisionLoop
		
	EndCollision:
		popa
		ret

ReportMiss:
	mov al, 0
	jmp ExitHelper

AttemptDestroy:
	push bx
	push dx
	push di
	push si
	push es

	push bx
	mov bx, cx
	call CalculateLocation
	pop bx

	mov dx, 0xB800
	mov es, dx
	mov dx, [es:di]
	cmp dl, 219
	jne ReportMiss

	mov bx, di			; BX = Hit Address

	; Scan Left to find blob start
	ScanLeft:
		mov ax, [es:di-2]
		cmp al, 219
		jne FoundBlobStart
		cmp ah, dh
		jne FoundBlobStart
		sub di, 2
		jmp ScanLeft

	FoundBlobStart:
		; Calculate distance and index
		mov ax, bx
		sub ax, di
		shr ax, 1
		push dx
		xor dx, dx
		mov cx, [brickWidth]
		div cx				; AX = Index

		; Calculate removal start
		mul cx
		shl ax, 1
		add di, ax

		; Erase brick
		mov cx, [brickWidth]
		
		EraseLoop:
			mov byte [es:di], ' '
			mov byte [es:di+1], 0
			add di, 2
			loop EraseLoop

	ConfirmHit:
		pop dx
		; Scoring based on color
		cmp dh, 0x04
		je Add40
		cmp dh, 0x05
		je Add30
		cmp dh, 0x02
		je Add20
		add word [score], 10
		jmp UpdateScoreVisual
		
		Add40:
			add word [score], 40
			jmp UpdateScoreVisual
		Add30:
			add word [score], 30
			jmp UpdateScoreVisual
		Add20:
			add word [score], 20

	UpdateScoreVisual:
		call UpdateHUD
		call CheckLevelComplete
		cmp al, 1
		jne NotLevelUp
		call LevelUpHandler
		jmp ExitHelper

	NotLevelUp:
		call Sound_Brick
		mov al, 1
		jmp ExitHelper

ExitHelper:
	pop es
	pop si
	pop di
	pop dx
	pop bx
	ret

; ---------------------------------------------------------
; BALL SECTION
; ---------------------------------------------------------
ballX:		dw 40
ballY:		dw 22
ballChar:	db 128
ballColor:	db 0x0F
velX:		dw 1
velY:		dw 1
ballTimer:	db 0
ballSpeed:	db 18

ballPattern:
	db 00h, 00h, 00h, 3Ch, 7Eh, 0FFh, 0FFh, 0FFh
	db 0FFh, 0FFh, 0FFh, 7Eh, 3Ch, 00h, 00h, 00h

CustomBall:
	pusha
	push cs
	pop es
	mov bp, ballPattern
	mov ah, 0x11
	mov al, 0x00
	mov bh, 16
	mov bl, 0
	mov cx, 1
	mov dx, 128
	int 0x10
	popa
	ret

CalculateLocation:
	push ax
	push bx
	mov cx, 80
	mul cx
	add ax, bx
	shl ax, 1
	mov di, ax
	pop bx
	pop ax
	ret

clscr:
	pusha
	mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ax, 0x0720
	mov cx, 2000
	cld
	rep stosw
	popa
	ret

DrawBall:
	pusha
	mov ax, [ballY]
	mov bx, [ballX]
	call CalculateLocation
	mov ax, 0xb800
	mov es, ax
	mov ah, [ballColor]
	mov al, [ballChar]
	mov [es:di], ax
	popa
	ret

ClearOldBall:
	pusha
	mov ax, [ballY]
	mov bx, [ballX]
	call CalculateLocation
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x0720
	mov [es:di], ax
	popa
	ret

MoveBall:
	call ClearOldBall
	call CheckPaddleCollision
	call CheckBrickCollision

	; X Movement
	mov ax, [ballX]
	add ax, [velX]
	mov [ballX], ax
	cmp ax, 1
	jle BounceX
	cmp ax, 79
	jge BounceX
	jmp CheckY

	BounceX:
		neg word [velX]
		mov ax, [ballX]
		add ax, [velX]
		mov [ballX], ax

	CheckY:
		; Y Movement
		mov ax, [ballY]
		add ax, [velY]
		mov [ballY], ax
		cmp ax, 2
		jle BounceY
		cmp ax, 23
		jge HandleLifeLoss
		jmp doneMove

	BounceY:
		neg word [velY]
		mov ax, [ballY]
		add ax, [velY]
		mov [ballY], ax

	doneMove:
		call DrawBall
		ret

HandleLifeLoss:
	call ClearOldBall
	call Sound_LifeLost
	call ClearPaddle
	dec word [lives]
	mov byte [ballLaunched], 0
	mov word [paddleX], 35
	call UpdateHUD
	call DrawPaddle
	cmp word [lives], 0
	je GameOverSequence
	ret

GameOverSequence:
	call RunGameOver
	jmp ExitGame

; ---------------------------------------------------------
; PADDLE SECTION
; ---------------------------------------------------------
paddleX:	dw 35
paddleY:	dw 23
paddleW:	dw 11
paddleColor:	db 0x09
ballLaunched:	db 0
screenWidth:	dw 80

HandleStickyBall:
	pusha
	call ClearOldBall
	call DrawPaddle

	; Snap ball to paddle
	mov ax, [paddleW]
	shr ax, 1
	add ax, [paddleX]
	mov [ballX], ax
	mov ax, [paddleY]
	dec ax
	mov [ballY], ax
	call DrawBall

	; Check Key
	mov ah, 0x01
	int 0x16
	jz StickyExit
	mov ah, 0x00
	int 0x16
	cmp al, ' '
	jne CheckArrows

	; Launch
	mov byte [ballLaunched], 1
	mov word [velX], 1
	mov word [velY], -1
	jmp StickyExit

	CheckArrows:
		cmp ah, 0x4B
		je DoLeft
		cmp ah, 0x4D
		je DoRight
		jmp StickyExit
		
	DoLeft:
		call MoveLeft
		jmp StickyExit
		
	DoRight:
		call MoveRight
		
	StickyExit:
		popa
		ret

CheckPaddleCollision:
	pusha
	; Direction Check
	cmp word [velY], 1
	jne NoPadHit

	; Y-Axis Check
	mov ax, [ballY]
	add ax, [velY]
	cmp ax, [paddleY]
	jne NoPadHit

	; X-Axis Check
	mov ax, [ballX]
	cmp ax, [paddleX]
	jl NoPadHit
	mov bx, [paddleX]
	add bx, [paddleW]
	cmp ax, bx
	jg NoPadHit

	; Hit Detected
	mov word [velY], -1
	call Sound_Paddle

	; Angle Calculation
	sub ax, [paddleX]
	cmp ax, 4
	jl BounceLeft
	cmp ax, 5
	jg BounceRight
	mov word [velX], 0
	jmp PadHitDone

	BounceLeft:
		mov word [velX], -1
		jmp PadHitDone
		
	BounceRight:
		mov word [velX], 1
		jmp PadHitDone

	PadHitDone:
		mov ax, [paddleY]
		dec ax
		mov [ballY], ax

	NoPadHit:
		popa
		ret

DrawPaddle:
	pusha
	mov ax, [paddleY]
	mov bx, [paddleX]
	call CalculateLocation
	mov ax, 0xB800
	mov es, ax
	mov cx, [paddleW]
	mov ah, [paddleColor]
	mov al, 219
	
	DrawLoop:
		mov [es:di], ax
		add di, 2
		loop DrawLoop
		
	popa
	ret

ClearPaddle:
	pusha
	mov ax, [paddleY]
	mov bx, [paddleX]
	call CalculateLocation
	mov ax, 0xB800
	mov es, ax
	mov cx, [paddleW]
	mov ah, 0x00
	mov al, ' '
	
	ClearLooop:
		mov [es:di], ax
		add di, 2
		loop ClearLooop
		
	popa
	ret

MoveLeft:
	cmp word [paddleX], 1
	jle GameLoop
	call ClearPaddle
	sub word [paddleX], 2
	call DrawPaddle
	jmp GameLoop

MoveRight:
	mov ax, 78
	sub ax, [paddleW]
	cmp [paddleX], ax
	jge GameLoop
	call ClearPaddle
	add word [paddleX], 2
	call DrawPaddle
	jmp GameLoop

; ---------------------------------------------------------
; MAIN GAME LOOP
; ---------------------------------------------------------
GameLoop:
	; Throttling Delay
	mov cx, 0
	mov dx, 5000
	mov ah, 0x86
	int 0x15

	; Logic Switch
	cmp byte [ballLaunched], 0
	je CallSticky

	; Ball Movement Timer
	inc byte [ballTimer]
	mov al, [ballSpeed]
	cmp [ballTimer], al
	jl SkipBallMove
	mov byte [ballTimer], 0
	call MoveBall
	jmp SkipBallMove

	CallSticky:
		call HandleStickyBall

	SkipBallMove:
		; Non-Blocking Check
		mov ah, 0x01
		int 0x16
		jz GameLoop

		; Get Key
		mov ah, 0x00
		int 0x16

		cmp ah, 0x4B
		je MoveLeft
		cmp ah, 0x4D
		je MoveRight
		cmp al, 27
		je ExitGame
		jmp GameLoop

start:
	mov ax, 0x0003
	int 0x10

	; Hide Cursor
	mov ah, 0x01
	mov cx, 0x2607
	int 0x10

	call Sound_GameStart
	call LoadCustomHeart
	call CustomBall
	call DrawArcadeFrame
	call FillHUDBackground
	call UpdateHUD
	call DrawBricksMain
	call DrawPaddle
	call GameLoop

ExitGame:
	mov ax, 0x0003
	int 0x10
	mov ax, 0x4c00
	int 0x21
