; Script de inserção de gráficos descomprimidos na rom
;
; Escrito por Solid One - Setembro de 2022
.gba

.open "Mega Man Battle Network 2 (BR).gba", 0x08000000

; Inserindo gráficos, em seus respectivos offsets
;.org 0x083157FC
;.incbin "Graficos/Editados/0x3157FC - Trap pequeno.gba"

;.org 0x08315A20
;.incbin "Graficos/Editados/0x315A20 - Trap grande.gba" 

;.org 0x08315D24
;.incbin "Graficos/Editados/0x315D24 - Trap grande.gba" 

;.org 0x08315FA8
;.incbin "Graficos/Editados/0x315FA8 - Trap grande.gba"

;.org 0x0869E650
;.incbin "Graficos/Editados/0x69E650 - Fonte menus.gba"

.org 0x086A1150
.incbin "Graficos/Editados/0x6A1150 - New.gba"

.org 0x086BFAA8
.incbin "Graficos/Editados/0x6BFAA8 - Fonte nomes batalhas.gba"

; Editando OAMs dos nomes da tela de batalha, exibidos ora antes dos turnos, ora no final delas
.loadtable "Tabelas/Tela Batalha - Nomes (Editados).tbl"
; Catalogando ponteiros das OAMs
.org 0x0800DFBC
.dw BattleStartOams
.org 0x0800DFC0
.dw EnemyDeletedOams
.org 0x0800DFC4
.dw MegamanDeletedOams
.org 0x0800DFC8
.dw StartTurnXOams
.org 0x0800DFCC
.dw DamageAnalysisOams
.org 0x0800DFD0
.dw FinalTurnOams
.org 0x0800DFD4
.dw TimeUpOams
;.org 0x0800DFD8
;.dw AdvanceOams
.org 0x0800DFDC
.dw WinOams
.org 0x0800DFE0
.dw LoseOams
.org 0x0800DFE4
.dw DrawOams
.org 0x0800DFE8
.dw StartBattleXOams

;; Inserindo textos das novas OAMs num local vago na rom
.org 0x087F9770
BattleStartOams:
.stringn "<INICIAR BATALHA!>",0xff
EnemyDeletedOams:
.stringn "[INIMIGO DELETADO!]",0xff
MegamanDeletedOams:
.stringn "[MEGAMAN DELETADO!]",0xff
StartTurnXOams:
.stringn "<INICIAR TURNO   !>",0xff
DamageAnalysisOams:
.stringn "<ANALISAR DANOS!>",0xff
FinalTurnOams:
.stringn "<TURNO FINAL>",0xff
TimeUpOams:
.stringn "<TEMPO ESGOTADO>",0xff
;AdvanceOams:
;.stringn "AVANÇAR",0xff
WinOams:
.stringn 0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,0x30,0x31,0xff
LoseOams:
.stringn "<PERDEU!>",0xff
DrawOams:
.stringn "<EMPATE!>",0xff
StartBattleXOams:
.stringn "<INICIAR BATALHA   !>",0xff

;; Ajustando quantidade de OAMs exibida por frase, assim aumentando/reduzindo a quantidade de caracteres
.org 0x0800DF60 ;; Battle Start, aumentar 3 OAMs (de 0x0D pra 0x12)
.stringn 0x12
.org 0x0800DF61 ;; Enemy Deleted, aumentar 4 OAMs (de 0x0D pra 0x13)
.stringn 0x13
.org 0x0800DF62 ;; Megaman Deleted, aumentar 2 OAMs (de 0x11 pra 0x13)
.stringn 0x13
.org 0x0800DF63 ;; Start Turn X, aumentar 3 OAMs (de 0x10 pra 0x13)
.stringn 0x13
.org 0x0800DF64 ;; Damage Analysis, diminuir 1 OAM (de 0x12 pra 0x11)
.stringn 0x11
.org 0x0800DF65 ;; Final Turn, aumentar 1 OAM (de 0x0C pra 0x0D)
.stringn 0x0D
.org 0x0800DF66 ;; Time Up, aumentar 7 OAMs (de 0x09 pra 0x0D)
.stringn 0x10
.org 0x0800DF68 ;; Win!, aumentar 3 OAMs (de 0x06 pra 0x09)
.stringn 0x09
.org 0x0800DF69 ;; Lose!, aumentar 2 OAMs (de 0x07 pra 0x09)
.stringn 0x09
.org 0x0800DF6A ;; Draw!, aumentar 3 OAMs (de 0x06 pra 0x09)
.stringn 0x09
.org 0x0800DF6B ;; Start Battle X, aumentar 3 OAMs (de 0x12 pra 0x15)
.stringn 0x15

