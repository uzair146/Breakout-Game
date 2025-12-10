; =============================================================
; SOUND.ASM
; =============================================================

; ---------------------------------------------------------
; PROCEDURE: Sound_Paddle
; ---------------------------------------------------------
Sound_Paddle:
	pusha
	mov di, 600		; Frequency (Low-Mid)
	mov bx, 20000		; Duration (20ms)
	call PlayTone
	popa
	ret

; ---------------------------------------------------------
; PROCEDURE: Sound_Brick
; ---------------------------------------------------------
Sound_Brick:
	pusha
	mov di, 2500		; Frequency (High)
	mov bx, 15000		; Duration (15ms)
	call PlayTone
	popa
	ret

; ---------------------------------------------------------
; PROCEDURE: Sound_LifeLost
; ---------------------------------------------------------
Sound_LifeLost:
	pusha
	mov di, 2500		; Start Frequency (High)

	SlideDownLoop:
		push di
		mov bx, 15000	; 15ms per step
		call PlayTone
		pop di

		sub di, 100	; Decrease Frequency
		cmp di, 300	; Go down to 300Hz
		jg SlideDownLoop

	popa
	ret

; ---------------------------------------------------------
; PROCEDURE: Sound_LevelUp
; ---------------------------------------------------------
Sound_LevelUp:
	pusha
	mov di, 800		; Start Frequency (Low-Mid)

	LevelUpLoop:
		push di
		mov bx, 8000	; 8ms duration (Very fast)
		call PlayTone
		pop di

		add di, 150	; Jump up 150Hz each step
		cmp di, 4000	; Stop at 4000Hz
		jl LevelUpLoop

	; Final "Ding" at the top
	mov di, 4500
	mov bx, 40000		; 40ms sustain
	call PlayTone
	popa
	ret

; ---------------------------------------------------------
; PROCEDURE: Sound_GameOver
; ---------------------------------------------------------
Sound_GameOver:
	pusha

	; --- Note 1: High-Mid ---
	mov di, 600
	mov cx, 3
	
	Note1:
		mov bx, 50000
		call PlayTone
		loop Note1

	; Slight pause
	mov ah, 0x86
	mov cx, 0
	mov dx, 30000
	int 0x15

	; --- Note 2: Mid ---
	mov di, 450
	mov cx, 3
	
	Note2:
		mov bx, 50000
		call PlayTone
		loop Note2

	; Slight pause
	mov ah, 0x86
	mov cx, 0
	mov dx, 30000
	int 0x15

	; --- Note 3: The "Dying" Slide ---
	mov di, 350
	
	DieLoop:
		push di
		mov bx, 20000
		call PlayTone
		pop di

		sub di, 10
		cmp di, 50
		jg DieLoop

	popa
	ret

; ---------------------------------------------------------
; PROCEDURE: Sound_GameStart
; ---------------------------------------------------------
Sound_GameStart:
	pusha

	; Tone 1: Low
	mov di, 800
	mov bx, 50000
	call PlayTone

	; Tone 2: Mid
	mov di, 1200
	mov bx, 50000
	call PlayTone

	; Tone 3: High
	mov di, 1800
	mov bx, 65000
	call PlayTone

	popa
	ret

; ---------------------------------------------------------
; CORE DRIVER: PlayTone
; DI = Frequency, BX = Duration
; ---------------------------------------------------------
PlayTone:
	pusha

	; 1. Initialize Timer (PIT 8253 Channel 2)
	mov al, 182		; 10110110b (Channel 2, Square Wave)
	out 0x43, al

	; 2. Load Divisor (1,193,180 / Freq)
	mov dx, 0x0012
	mov ax, 0x34DC		; DX:AX = 1,193,180
	div di			; AX = Divisor Count
	out 0x42, al		; Send LSB
	mov al, ah
	out 0x42, al		; Send MSB

	; 3. Turn Speaker ON
	in al, 0x61
	or al, 00000011b	; Set bits 0 and 1
	out 0x61, al

	; 4. Delay (Duration in BX)
	mov cx, 0
	mov dx, bx
	mov ah, 0x86		; BIOS Wait
	int 0x15

	; 5. Turn Speaker OFF
	in al, 0x61
	and al, 11111100b	; Clear bits 0 and 1
	out 0x61, al

	popa
	ret
