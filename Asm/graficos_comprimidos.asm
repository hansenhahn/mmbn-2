; Script de inserção de gráficos Editados no final da rom
;
; Escrito por Solid One - Setembro de 2022
.gba

.open "Mega Man Battle Network 2 (BR).gba", 0x08000000

; Indo até o final da rom, pra inserir os gráficos 
.orga filesize("Mega Man Battle Network 2 (BR).gba")

; Inserindo gráficos primeiro, e memorizando seus offsets nos labels
;.align 4
trap:
	.incbin "Gráficos/Editados/0x7EBAE8 - PRESS START.gba"

;.align 4
fonte_menus:
	.incbin "Gráficos/Editados/0x7EC3A8 - NEW GAME CONTINUE.gba"

;.align 4
new:
	.incbin "Gráficos/Editados/0x7EC928 - COPYRIGHT tela-título.gba"

; Editando ponteiros após inserir os gráficos, baseado nos offsets dos labels
.org 0x08025228
.dw trap

.org 0x08026030
.dw fonte_menus

.org 0x080264A4
.dw new

; Expandindo a rom para 12mb, ao fim do processo (possivelmente opcional)
;.fill 0xc00000 - filesize("Mega Man Battle Network 2 (BR).gba"), 0
			
.close