;; Ajustando posição de números dinâmicos, em frases como "Start Battle X" e "Start Turn X"
.org 0x0800D242 ;; Start Battle X, afastar número uns 2 espaços à frente (de 0x74 pra 0x8C)
.stringn 0x8C
.org 0x0800D23E ;; Start Turn X, afastar número uns 2 espaços à frente (de 0x68 pra 0x80)
.stringn 0x80

;; Reposiona tile na vram, para evitar que o número apareça duas vezes em "Start Battle X"
.org 0x0800DF38
.dw 0x06017d00
.org 0x0800D29C
.dw 0x0000C3E8

.org 0x086C0968
.incbin "Graficos/Editados/0x6C0968 - Busy.gba"

.org 0x086CB908
.incbin "Graficos/Editados/0x6CB908 - PAUSE.gba"

;.org 0x086CBFC8
;.incbin "Graficos/Editados/0x6CBFC8 - CUSTOM.gba"

.org 0x086CC0A8
.incbin "Graficos/Editados/0x6CC0A8 - L or R.gba"

.org 0x086CC7E8
.incbin "Graficos/Editados/0x6CC7E8 - CHIP SELECT.gba"

.org 0x086CD200
.incbin "Graficos/Editados/0x6CD200 - OK slash ADD.gba"

;.org 0x086CDF20
;.incbin "Graficos/Editados/0x6CDF20 - Fontes nomes batalhas.gba"

.org 0x086CE840
.incbin "Graficos/Editados/0x6CE840 - Nomes tela vitória.gba"

; Editando tilemaps da tela de vitória acima
; Nome "DeleteTime"
.org 0x086CF71C
.stringn 0x1B,0x90,0x34,0x90,0x35,0x90,0x36,0x90,0x37,0x90,0x1E,0x90
.org 0x086CF74C
.stringn 0x28,0x90,0x3E,0x90,0x3F,0x90,0x40,0x90,0x41,0x90,0x42,0x90

; Nome "Boosting LV."
.org 0x086CF7AC
.stringn 0x33,0x90,0x34,0x90,0x35,0x90,0x36,0x90,0x37,0x90,0x38,0x90,0x20,0x90
.org 0x086CF7D6
.stringn 0x3A,0x90,0x3B,0x90,0x3C,0x90,0x3D,0x90,0x3E,0x90,0x3F,0x90,0x40,0x90,0x41,0x90,0x42,0x90,0x2D,0x90

; Nome "Get Data"
.org 0x086CF876
.stringn 0x1C,0x90
.org 0x086CF8A6
.stringn 0x1d,0x90

;.org 0x086CF9F0
;.incbin "Graficos/Editados/0x6CF9F0 - WINNER.gba"

;.org 0x086CFF70
;.incbin "Graficos/Editados/0x6CFF70 - DeltTime.gba"

;.org 0x086D0290
;.incbin "Graficos/Editados/0x6D0290 - Busting level.gba"

;.org 0x086D0610
;.incbin "Graficos/Editados/0x6D0610 - GET DATA.gba"

;.org 0x086D0E40
;.incbin "Graficos/Editados/0x6D0E40 - LOSER.gba"

;.org 0x086D13E0
;.incbin "Graficos/Editados/0x6D13E0 - Lost chip data.gba"

;.org 0x086D1960
;.incbin "Graficos/Editados/0x6D1960 - LOST DATA.gba"

;.org 0x086D2190
;.incbin "Graficos/Editados/0x6D2190 - Fonte nomes chips ganhos ou perdidos após a batalha.gba"

.org 0x086D2BD0
.incbin "Graficos/Editados/0x6D2BD0 - Press A button.gba"

