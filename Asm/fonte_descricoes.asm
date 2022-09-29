; Implementação de rotina que implementa fonte 8x8 nas descrições dos chips para o jogo
; MegaMan Battle Network 2, assim dobrando a quantidade de linhas, aumentando espaço
;
; Escrito por denim - Setembro de 2022
;
.gba

.open "Mega Man Battle Network 2 (BR).gba", 0x08000000

	base	equ		0x030078b8 - 0x081e6db8
	
	;tamanho do programa que vai pra ram, aumentamos
	.org 0x08000210
		.dw	fimprog - 0x081e5800
	
	
	;desvio da função para print personalizado
	.org 0x081e62dc
		ldr		r4, =free1 + 1 + base
		bx		r4
		.pool
	
	
	.org 0x081e6db8
		free1:
			;desvio em funcao posvram
			push	{r0}
			
			ldr		r0, =0x0600ae00
			cmp		r0, r3
			beq		@@custom
			
			;normal
			pop		{r0}
			mov		r4, 0
			mov		r5, 0
			mov		r9, r5
			push	{r2, r3}
			
			ldr		r3, =0x03006de4 + 1
			bx		r3
			
		@@custom:
			pop		{r0}
			
			;limpa a ram
			bl		init
			
			ldr		r6, =font
			mov		r4, 0
			mov		r5, 0
			mov		r9, r5
			push	{r2, r3}
			;ponteiro
			lsl		r1, 1
			ldrh	r1, [r1,r0]
			add		r0, r1
			mov		r3, 1
		@@l2:
			cmp		r3, 0
			beq		@@fim
			
			;parser
		@@parser:
			ldrb	r1, [r0]
			cmp		r1, 0xe8
			beq		@@endline
			cmp		r1, 0xe7
			beq		@@fim
			bge		@@cmd
			b		@@char
		@@cmd:
			sub		r1, 0xe7
			lsl		r1, 2
			ldr		r7, =0x03006d5c
			ldr		r1, [r7,r1]
			mov		r14, r15
			bx		r1
			b		@@l2
			
		@@char:
			cmp		r1, 0xe5
			beq		@@l3
			cmp		r1, 0xe6
			beq		@@l4
			bl		@@copy
			add		r0, 1
		@@cl1:
			mov		r7, r9
			add		r7, 1
			mov		r9, r7
			b		@@l2
			
		@@l3:
			ldrb	r1, [r0,1]
			add		r1, 0xe5
			bl		@@copy
			add		r0, 2
			b		@@cl1
		
		@@l4:
			ldrb	r1, [r0,1]
			add		r1, 0xe6
			add		r1, 0xff
			bl		@@copy
			add		r0, 2
			b		@@cl1
		
		@@copy:
			push	{r0, r6, r14}
			lsl		r7, r1, 5		;indexa a cada 20
			add		r6, r7
			ldr		r7, =0x03006db4
			mov		r1, r10
			ldr		r1, [r1, 0x68]
			ldrb	r1, [r1, 2]
			ldr		r0, [r7, r1]
			mov		r1, 0x20		;copia apenas 20
		@@l6:
			sub		r1, 4
			blt		@@l5
			ldr		r7, [r6, r1]
			add		r7, r0
			str		r7, [r2, r1]
			b		@@l6
		@@l5:
			add		r2, 0x40		;avança 40
			add		r4, 1
			add		r5, 1
			pop		{r0, r6, r15}
		
		@@fim:
			pop		{r0, r1}
			sub		r2, r0
			mov		r2, 0xf0	;words do dma
			lsl		r2, 1
			ldr		r3, =0x08000a29
			mov		r14, r15
			bx		r3
			mov		r0, r9
			pop		{r15}
			
		@@endline:
			mov		r1, r10
			ldr		r1, [r1, 0x68]
			ldrb	r1, [r1]
			mov		r8, r1
		@@el1:
			cmp		r4, r8
			bge		@@el2
			mov		r1, 0
			bl		@@copy
			b		@@el1
		@@el2:
			
			;manipula o tilemap em função da linha
			mov		r4, 0x20
			tst		r4, r2
			bne		@@op2
		@@op1:
			mov		r4, 0x98
			lsl		r4, 2
			sub		r2, r4
			b		@@comop
		@@op2:
			sub		r2, 0x20
		@@comop:
			mov		r4, 0
			add		r0, 1
			b		@@l2
			
		init:
			push	{r1, r14}
			ldr		r7, =0x11111111
			mov		r1, 0xf0
			lsl		r1, 3
		@@l1:
			sub		r1, 4
			blt		@@l2
			str		r7, [r2, r1]
			b		@@l1
		@@l2:
			pop		{r1, r15}
			.pool
		
		fimprog:
			.org 0x087F6F10
			font:
			.incbin "Gráficos/font_mini.gba"
			
.close
