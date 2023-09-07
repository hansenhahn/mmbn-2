@echo off
echo ==Gerando rom traduzida. Aperte enter quando a mensagem "Done" abaixo aparecer.==
.\Ferramentas\TextPet.exe run-script insert.tpl

echo ==Aplicando patches extras na rom modificada:==

echo ==Fonte VWF==
.\Ferramentas\armips.exe .\Asm\vwf.asm

echo ==Fonte VWF reduzida, para as descricoes de chips==
.\Ferramentas\armips.exe .\Asm\fonte_descricoes.asm

echo ==Graficos descomprimidos==
.\Ferramentas\armips.exe .\Asm\graficos.asm

::echo ==Graficos comprimidos==
::copy ".\Graficos\Comprimidos\Editados\0x3dde2c - ON AIR.gba" ".\Graficos\Comprimidos\Recomprimidos\"
::.\Ferramentas\lzss.exe -evn ".\Graficos\Comprimidos\Recomprimidos\0x3dde2c - ON AIR.gba"
::.\Ferramentas\armips.exe .\Asm\graficos_comprimidos.asm

echo Done.
pause