.org 0x086E0730
.incbin "Graficos/Editados/0x6E0730 - ATTACK + 20.gba"

.org 0x086E0E30
.incbin "Graficos/Editados/0x6E0E30 - ATTACK + 30.gba"

;.org 0x086E1530
;.incbin "Graficos/Editados/0x6E1530 - NAVI + 30.gba"

.org 0x087AC6E0
.incbin "Graficos/Editados/0x7AC6E0 - NAL animado no monitor.gba"

.org 0x0870B530
.incbin "Graficos/Editados/0x70B530 - Diversos chips com nomes.gba"

.org 0x0871B830
.incbin "Graficos/Editados/0x71B830 - ADDITIONAL CHIP DATA - Discard selected chips.gba"

.org 0x0871BF30
.incbin "Graficos/Editados/0x71BF30 - CHIP DATA TRANSMISSION - Sending chip data.gba"

.org 0x0871D430
.incbin "Graficos/Editados/0x71D430 - NO DATA SELECTED - Choose a chip.gba"

;.org 0x0871DB30
;.incbin "Graficos/Editados/0x71DB30 - NO DATA.gba"

.org 0x087AE7C0
.incbin "Graficos/Editados/0x7AE7C0 - Números andares prédio.gba"

; Inserindo gráfico dos nomes dos menus, com as letras da fonte
.org 0x087CE940
.incbin "Graficos/Editados/0x7CE940 - Nomes menus (folder chips mail).gba"

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

; Editando tilemap dos menus, na parte de cima das letras
; (Hard, com o "Rede" e o "Salvar" desativados)
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima.tbl"
.org 0x087CF488
.stringn "Pasta    "
.org 0x087CF4BC
.stringn "Subchips "
.org 0x087CF4F0
.stringn "Coleção  "
.org 0x087CF524
.stringn "MegaMan  "
.org 0x087CF558
.stringn "Email    "
.org 0x087CF58C
.stringn "Itens    "
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima (Cinza).tbl"
.org 0x087CF5C0
.stringn "Rede     " ; Desativado
.org 0x087CF5F4
.stringn "Salvar   " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima.tbl"
.org 0x087CF628
.stringn "Sair     "

; Editando tilemap dos menus, na parte de baixo das letras
; (Hard, com o "Rede" e o "Salvar" desativados)
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo.tbl"
.org 0x087CF4A2
.stringn "Pasta    "
.org 0x087CF4D6
.stringn "Subchips "
.org 0x087CF50A
.stringn "Coleção  "
.org 0x087CF53E
.stringn "MegaMan  "
.org 0x087CF572
.stringn "Email    "
.org 0x087CF5A6
.stringn "Itens    "
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo (Cinza).tbl"
.org 0x087CF5DA
.stringn "Rede     " ; Desativado
.org 0x087CF60E
.stringn "Salvar   " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo.tbl"
.org 0x087CF642
.stringn "Sair     "

; Editando tilemap dos menus, na parte de cima das letras
; (Hard, com o "Rede" desativado)
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima.tbl"
.org 0x087CF896
.stringn "Pasta    "
.org 0x087CF8CA
.stringn "Subchips "
.org 0x087CF8FE
.stringn "Coleção  "
.org 0x087CF932
.stringn "MegaMan  "
.org 0x087CF966
.stringn "Email    "
.org 0x087CF99A
.stringn "Itens    "
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima (Cinza).tbl"
.org 0x087CF9CE
.stringn "Rede     " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima.tbl"
.org 0x087CFA02
.stringn "Salvar   "
.org 0x087CFA36
.stringn "Sair     "

; Editando tilemap dos menus, na parte de baixo das letras
; (Hard, com o "Rede" desativado)
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo.tbl"
.org 0x087CF8B0
.stringn "Pasta    "
.org 0x087CF8E4
.stringn "Subchips "
.org 0x087CF918
.stringn "Coleção  "
.org 0x087CF94C
.stringn "MegaMan  "
.org 0x087CF980
.stringn "Email    "
.org 0x087CF9B4
.stringn "Itens    "
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo (Cinza).tbl"
.org 0x087CF9E8
.stringn "Rede     " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo.tbl"
.org 0x087CFA1C
.stringn "Salvar   "
.org 0x087CFA50
.stringn "Sair     "

