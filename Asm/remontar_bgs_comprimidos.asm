; Script de remontagem de contêiners de gráficos comprimidos de backgrounds
;
; Cada arquivo de contêiner é composto por um cabeçalho de 9 DWORDs, seguido
; por três gráficos comprimidos em LZSS. Esse script gera o cabeçalho, e
; também insere cada um dos 3 gráficos, previamente comprimidos através do
; "lzss.exe".
;
; Uso: armips.exe remontar_bgs_comprimidos.asm -equ output {NomeDoArquivoSemExtensão}
; 
; Escrito por Solid One - Setembro de 2023
.gba

.create "Graficos/Comprimidos/Recomprimidos/" + output + ".bin", 0x0

.dw filesize("Graficos/Comprimidos/Editados/" + output + "_grafico1.gba") / 4 ; Tamanho
.dw Grafico1 ; Ponteiro
.dw 0 ; Posição na VRAM

.dw filesize("Graficos/Comprimidos/Editados/" + output + "_grafico2.gba") / 4 ; Tamanho
.dw Grafico2 ; Ponteiro
.dw filesize("Graficos/Comprimidos/Editados/" + output + "_grafico1.gba") ; Posição na VRAM

.dw filesize("Graficos/Comprimidos/Editados/" + output + "_grafico3.gba") / 4 ; Tamanho
.dw Grafico3 ; Ponteiro
.dw filesize("Graficos/Comprimidos/Editados/" + output + "_grafico1.gba") + filesize("Graficos/Comprimidos/Editados/" + output + "_grafico2.gba") ; Posição na VRAM

Grafico1:
.incbin "Graficos/Comprimidos/Recomprimidos/" + output + "_grafico1.gba"
.align

Grafico2:
.incbin "Graficos/Comprimidos/Recomprimidos/" + output + "_grafico2.gba"
.align

Grafico3:
.incbin "Graficos/Comprimidos/Recomprimidos/" + output + "_grafico3.gba"

.close