; Implementação de rotina VWF - Variable Width Font para o jogo
; MegaMan Battle Network 2
;
; Escrito por Diego Hahn - Março de 2018
;
.gba

.open "Mega Man Battle Network 2 (BR).gba", 0x08000000
.thumb

FontTileAddress         equ 0x086965F0
FontColorAddress        equ 0x08020DDC

RAMTileAddress          equ 0x02004F90

FnCopyCharToRam         equ 0x087f87d0

BlankPixel8             equ 0x11111111      ; Uma linha de 8 pixel branco

RAMVarAddress           equ 0x0201f000

;; Tabela de ponteiro das funções com valor acima ou igual a E7 executadas
;; durante a copia do caractere da ROM para a RAM
.org (0x08020fb4 + 0x4 ) ;; E8
.dw (FnCopyCharNewLine+1)
.org (0x08020fb4 + 0x8 ) ;; E9
.dw (FnCopyCharPressBtn+1)
.org (0x08020fb4 + 0x1C )     ;; EE
.dw (FnCopyCharShowOption+1)

;; Tabela de ponteiro das funções com valor acima ou igual a E7 executadas
;; durante a montagem do tilemap
.org (0x0802100c + 0x4)     ;; E8
.dw (FnTileMapNewLine+1)

.org 0x08020F24
push    {r1,r2,r14}
ldr     r1,=(InitRamStructure+1)
mov     r14,r15
bx      r1
pop     {r1,r2,r15}
.pool

;; Feito um branch para inicializar a estrutura original mais algumas variáveis extras
;; da rotina de montagem do tilemap
.org 0x08020D34
bl      InitValuesTileMapMount

;; Posição da função original que copia o caractere da ROM para a RAM em forma de tile.
;; Agora, ela serve como endereço da rotina que inicializa os valores e que chama a nova 
;; função de cópia
.org 0x8020DAC
CopyCharToRamOriginal:
ldr     r0,=(CopyCharToRam+1)
bx      r0
.pool

;; Inicializa valores para a rotina de cópia de caracteres
;; Args: 
;;      r5 - Ponteiro para estrutura text_t (02008730)
InitValuesCopyCharToRam:
strb    r1,[r5,1h]
ldr     r0,[r5,28h]
lsl     r1,r1,1h
ldrh    r1,[r0,r1]
add     r0,r0,r1
str     r0,[r5,24h]
str     r0,[r5,2Ch]
mov     r1,0h
str     r1,[r5,5Ch]
strb    r1,[r5,2h]
;strb    r1,[r5,18h]         ; Adicionado o reset dessa variável, responsável por guardar quantos pixel foram usados no tile atual.
push    {r5}
ldr     r5,=RAMVarAddress
strb    r1,[r5,0h]          ; Adicionado o reset dessa variável, responsável por guardar quantos pixel foram usados no tile atual.
pop     {r5}
mov     r4,r0
mov     r15,r14
.pool

;; Posição da função original que inicializa os valores. Agora apenas chama a
;; nova função de inicialização.
.org 0x802260C
InitValuesCopyCharToRamOriginal:
ldr     r0,=(InitValuesCopyCharToRam+1)
bx      r0
.pool

;; Posição da função original que monta o tilemap. Agora apenas chama a
;; nova função de montagem de tilemap e inicializa os valores.
.org 0x08020DF0
TileMapMountOriginal:
ldr     r0,=(TileMapMount+1)
bx      r0
.pool

;; Inicializa valores para a rotina de montagem de tilemaps
;; Args: 
;;      r5 - Ponteiro para estrutura text_t (02008730)
InitValuesTileMapMount:
push    {r14}
mov     r0,0h
strb    r0,[r5,0Eh]         ; Inicializa dx com 0
strb    r0,[r5,0Fh]         ; Inicializa dy com 0
strb    r0,[r5,14h]
strb    r0,[r5,6h]
push    {r5}
ldr     r5,=RAMVarAddress
strb    r0,[r5,1h]          ; Adicionado o reset dessa variável, responsável por guardar quantos pixel foram usados no tile atual.
strb    r0,[r5,2h]          ; Adicionado o reset dessa variável, responsável por guardar quantos tiles foram avançados
pop     {r5}
pop     {r15}
.pool

.org FnCopyCharToRam

InitRamStructure:
ldr     r1,=20087C4h
ldr     r2,[r1]
orr     r2,r0
str     r2,[r1]
ldr     r1,=RAMVarAddress
mov     r2,0
strb    r2,[r1,0h]
strb    r2,[r1,1h]
strb    r2,[r1,2h]
mov     r15,r14
.pool

