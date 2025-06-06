; Script de inserção de gráficos comprimidos no final da rom
;
; Escrito por denim e Solid One - Abril de 2023
.gba

.open "Mega Man Battle Network 2 (BR).gba", 0x08000000

;; Inserindo mapas de tiles dos fóruns e do quadro de pedidos,
;; bem como registrando seus respectivos ponteiros
.org 0x08025FC4
.dw imgboard
.dw 0x06000020
.dw (filesize("Graficos/Editados/imgboard.gba") - 0x20) >> 2
.org 0x087DDDDC
.incbin "Mapas de Tiles/tm-board1.bin"
.incbin "Mapas de Tiles/tm-board2.bin"

;; Registrando ponteiros de vários gráficos comprimidos
.org 0x0801f3c0
.dw	ptr1
.org 0x0801f39c
.dw	ptr2
.org 0x0801f3c0 + 8
.dw ptrtm1
.org 0x0801f39c + 8
.dw	ptrtm2
.org 0x0801f3a8 + 8
.dw ptrtm3
.org 0x0801f3a8
.dw	ptr3
.org 0x0801f33c
.dw	ptr4
.org 0x0801f33c + 8
.dw	ptrtm4
		
.org 0x0801f36c
.dw	ptr5
.org 0x0801f36c + 8
.dw	ptrtm5
	
.org 0x0801f24c
.dw	ptr6
.org 0x0801f24c + 8
.dw	ptrtm6
		
.org 0x0801f2d0
.dw	ptr7
.org 0x0801f2d0 + 8
.dw	ptrtm7
		
.org 0x0801f2e8
.dw	ptr8
.org 0x0801f2e8 + 8
.dw	ptrtm8
		
.org 0x0801f2dc
.dw	ptr9
.org 0x0801f2dc + 8
.dw	ptrtm9
		
.org 0x0801f390
.dw	ptr10
.org 0x0801f390 + 8
.dw	ptrtm10
		
.org 0x0801f4a4
.dw	ptr11
.org 0x0801f4a4 + 8
.dw	ptrtm11
		
.org 0x0801f528
.dw	ptr12
.org 0x0801f528 + 8
.dw	ptrtm12

.org 0x0801f384
.dw	ptr13
.org 0x0801f384 + 8
.dw	ptrtm13

.org 0x0801f378
.dw	ptr14
.org 0x0801f378 + 8
.dw	ptrtm14

.org 0x0801f720
.dw ptr15
.org 0x0801f720 + 8
.dw ptrtm15

.org 0x0801f3fc
.dw ptr16

.org 0x0801F678
.dw ptr17
.org 0x0801F680
.dw ptrtm17a
.org 0x0801F684
.dw ptr17
.org 0x0801F68C
.dw ptrtm17b
.org 0x0801F690
.dw ptr17
.org 0x0801F698
.dw ptrtm17c
.org 0x0801F69C
.dw ptr17
.org 0x0801F6A4
.dw ptrtm17d
.org 0x0801F6A8
.dw ptr17
.org 0x0801F6B0
.dw ptrtm17e

.org 0x0801ef9c
.dw gfx_onair
		
;grafico gameover td
.org 0x08030ED4
.dw gfx_td1
;tamanho em words
.org 0x08030ED4 + 8
.dw filesize("Mapas de Tiles/td1-edit.bin") / 4
;tm original
.org 0x087EAFA8
.incbin "Mapas de Tiles/tm1-edit.bin"
		
;ponteiro td win versus
.org 0x08011d0c
.dw gfx_td2
		
;tm no espaço original
.org 0x086d0ad0
.incbin "Mapas de Tiles/tm2-edit.bin"

;ponteiro td lose versus
.org 0x08011d18
.dw gfx_td3
		
;tilemap no espaço original
.org 0x086d1e20
.incbin "Mapas de Tiles/tm3-edit.bin"
		
;espaço livre no final da rom, após os scripts terem sido inseridos pela tool "TextPet"
.orga filesize("Mega Man Battle Network 2 (BR).gba")
.align

gfx_td1:
.incbin "Mapas de Tiles/td1-edit.bin"
.align
		
gfx_td2:
.incbin "Mapas de Tiles/td2-edit.bin"
.align
		
gfx_td3:
.incbin "Mapas de Tiles/td3-edit.bin"
.align
		
ptr1:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f3c0-td.bin"
.align
		
ptr2:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f39c-td.bin"
.align
		
ptr3:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f3a8-td.bin"
.align
		
ptr4:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f33c-td.bin"
.align
		
ptr5:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f36c-td.bin"
.align
	
ptr6:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f24c-td.bin"
.align
		
ptr7:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f2d0-td.bin"
.align
		
ptr8:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f2e8-td.bin"
.align
		
ptr9:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f2dc-td.bin"
.align
		
ptr10:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f390-td.bin"
.align
		
ptr11:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f4a4-td.bin"
.align
		
ptr12:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f528-td.bin"
.align

ptr13:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f384-td.bin"
.align

ptr14:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f378-td.bin"
.align

ptr15:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f720-td.bin"
.align

ptr16:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f3fc-td.bin"
.align

ptr17:
.incbin "Graficos/Comprimidos/Recomprimidos/img-01f678-td.bin"
.align

