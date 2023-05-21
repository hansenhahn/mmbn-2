; Script de inserção de gráficos comprimidos no final da rom
;
; Escrito por denim e Solid One - Abril de 2023
.gba

.open "Mega Man Battle Network 2 (BR).gba", 0x08000000

; Ponteiros
.org 0x0822b9f8 
.dw JewelImg

; Gráficos
.align
JewelImg:
.import "Gráficos/Comprimidos/Editados/0x4727c4 - Jewel.gba"
			
.close
