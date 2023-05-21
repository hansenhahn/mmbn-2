@echo off
echo ==Gerando rom traduzida. Aperte enter quando a mensagem "Done" abaixo aparecer.==
.\Ferramentas\TextPet.exe run-script insert.tpl

echo ==Aplicando patches extras na rom modificada:==

echo ==Fonte VWF==
.\Ferramentas\armips.exe .\Asm\vwf.asm

echo ==Fonte VWF reduzida, para as descricoes de chips.==
.\Ferramentas\armips.exe .\Asm\fonte_descricoes.asm

echo ==Graficos diversos.==
.\Ferramentas\armips.exe .\Asm\graficos.asm
::.\Ferramentas\armips.exe .\Asm\graficos_comprimidos.asm

echo Done.
pause