ptrtm1:
.db 0xa8, 0x60, 0x00, 0x00
.dw 0x00000010
.dw 0x00007e10
.dw 0x0000fc10
.incbin "Mapas de Tiles/img-01f3c0-tm.bin"
.align

ptrtm2:
.db 0xa0, 0x6c, 0x00, 0x00
.dw 0x00000010
.dw 0x00008710
.dw 0x00010e10
.incbin "Mapas de Tiles/img-01f39c-tm.bin"
.align

ptrtm3:    
.db 0x84, 0x64, 0x00, 0x00
.dw 0x00000010
.dw 0x00006730
.dw 0x0000ce50
.incbin "Mapas de Tiles/img-01f3a8-tm.bin"
.align

ptrtm4:
.db 0x52, 0x44, 0x00, 0x00
.dw 0x00000010
.dw 0x00002ba0
.dw 0x00005730
.incbin "Mapas de Tiles/img-01f33c-tm.bin"
.align
		
ptrtm5:
.db 0x8c, 0x78, 0x00, 0x00
.dw 0x00000010
.dw 0x00008350
.dw 0x00010690
.incbin "Mapas de Tiles/img-01f36c-tm.bin"
.align
		
ptrtm6:
.db 0xcc, 0x70, 0x00, 0x00
.dw 0x00000010
.dw 0x0000b290
.dw 0x00016510
.incbin "Mapas de Tiles/img-01f24c-tm.bin"
.align
		
ptrtm7:
.db 0xa0, 0x78, 0x00, 0x00
.dw 0x00000010
.dw 0x00009610
.dw 0x00012c10
.incbin "Mapas de Tiles/img-01f2d0-tm.bin"
.align
		
ptrtm8:
.db 0x64, 0x40, 0x00, 0x00
.dw 0x00000010
.dw 0x00003210
.dw 0x00006410
.incbin "Mapas de Tiles/img-01f2e8-tm.bin"
.align
		
ptrtm9:
.db 0x5a, 0x3c, 0x00, 0x00
.dw 0x00000010
.dw 0x00002a40
.dw 0x00005470
.incbin "Mapas de Tiles/img-01f2dc-tm.bin"
.align
		
ptrtm10:
.db 0x5a, 0x3c, 0x00, 0x00
.dw 0x00000010
.dw 0x00002a40
.dw 0x00005470
.incbin "Mapas de Tiles/img-01f390-tm.bin"
.align
		
ptrtm11:		
.db 0x80, 0x60, 0x00, 0x00
.dw 0x00000010
.dw 0x00006010
.dw 0x0000c010
.incbin "Mapas de Tiles/img-01f4a4-tm.bin"
.align
		
ptrtm12:		
.db 0x50, 0x2c, 0x00, 0x00
.dw 0x00000010
.dw 0x00001b90
.dw 0x00003710
.incbin "Mapas de Tiles/img-01f528-tm.bin"
.align

ptrtm13:
.db 0x84, 0x54, 0x00, 0x00
.dw 0x00000010
.dw 0x000056b0
.dw 0x0000ad50
.incbin "Mapas de Tiles/img-01f384-tm.bin"
.align

ptrtm14:	
.db 0xa0, 0x5a, 0x00, 0x00
.dw 0x00000010
.dw 0x00007090
.dw 0x0000e110
.incbin "Mapas de Tiles/img-01f378-tm.bin"
.align

ptrtm15:
.db 0x80, 0x58, 0x00, 0x00
.dw 0x00000010
.dw 0x00005810
.dw 0x0000b010
.incbin "Mapas de Tiles/img-01f720-tm.bin"
.align

ptrtm17a:
.db 0xa0, 0x70, 0x00, 0x00
.dw 0x00000010
.dw 0x00008c10
.dw 0x00011810
.incbin "Mapas de Tiles/img-01f678-tm-a.bin"
.align

ptrtm17b:
.db 0xa8, 0x6e, 0x00, 0x00
.dw 0x00000010
.dw 0x00009070
.dw 0x000120d0
.incbin "Mapas de Tiles/img-01f678-tm-b.bin"
.align

ptrtm17c:
.db 0xa8, 0x76, 0x00, 0x00
.dw 0x00000010
.dw 0x00009af0
.dw 0x000135d0
.incbin "Mapas de Tiles/img-01f678-tm-c.bin"
.align

ptrtm17d:
.db 0xa8, 0x76, 0x00, 0x00
.dw 0x00000010
.dw 0x00009af0
.dw 0x000135d0
.incbin "Mapas de Tiles/img-01f678-tm-d.bin"
.align

ptrtm17e:
.db 0xa0, 0x70, 0x00, 0x00
.dw 0x00000010
.dw 0x00008c10
.dw 0x00011810
.incbin "Mapas de Tiles/img-01f678-tm-e.bin"
.align

gfx_onair:
.incbin "Graficos/Comprimidos/Recomprimidos/0x3dde2c - ON AIR.gba"
.align

; Inserindo gráficos dos fóruns e do quadro de pedidos.
; Esse é inserido no final da rom, dado que precisou ser expandido.
imgboard:
.incbin "Graficos/Editados/imgboard.gba", 0x20
.align
			
.close