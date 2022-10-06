; Script de inserção de gráficos descomprimidos na rom
;
; Escrito por Solid One - Setembro de 2022
.gba

.open "Mega Man Battle Network 2 (BR).gba", 0x08000000

; Inserindo gráficos, em seus respectivos offsets
;.org 0x083157FC
;.incbin "Gráficos/Editados/0x3157FC - Trap pequeno.gba"

;.org 0x08315A20
;.incbin "Gráficos/Editados/0x315A20 - Trap grande.gba" 

;.org 0x08315D24
;.incbin "Gráficos/Editados/0x315D24 - Trap grande.gba" 

;.org 0x08315FA8
;.incbin "Gráficos/Editados/0x315FA8 - Trap grande.gba"

;.org 0x0869E650
;.incbin "Gráficos/Editados/0x69E650 - Fonte menus.gba"

.org 0x086A1150
.incbin "Gráficos/Editados/0x6A1150 - New.gba"

;.org 0x086BFAB0
;.incbin "Gráficos/Editados/0x6BFAB0 - Fonte nomes batalhas.gba"

;.org 0x086C0468
;.incbin "Gráficos/Editados/0x6C0468 - Advance.gba"

;.org 0x086C0968
;.incbin "Gráficos/Editados/0x6C0968 - Busy.gba"

;.org 0x086CB908
;.incbin "Gráficos/Editados/0x6CB908 - PAUSE.gba"

;.org 0x086CBFC8
;.incbin "Gráficos/Editados/0x6CBFC8 - CUSTOM.gba"

;.org 0x086CC0A8
;.incbin "Gráficos/Editados/0x6CC0A8 - L or R.gba"

;.org 0x086CC808
;.incbin "Gráficos/Editados/0x6CC808 - CHIP SELECT.gba"

;.org 0x086CD200
;.incbin "Gráficos/Editados/0x6CD200 - OK slash ADD.gba"

;.org 0x086CDF20
;.incbin "Gráficos/Editados/0x6CDF20 - Fontes nomes batalhas.gba"

;.org 0x086CEB20
;.incbin "Gráficos/Editados/0x6CEB20 - DeltTime.gba"

;.org 0x086CEE40
;.incbin "Gráficos/Editados/0x6CEE40 - Busting level.gba"

;.org 0x086CF1C0
;.incbin "Gráficos/Editados/0x6CF1C0 - GET DATA.gba"

;.org 0x086CF9F0
;.incbin "Gráficos/Editados/0x6CF9F0 - WINNER.gba"

;.org 0x086CFF70
;.incbin "Gráficos/Editados/0x6CFF70 - DeltTime.gba"

;.org 0x086D0290
;.incbin "Gráficos/Editados/0x6D0290 - Busting level.gba"

;.org 0x086D0610
;.incbin "Gráficos/Editados/0x6D0610 - GET DATA.gba"

;.org 0x086D0E40
;.incbin "Gráficos/Editados/0x6D0E40 - LOSER.gba"

;.org 0x086D13E0
;.incbin "Gráficos/Editados/0x6D13E0 - Lost chip data.gba"

;.org 0x086D1960
;.incbin "Gráficos/Editados/0x6D1960 - LOST DATA.gba"

;.org 0x086D2190
;.incbin "Gráficos/Editados/0x6D2190 - Fonte nomes chips ganhos ou perdidos após a batalha.gba"

;.org 0x086D2BD0
;.incbin "Gráficos/Editados/0x6D2BD0 - Press A button.gba"

;.org 0x086E0730
;.incbin "Gráficos/Editados/0x6E0730 - ATTACK + 20.gba"

;.org 0x086E0E30
;.incbin "Gráficos/Editados/0x6E0E30 - ATTACK + 30.gba"

;.org 0x086E1530
;.incbin "Gráficos/Editados/0x6E1530 - NAVI + 30.gba"

;.org 0x0870B530
;.incbin "Gráficos/Editados/0x70B530 - Diversos chips com nomes.gba"

;.org 0x0871B830
;.incbin "Gráficos/Editados/0x71B830 - ADDITIONAL CHIP DATA - Discard selected chips.gba"

;.org 0x0871BF30
;.incbin "Gráficos/Editados/0x71BF30 - CHIP DATA TRANSMISSION - Sending chip data.gba"

;.org 0x0871D430
;.incbin "Gráficos/Editados/0x71D430 - NO DATA SELECTED - Choose a chip.gba"

;.org 0x0871DB30
;.incbin "Gráficos/Editados/0x71DB30 - NO DATA.gba"

;.org 0x087AE730
;.incbin "Gráficos/Editados/0x7AE730 - Números andares prédio.gba"

;.org 0x087CE9C0
;.incbin "Gráficos/Editados/0x7CE9C0 - Nomes menus (folder chips mail).gba"

;.org 0x087D08DC
;.incbin "Gráficos/Editados/0x7D08DC - Nomes menus (folder pack PAmemory patttern chips battles).gba"

;.org 0x087D8B54
;.incbin "Gráficos/Editados/0x7D8B54 - Bug Frag.gba"

;.org 0x087E6D7C
;.incbin "Gráficos/Editados/0x7E6D7C - Presented By Capcom.gba"

;.org 0x087EA268
;.incbin "Gráficos/Editados/0x7EA268 - GAME OVER.gba"

.org 0x087EBAE8
.incbin "Gráficos/Editados/0x7EBAE8 - PRESS START.gba"

.org 0x087EC3A8
.incbin "Gráficos/Editados/0x7EC3A8 - NEW GAME CONTINUE.gba"

.org 0x087EC928
.incbin "Gráficos/Editados/0x7EC928 - COPYRIGHT tela-título.gba"

;.org 0x087ED8A8
;.incbin "Gráficos/Editados/0x7ED8A8 - CONT HARD.gba"
			
.close
