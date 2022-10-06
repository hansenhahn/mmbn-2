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

.org 0x086CB908
.incbin "Gráficos/Editados/0x6CB908 - PAUSE.gba"

;.org 0x086CBFC8
;.incbin "Gráficos/Editados/0x6CBFC8 - CUSTOM.gba"

.org 0x086CC0A8
.incbin "Gráficos/Editados/0x6CC0A8 - L or R.gba"

.org 0x086CC7E8
.incbin "Gráficos/Editados/0x6CC7E8 - CHIP SELECT.gba"

.org 0x086CD200
.incbin "Gráficos/Editados/0x6CD200 - OK slash ADD.gba"

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

; Inserindo gráfico dos nomes dos menus, com as letras da fonte
.org 0x087CE940
.incbin "Gráficos/Editados/0x7CE940 - Nomes menus (folder chips mail).gba"

; Editando tilemap dos menus, na parte de cima das letras
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima.tbl"
.org 0x087CF280
.stringn "Pasta    "
.org 0x087CF2B4
.stringn "Subchips "
.org 0x087CF2E8
.stringn "Coleção  "
.org 0x087CF31C
.stringn "MegaMan  "
.org 0x087CF350
.stringn "Email    "
.org 0x087CF384
.stringn "Itens    "
.org 0x087CF3B8
.stringn "Rede     "
.org 0x087CF3EC
.stringn "Salvar   "
.org 0x087CF420
.stringn "Sair     "

; Editando tilemap dos menus, na parte de baixo das letras
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo.tbl"
.org 0x087CF29A
.stringn "Pasta    "
.org 0x087CF2CE
.stringn "Subchips "
.org 0x087CF302
.stringn "Coleção  "
.org 0x087CF336
.stringn "MegaMan  "
.org 0x087CF36A
.stringn "Email    "
.org 0x087CF39E
.stringn "Itens    "
.org 0x087CF3D2
.stringn "Rede     "
.org 0x087CF406
.stringn "Salvar   "
.org 0x087CF43A
.stringn "Sair     "

;.org 0x087CF260
;.incbin "Gráficos/Editados/0x7CF260 - Nomes menus (folder chips mail).tilemap"

; Inserindo gráfico dos nomes dos submenus
.org 0x087D08DC
.incbin "Gráficos/Editados/0x7D08DC - Nomes menus (folder pack PAmemory patttern chips battles).gba"

; Editando tilemap dos submenus, na parte de cima das letras
.loadtable "Tabelas/Telas Menus - Nomes Parte Cima.tbl"
.org 0x087D2E12
.stringn " Pasta"
.org 0x087D39D6
.stringn " Pasta"
.org 0x087D3310
.stringn "[Mochila]"
.org 0x087D61CA
.stringn "Subchips"
.org 0x087D3ECC
.stringn "Coleção"
.org 0x087D46C4
.stringn "Lista P.A."
.org 0x087D43B6
.stringn "MegaMan.exe"
.org 0x087D43E0
.stringn "Nv."
.org 0x087D448E
.stringn "ESTILO"
.org 0x087D450E
.stringn "ATAQUE"
.org 0x087D458E
.stringn "VELOC."
.org 0x087D460E
.stringn "CARGA "
.org 0x087D4D1C
.stringn "Email"
.org 0x087D501A
.stringn " Itens  "
.org 0x087D531A
.stringn " Rede  "
.org 0x087D5ECC
.stringn "Salvar"
.org 0x087D65CE
.stringn "TrocaEst"
.org 0x087D5626
.stringn "TrocaChp"

; Editando tilemap dos submenus, na parte de baixo das letras
.loadtable "Tabelas/Telas Menus - Nomes Parte Baixo.tbl"
.org 0x087D2E52
.stringn " Pasta"
.org 0x087D3A16
.stringn " Pasta"
.org 0x087D3350
.stringn "[Mochila]"
.org 0x087D620A
.stringn "Subchips"
.org 0x087D3F0C
.stringn "Coleção"
.org 0x087D4704
.stringn "Lista P.A."
.org 0x087D43F6
.stringn "MegaMan.exe"
.org 0x087D4420
.stringn "Nv."
.org 0x087D44CE
.stringn "ESTILO"
.org 0x087D454E
.stringn "ATAQUE"
.org 0x087D45CE
.stringn "VELOC."
.org 0x087D464E
.stringn "CARGA "
.org 0x087D4D5C
.stringn "Email"
.org 0x087D505A
.stringn " Itens  "
.org 0x087D535A
.stringn " Rede  "
.org 0x087D5F0C
.stringn "Salvar"
.org 0x087D660E
.stringn "TrocaEst"
.org 0x087D5666
.stringn "TrocaChp"

; Editando tilemap dos nomes dos estilos na tela "MegaMan", na parte de cima das letras
.loadtable "Tabelas/Tela MegaMan - Nomes Estilos Cima.tbl"
.org 0x087D7988
.stringn "EstlNorm"
.org 0x087D7BA8
.stringn "EstlHub"

; Editando tilemap dos nomes dos estilos na tela "MegaMan", na parte de baixo das letras
.loadtable "Tabelas/Tela MegaMan - Nomes Estilos Baixo.tbl"
.org 0x087D7998
.stringn "EstlNorm"
.org 0x087D7BB8
.stringn "EstlHub"

; Corrigindo bug no tilemap do gráfico "Choosing", na tela de troca de estilos
.org 0x087D68D0
.stringn 0xAD,0x40

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
