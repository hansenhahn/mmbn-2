; Implementação de rotina que implementa uma fonte VWF reduzida nas descrições dos chips para o jogo
; MegaMan Battle Network 2, assim permitindo caber mais caracteres por linha
;
; Escrito por denim - Abril de 2023
;
.gba

L_BUFFINICIAL	equ		[r5, 0]
L_BUFF			equ		[r5, 4]
L_VRAM			equ		[r5, 8]
L_PTR			equ		[r5, 12]
L_SZTL			equ		[r5, 16]
L_SZCHAR		equ		[r5, 17]
L_CHAR			equ		[r5, 18]
L_LINE			equ		[r5, 19]
		
.open "Mega Man Battle Network 2 (BR).gba", 0x08000000

	base	equ		0x030078b8 - 0x081e6db8

	;função original que desenha os tiles de quase tudo nos menus
	.org 0x08020f64
		ldr 	r0, =free1 + 1
	.org 0x08020fb0
		.pool
		
	.org 0x081e6db8
	free1:
		push	r1
		mov		r0, r3
		lsr		r0, 9
		mov		r1, #0xff
		and		r0, r1
		pop		r1
		cmp     r0, #0x57
		beq     @@vwf
		cmp     r0, #0x5c
		bne     @@normal
	@@vwf:
		pop     r0
		
		;r0 	base
		;r1		id do item
		;r2 	buff ram para envio pra vram (60 tiles)
		;r3		pos vram
		;r4		tamanho máximo em tiles
		
		;pega o ponteiro
		lsl		r1, 1
		add		r1, r0, r1
		ldrh	r1, [r1]
		add		r1, r0
		
		;salva dados de controle da vwf em uma posição na ram 02030000
		ldr		r5, =0x02030000
		;por ini buffer
		str		r2, L_BUFF
		str		r2, L_BUFFINICIAL
		;pos final vram
		str		r3, L_VRAM
		;ponteiro
		str		r1, L_PTR
		
		;variáveis de controle
		mov		r0, 0
		strb		r0, L_SZTL
		strb		r0, L_SZCHAR
		strb		r0, L_LINE

		;limpa o buffer
		ldr		r1, =0x780
		ldr		r0, =0x11111111
		;mov		r0, 0
	@@l3:
		str		r0, [r2,r1]
		sub		r1, 4
		bne		@@l3
		
		;loop de cada letra até encontrar e7
	@@l2:
		ldr		r1, L_PTR
		ldrb	r0, [r1]
		add		r1, 1
		str		r1, L_PTR
		cmp		r0, 0xe7
		bge		@@controle
		
		;salva letra atual
		strb	r0, L_CHAR
		
		;pega largura da letra atual
		ldr		r1, =FontWidthAddress
		add		r1, r0
		ldrb	r1, [r1]
		strb	r1, L_SZCHAR
		
		;verifica quantos pixels cabem no tile atual
		ldrb	r0, L_SZTL
		add		r0, r1
		cmp		r0, 8
		ble		@@tileunico
		
	@@trocatiles:
		;neste caso, copiamos o que cabe no tile atual
		ldrb	r0, L_SZTL
		ldrb	r1, L_CHAR
		ldr		r2, L_BUFF
		mov		r6, 1
		bl		copyTile
		
		;mudamos o tile
		ldr		r0, L_BUFF
		add		r0, 0x40
		str		r0, L_BUFF
		
		mov		r0, 8
		ldrb	r1, L_SZTL
		sub		r0, r1

		;e copiamos o restante do tile shiftando pra esquerda
		ldrb	r1, L_CHAR
		ldr		r2, L_BUFF
		mov		r6, 0
		bl		copyTile
		
		;atualiza tamanho do tile
		mov		r0, 8
		ldrb	r1, L_SZTL
		sub		r0, r1
		ldrb	r1, L_SZCHAR
		sub		r1, r0
		strb	r1, L_SZTL
		b		@@l2
		
	@@tileunico:
		;copia o tile shiftado
		ldrb	r0, L_SZTL
		ldrb	r1, L_CHAR
		ldr		r2, L_BUFF
		mov		r6, 1
		bl		copyTile
		
		;atualiza tamanho do tile
		ldrb	r0, L_SZCHAR
		ldrb	r1, L_SZTL
		add		r0, r1		;0 pix a mais
		strb	r0, L_SZTL
		
		;caso tenha completado o tile, incrementa buff
		cmp		r0, 8
		bne		@@l2		
		mov		r0, 0
		strb	r0, L_SZTL
		ldr		r0, L_BUFF
		add		r0, 0x40
		str		r0, L_BUFF
		b		@@l2
		
	@@controle:
		beq		@@termina
		cmp		r0, 0xe8
		beq		@@quebra
		sub		r0, 0xe7
		ldr		r2, =tabSkip
		add		r0, r2
		ldrb	r0, [r0]
		add		r1, r0
		str		r1, L_PTR
		b		@@l2
		
	@@quebra:
		mov		r0, 0
		strb	r0, L_SZTL
		
		ldrb	r0, L_LINE
		add		r0, 1
		strb	r0, L_LINE
		lsl		r1, r0, 2
		add		r0, r1, r0
		lsl		r0, 7
		ldr		r1, L_BUFFINICIAL
		add		r0, r1
		str		r0, L_BUFF
		b		@@l2
		
	@@termina:
		
		ldr		r2, L_BUFFINICIAL
		ldr		r3, L_VRAM
		
		;ativa dma
		mov		r0, r2
		mov		r1, r3
		
		;60 tiles
        mov     r2, 0x78
        lsl     r2, 2
		
		ldr 	r3, =0x08000a28 + 1
		mov		r14, r15
		bx		r3
		
		;volta
		ldr 	r3, =0x08020f6a + 1
		mov		r14, r15
		bx		r3
		
	@@normal:
		ldr 	r0, =0x03006dc9
		bx		r0
		
	copyTile:
		push	{r5}
		
		mov		r4, r2
		ldr		r3, =font
		lsl		r1, 6
		add		r3, r1
		mov		r1, 0x10		;10 words
		ldr     r7, =0xffffffff
		lsl		r0, 2
		cmp		r6, 0
		bne		@@l5
		lsr		r7, r0
		b		@@l4
	@@l5:
		lsl		r7, r0
	@@l4:
		mvn		r7, r7
		
	@@l1:
		ldr		r2, [r3]
		cmp		r6, 0
		bne		@@l2
		lsr		r2, r0			;remove r0 pixels a esquerda
		b		@@l3
	@@l2:
		lsl		r2, r0			;remove r0 pixels a direita
	@@l3:
		ldr		r5, [r4]
		and		r5, r7
		orr		r5, r2
		str		r5, [r4]
		add		r3, 4
		add		r4, 4
		sub		r1, 1
		bne		@@l1
		
		pop		{r5}
		bx		r14
		
	.pool
	
	tabSkip:
		.db 												  0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
		.db 		0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
		
	.org 0x087f72dc
	FontWidthAddress:
		.incbin "Graficos/tabela_vwf_font_descricoes.bin"

	.align 0x10
	font:
		.incbin "Graficos/vwf_font_descricoes.gba"
		
.close
