:: Arquivo .bat que remonta a rom traduzida. Funciona lendo a rom original
:: americana, no arquivo nomeado "Mega Man Battle Network 2 (USA).gba", criando
:: uma cópia dela, e aplicando nela as alterações da tradução, cumulativamente.
:: Se funcionado, ao final do processo deve ser gerada a rom traduzida, com
:: nome "Mega Man Battle Network 2 (BR).gba".
::
:: Escrito por Solid One e Denim - Setembro de 2022
@echo off
echo ==Gerando rom traduzida. Aperte enter quando a mensagem "Done" ao final aparecer.==
.\Ferramentas\TextPet.exe run-script insert.tpl

echo ==Aplicando patches extras na rom modificada:==

echo ==Fonte VWF==
.\Ferramentas\armips.exe .\Asm\vwf.asm

echo ==Fonte VWF reduzida, para as descricoes de chips==
.\Ferramentas\armips.exe .\Asm\fonte_descricoes.asm

echo ==Graficos descomprimidos==
.\Ferramentas\armips.exe .\Asm\graficos.asm

echo ==Graficos comprimidos==
::call recomprimir_graficos_comprimidos.bat
.\Ferramentas\armips.exe .\Asm\graficos_comprimidos.asm

echo ==Expandindo rom para 16mb==
.\Ferramentas\armips.exe .\Asm\expansor_rom.asm

echo Done.
pause