;; [r5,18h] -> Quantos pixel foram ocupados pelo caractere dentro do tile (não parece ser usado *)*)

;; Copia um char para a RAM
;;      O objetivo dessa função é copiar apenas a parte útil do desenho da caractere para a RAM.
;;      Notar que, como ele tem tamanho variável, é necessário verificar se o caractere anterior
;;      já preencheu os 8 pixel do tile atual. Se não preencher, preencher com o que faltou e usar
;;      o tile seguinte para preencher o resto.
;; Args:
;;      r1 - caractere
;;      r5 - *text_info_t
CopyCharToRam:
push    {r1,r4,r6}
mov     r8,r1
ldr     r0,=FontTileAddress
lsl     r1,r1,6h                ; Multiplica o hex do caractere por 64 para ter a posição relativa dele dentro da fonte (cada caractere ocupa 64 bytes)
add     r0,r0,r1                ; Endereço absoluto do caractere
ldr     r1,=RAMTileAddress
ldrb    r2,[r5,2h]              ; Posição relativa do último caractere copiado para RAM
lsl     r2,r2,6h
add     r1,r1,r2                ; Endereço absoluto do último caractere copiado para a RAM
ldr     r7,=FontColorAddress
ldrb    r2,[r5,13h]
lsl     r2,r2,2h
ldr     r7,[r7,r2]              ; Carrega a cor que deve ser aplicada ao caractere
;; OK, a partir daqui é código novo
push    {r5}
ldr     r5,=RAMVarAddress

;; Aqui vemos quantos pixel serão copiados
ldrb    r4,[r5,0h]             ; Largura utilizada em Pixel do tile atual
ldr     r6,=FontWidthAddress                   ; Caracteres de largura 5 pixel para provar o conceito
add     r6,r8
ldrb    r6,[r6]
add     r6,r4
cmp     r6,8h                   ; Verifica se passou o limite de 8 pixel (maior ou igual)
bgt     WidthGreaterThan
mov     r2,40h
CopyLoop1:
sub     r2,4h
blt     CopyFinished1
ldr     r3,[r0,r2]
add     r3,r7                ; Aplica a cor
ldrb    r4,[r5,0h]             ; Lê a largura atual da RAM
lsl     r4,r4,2h                ; Pixel atual multiplicado por 4, afinal cada pixel ocupada 4 bits
lsl     r3,r4                ; Desloca para a posição correta os pixel do caractere
push    {r0,r6}
ldr     r6,[r1,r2]              ; Lê os pixel que já estão na RAM
ldr     r0,=0xFFFFFFFF          ; Máscara
lsl     r0,r4                ; Desloca a máscara pelo pixel atual
mvn     r0,r0                   ; move negado. se estava 0xFFFFF000 vira 0x00000FFF
and     r0,r6                ; Pixel na RAM = Pixel na RAM & 0x00000FFF
orr     r3,r0                ; Pixel na ROM | Pixel na RAM
pop     {r0,r6}
str     r3,[r1,r2]              ; Guarda os pixel de volta a RAM
b       CopyLoop1
WidthGreaterThan:
mov     r2,40h
CopyLoop2:
sub     r2,4h
blt     CopyFinished2
ldr     r3,[r0,r2]
add     r3,r7                ; Aplica a cor
ldrb    r4,[r5,0h]             ; Lê a largura atual da RAM
lsl     r4,r4,2h                ; Pixel atual multiplicado por 4, afinal cada pixel ocupada 4 bits
lsl     r3,r4                ; Desloca para a posição correta os pixel do caractere
push    {r0,r6}
ldr     r6,[r1,r2]              ; Lê os pixel que já estão na RAM
ldr     r0,=0xFFFFFFFF          ; Máscara
lsl     r0,r4                ; Desloca a máscara pelo pixel atual
mvn     r0,r0                   ; move negado. se estava 0xFFFFF000 vira 0x00000FFF
and     r0,r6                ; Pixel na RAM = Pixel na RAM & 0x00000FFF
orr     r3,r0                ; Pixel na ROM | Pixel na RAM
pop     {r0,r6}
str     r3,[r1,r2]              ; Guarda os pixel de volta a RAM
;; Copia o resto do caractere para a RAM
ldr     r3,[r0,r2]
ldrb    r4,[r5,0h]             ; Lê a largura atual da RAM
mov     r6,8
sub     r4,r6,r4               ; 8 - largura atual = numero de pixel do caractere atual usado no tile anterior
lsl     r4,r4,2                 ; Os pixel já usados são "jogados fora"
lsr     r3,r4
push    {r0}                    ; 0x00000322 ... é necessário preencher os 0 com 1
ldr     r0,=0xFFFFFFFF          ; Máscara
lsr     r0,r4                ; Desloca a máscara pelo pixel atual
mvn     r0,r0                   ; move negado. se estava 0xFFFFF000 vira 0x00000FFF
ldr     r4,=0x11111111
and     r0,r4
add     r3,r0
add     r3,r7                ; Aplica a cor
mov     r0,40h
add     r0,r2               ; Endereço do próximo tile
str     r3,[r1,r0]             ; Guarda os pixel de volta a RAM
pop     {r0}
b       CopyLoop2
CopyFinished2:
; O contador é incrementado apenas no segundo copy
ldrb    r4,[r5,0h]             ; Lê a largura atual da RAM
mov     r6,8h
sub     r4,r6,r4               ; 8 - largura atual = numero de pixel do caractere atual usado no tile anterior
ldr     r6,=FontWidthAddress                   ; Caracteres de largura 5 pixel para provar o conceito
add     r6,r8
ldrb    r6,[r6]
sub     r4,r6,r4
strb    r4,[r5,0h]             ; Salva a largura atual da RAM
pop     {r5}
ldrb    r3,[r5,2h]
add     r3,1h             ; Um caractere copiado
strb    r3,[r5,2h]
b       Exit
CopyFinished1:
ldrb    r4,[r5,0h]             ; Lê a largura atual da RAM
ldr     r6,=FontWidthAddress                   ; Caracteres de largura 5 pixel para provar o conceito
add     r6,r8
ldrb    r6,[r6]
add     r6,r4
cmp     r6,8h                   ; Fechou um tile completo.
bne     Exit1       
mov     r6,0h
strb    r6,[r5,0h]             ; Salva a largura atual da RAM
pop     {r5}
ldrb    r3,[r5,2h]
add     r3,1h             ; Um caractere copiado
strb    r3,[r5,2h]
b       Exit
Exit1:
strb    r6,[r5,0h]             ; Salva a largura atual da RAM
pop     {r5}
Exit:
pop     {r1,r4,r6}
mov     r15,r14
.pool



