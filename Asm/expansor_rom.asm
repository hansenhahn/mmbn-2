; Script de expansão da rom pra 16mb
;
; Escrito por Solid One - Setembro de 2023
.gba
.open "Mega Man Battle Network 2 (BR).gba", 0x08000000
.orga filesize("Mega Man Battle Network 2 (BR).gba")
.fill 16777216 - filesize("Mega Man Battle Network 2 (BR).gba"), 0xff
.close