; Editando tilemap dos menus, na parte de cima das letras
; (Opções desabilitadas, devido a entregarmos o Pet pro cara do aeroporto)
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima (Cinza).tbl"
.org 0x087CF68E
.stringn "Pasta    " ; Desativado
.org 0x087CF6C2
.stringn "Subchips " ; Desativado
.org 0x087CF6F6
.stringn "Coleção  " ; Desativado
.org 0x087CF72A
.stringn "MegaMan  " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima.tbl"
.org 0x087CF75E
.stringn "Email    "
.org 0x087CF792
.stringn "Itens    "
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima (Cinza).tbl"
.org 0x087CF7C6
.stringn "Rede     " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Cima.tbl"
.org 0x087CF7FA
.stringn "Salvar   "
.org 0x087CF82E
.stringn "Sair     "

; Editando tilemap dos menus, na parte de baixo das letras
; (Opções desabilitadas, devido a entregarmos o Pet pro cara do aeroporto)
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo (Cinza).tbl"
.org 0x087CF6A8
.stringn "Pasta    " ; Desativado
.org 0x087CF6DC
.stringn "Subchips " ; Desativado
.org 0x087CF710
.stringn "Coleção  " ; Desativado
.org 0x087CF744
.stringn "MegaMan  " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo.tbl"
.org 0x087CF778
.stringn "Email    "
.org 0x087CF7AC
.stringn "Itens    "
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo (Cinza).tbl"
.org 0x087CF7E0
.stringn "Rede     " ; Desativado
.loadtable "Tabelas/Menu Esquerdo - Nomes Parte Baixo.tbl"
.org 0x087CF814
.stringn "Salvar   "
.org 0x087CF848
.stringn "Sair     "

; Inserindo gráfico dos nomes dos submenus
.org 0x087D08DC
.incbin "Graficos/Editados/0x7D08DC - Nomes menus (folder pack PAmemory patttern chips battles).gba"

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

; Editando tilemap dos menus, na parte de cima das letras (Hard, sem o "Rede")
.loadtable "Tabelas/Telas Menus - Nomes Parte Cima.tbl"
.org 0x087DD100
.stringn "Inserir"
.org 0x087DD600
.stringn "Inserir"
.org 0x087DD126
.stringn "Mochila"

; Editando tilemap dos menus, na parte de cima das letras (Hard, sem o "Rede")
.loadtable "Tabelas/Telas Menus - Nomes Parte Baixo.tbl"
.org 0x087DD140
.stringn "Inserir"
.org 0x087DD61A
.stringn "Inserir"
.org 0x087DD166
.stringn "Mochila"

; Corrigindo bugs no tilemap do gráfico "Choosing", nas telas de troca de chips e estilos
.org 0x087D68D0
.stringn 0xAD,0x40
.org 0x087D5C70
.stringn 0xAD,0x40

; Inserindo gráfico da fonte dos números, nos menus
.org 0x087D7068
.incbin "Graficos/Editados/0x7D7068 - Fonte números menus.gba"

;.org 0x087D8B54
;.incbin "Graficos/Editados/0x7D8B54 - Bug Frag.gba"

;.org 0x087E6D7C
;.incbin "Graficos/Editados/0x7E6D7C - Presented By Capcom.gba"

; Inserindo gráfico do nome "Licensed by Nintendo", abaixo do logo da capcom
.org 0x087E97A8
.incbin "Graficos/Editados/0x7E97A8 - Licensed by nintendo.gba"

;.org 0x087EA268
;.incbin "Graficos/Editados/0x7EA268 - GAME OVER.gba"

.org 0x087EBAE8
.incbin "Graficos/Editados/0x7EBAE8 - PRESS START.gba"

.org 0x087EC3A8
.incbin "Graficos/Editados/0x7EC3A8 - NEW GAME CONTINUE.gba"

.org 0x087EC928
.incbin "Graficos/Editados/0x7EC928 - COPYRIGHT tela-título.gba"

;.org 0x087ED8A8
;.incbin "Graficos/Editados/0x7ED8A8 - CONT HARD.gba"
			
.close