TileMapMount:
push    {r4}
push    {r5}
ldr     r5,=RAMVarAddress
ldrb    r7,[r5,1h]
cmp     r7,0
beq     IfSize0
;;mov     r6,SizeTeste
ldr     r6,=FontWidthAddress                   ; Caracteres de largura 5 pixel para provar o conceito
add     r6,r1
ldrb    r6,[r6]
add     r6,r7
cmp     r6,8
blt     IfSizeLt
beq     IfSizeEq
IfSizeGt:
mov     r7,8
sub     r6,r7
strb    r6,[r5,1h]
b       Original
IfSizeEq:
; ldrb    r4,[r5,2h]
; add     r4,r4,1       ; dx da caixa de diálogo
; strb    r4,[r5,2h]
mov     r6,0
IfSizeLt:
strb    r6,[r5,1h]
pop     {r5}
pop     {r4}
mov     r15,r14
IfSize0:
;mov     r6,SizeTeste
ldr     r6,=FontWidthAddress                   ; Caracteres de largura 5 pixel para provar o conceito
add     r6,r1
ldrb    r6,[r6]
strb    r6,[r5,1h]

Original:
ldrb    r4,[r5,2h]
pop     {r5}
ldrb    r6,[r5,0Eh]
add     r0,r6,1       ; dx da caixa de diálogo
strb    r0,[r5,0Eh]
ldrb    r0,[r5,1Ah]   ; x0 da caixa de diálogo
add     r6,r6,r0      ; x = x0 + dx
ldrb    r7,[r5,0Fh]   ; y0 da caixa de diálogo
lsl     r7,r7,1h      ; y0*2, afinal os caracteres ocupam 2 tiles na vertical
ldrb    r0,[r5,1Bh]   ; dy
add     r7,r7,r0      ; y = y0 + dy
lsl     r0,r4,1h      ; x2 porque cada caractere ocupa 2 tiles.
;;lsl     r0,r3,1h      ; x2 porque cada caractere ocupa 2 tiles.
add     r0,40h        ; Começa a ser montado na obj vram a partir do tile 40h
mov     r2,0F2h       ; Parte alta do atributo
lsl     r2,r2,8h      ; F200
orr     r0,r2         ; Monta o atributo daquele tile
ldr     r2,[r5,30h]   ; Endereço base do tilemap da caixa de diálogo
lsl     r6,r6,1h      ; r6 x2 -> Vai nos dar a posição X na caixa de diálogo
lsl     r7,r7,6h      ; r7 x64 -> Vai nos dar a posição Y na caixa de diálogo
add     r2,r2,r6      ; 
add     r2,r2,r7      ; Atual = Base + 2*x + 64*y
strh    r0,[r2]       ; Parte de cima do caractere
add     r0,1h
add     r2,40h        ; +64 bytes
strh    r0,[r2]       ; Parte de baixo do caractere
push    {r5}
ldr     r5,=RAMVarAddress
add     r4,r4,1       ; dx da caixa de diálogo
strb    r4,[r5,2h]
pop     {r5}
pop     {r4}
mov     r15,r14       ; retorna
.pool

