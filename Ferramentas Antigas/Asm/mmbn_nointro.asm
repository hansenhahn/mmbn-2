; Retirada da intro mode-7
;
; Escrito por Diego Hahn - Mar�o de 2018
;
.gba

.open "..\ROM Modificada\0468 - MegaMan Battle Network 2 (U)(Mode7).gba", 0x08000000
.arm

.org 0x087f4c04
;; Originalmente, salta para o endere�o onde a intro � copiada para RAM, executada, e retorna na intera��o do jogador.
;; Alterado para saltar diretamente para o ponto logo ap�s o retorno.
;; add     r0,=87f4c0dh
add     r0,=87f4c1bh

.close