FnCopyCharNewLine:
push    {r1,r5}
ldr     r5,=RAMVarAddress
ldrb    r0,[r5,0h]             ; Salva a largura atual da RAM
mov     r1,0h         ; Zera o número de pixel usados do tile atual
strb    r1,[r5,0h]             ; Salva a largura atual da RAM
pop     {r1,r5}
cmp     r0,0
beq     FnCopyCharNewLine_1
ldrb    r0,[r5,2h]
add     r0,1h             ; Um caractere copiado
strb    r0,[r5,2h]
FnCopyCharNewLine_1:
add     r4,1h         ; Avança um caractere no bloco de texto
mov     r0,1h         ; Retorna true?? 
mov     r15,r14
.pool

;; Função do caractere E8 (nova linha) executada durante a montagem do tilemap
;;
FnTileMapNewLine:
push    {r4}
ldr     r4,=RAMVarAddress
ldrb    r0,[r4,1h]             ; Salva a largura atual da RAM
cmp     r0,0
beq     FnTileMapNewLine_1
; ldrb    r0,[r4,2h]
; add     r0,1h             ; Um caractere copiado
; strb    r0,[r4,2h]
FnTileMapNewLine_1:
mov     r0,0
strb    r0,[r4,1h]          ; Adicionado o reset dessa variável, responsável por guardar quantos pixel foram usados no tile atual.
;;strb    r0,[r5,2h]          ; Adicionado o reset dessa variável, responsável por guardar quantos tiles foram avançados
strb    r0,[r5,0Eh]   ; dx = 0
ldrb    r0,[r5,0Fh]  
add     r0,1h         ; dy += 1
strb    r0,[r5,0Fh]   
pop     {r4}
add     r4,1h         ; Avança um caractere
mov     r15,r14
.pool

;; E9
FnCopyCharPressBtn:
push    r14
mov     r0,1h
push    r1
ldrb    r1,[r5,3h]
orr     r1,r0
strb    r1,[r5,3h]
pop     r1
add     r4,1h
str     r4,[r5,2Ch]
mov     r0,0h
strb    r0,[r5,4h]
;;strb    r0,[r5,18h]     ; Adicionado o reset desta variável
str     r0,[r5,5Ch]
strb    r0,[r5,2h]
mov     r0,5h
strb    r0,[r5,12h]
mov     r0,0h
push    {r5}
ldr     r5,=RAMVarAddress
strb    r0,[r5,0h]     ; Adicionado o reset desta variável
pop     {r5}
pop     r15
.pool

;; EE ========
;; Cópia do caractere
;; Byte de controle EEh - 
FnCopyCharShowOption:
ldrb    r1,[r4,1h]        ;; Lê o primeiro argumento
cmp     r1,2h             ;; 
bne     BranchIfNot2          ;; Se não for 2
ldrb    r0,[r4,2h]        ;; Lê o segundo argumento
strb    r0,[r5,1Ah]       ;; Muda o X0 da caixa de diálogo
ldrb    r0,[r4,3h]        ;; Lê o terceiro argumento
strb    r0,[r5,1Bh]       ;; Muda o Y0 da caixa de diálogo
BranchIfNot2:
ldr     r0,=NuArgs
ldrb    r1,[r4,1h]
ldrb    r0,[r0,r1]        ;; Carrega a quantidade de argumentos em r0
add     r4,r4,r0          ;; Avança r0 posições
;; 
push    {r4}
ldr     r4,=RAMVarAddress
ldrb    r0,[r4,0h]
cmp     r0,0
beq     BranchIfFullorEmpty
cmp     r0,8
beq     BranchIfFullorEmpty
ldrb    r0,[r5,2h]
add     r0,1h             ; Um caractere copiado
strb    r0,[r5,2h]
mov     r0,0
strb    r0,[r4,0h]       ; Reseta os pixels usados no tile atual. 
BranchIfFullorEmpty:
pop     {r4}
mov     r0,1h             ;; Retorna true?
mov     r15,r14
.pool
NuArgs:
.db     03h, 03h, 04h, 00h
; 0802127A 0000     lsl     r0,r0,0h        ;; padding
; 0802127C 1280     asr     r0,r0,0Ah       ;; 8021280h
; 0802127E 0802     lsr     r2,r0,20h
; 08021280 0303     lsl     r3,r0,0Ch       ;; Posições
; 08021282 0004     lsl     r4,r0,0h
;; =====================================
;; Montagem da tilemap
;; Byte de controle EEh - 
; 08021284 7861     ldrb    r1,[r4,1h]        ;; Lê o primeiro argumento
; 08021286 2900     cmp     r1,0h             ;; Se for 0
; 08021288 D002     beq     8021290h
; 0802128A 2901     cmp     r1,1h             ;; Se for 1
; 0802128C D006     beq     802129Ch
; 0802128E E009     b       80212A4h          ;; Se não
        ; ;; Se 0
; 08021290 78A1     ldrb    r1,[r4,2h]        ;; Lê o segundo argumento
; 08021292 7BA8     ldrb    r0,[r5,0Eh]       ;; Carrega dx
; 08021294 1840     add     r0,r0,r1          ;; 
; 08021296 73A8     strb    r0,[r5,0Eh]       ;; dx += r0
; 08021298 3403     add     r4,3h             ;; Avança 3 posições 
; 0802129A E004     b       80212A6h
        ; ;; Se 1
; 0802129C 78A0     ldrb    r0,[r4,2h]        ;; Lê o segunda argumento
; 0802129E 73A8     strb    r0,[r5,0Eh]       ;; dx = r0
; 080212A0 3403     add     r4,3h             ;; Avança 3 posições
; 080212A2 E000     b       80212A6h
        ; ;; Se nao
; 080212A4 3404     add     r4,4h             ;; Avança 4 posições
; 080212A6 46F7     mov     r15,r14           ;; retorna
; .pool

FontWidthAddress:
;;  00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
.db  5, 8, 6, 8, 8, 8, 8, 8, 8, 8, 8, 8, 7, 7, 7, 8  ; 00 ' ' 0 1 2 3 4 5 6 7 8 9 a b c d e
.db  6, 7, 7, 2, 5, 7, 2, 8, 7, 7, 7, 7, 6, 7, 6, 7  ; 10  f g h i j k l m n o p q r s t u
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 8, 8  ; 20  v w x y z A B C D E F G H I J K
.db  7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; 30  L M N O P Q R S T U V W X Y Z v2
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 3, 8, 8, 8, 3, 5  ; 40  v2 - x = : ? + ./.  x * !       & ,
.db  4, 3, 3, 3, 4, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; 50   . . ; ' "
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; 60
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; 70
.db  8, 8, 8, 8, 7, 8, 8, 3, 7, 7, 7, 7, 7, 7, 7, 8  ; 80  ç    í ò ó õ ô ö ú ü
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; 90
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; A0
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; B0
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; C0
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; D0
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; E0
.db  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8  ; F0

; Editando fonte original do jogo, com caracteres alinhados à esquerda devido à VWF
.org 0x086965f0
.import "Gráficos/vwf_font.gba"

; Adicionando fonte sem VWF, para uso em áreas específicas do jogo
.org 0x087F4B10
nonvwf_font:
  .incbin "Gráficos/nonvwf_font.gba"

; Alterando ponteiros de lugares específicos, para fazer uso da fonte sem VWF
.org 0x08025228 ; Nome do bairro, no canto inferior direito
.dw nonvwf_font
  
.org 0x08026030 ; Menu "Folder", nomes dos chips, seção "Pack" esquerda
.dw nonvwf_font
  
.org 0x080264A4 ; Menu "Folder", nomes dos chips, seção "Folder" direita
.dw nonvwf_font
  
.org 0x08026E2C ; Menu "Folder", descrições de chips
.dw nonvwf_font

.org 0x080273A0 ; Menu "Folder", nomes 'Drtr1/Drtr2/Drtr3'
.dw nonvwf_font
  
.org 0x08028590 ; Mail
.dw nonvwf_font
  
.org 0x08028984 ; Key Items
.dw nonvwf_font
  
.org 0x0802952C ; Menu "Library", nomes dos chips
.dw nonvwf_font

.org 0x0802A5A4 ; Menu "Save"
.dw nonvwf_font

.org 0x0802AD90 ; Subchips
.dw nonvwf_font
  
.org 0x0802B6CC ; Network
.dw nonvwf_font

.close
