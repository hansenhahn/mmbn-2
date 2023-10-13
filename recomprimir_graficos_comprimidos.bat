:: Arquivo .bat que recomprime gráficos comprimidos, previamente dumpados
:: pelas tools do Denim. Útil para fazer re-edições, se necessário.
:: NOTA: Nem todos os arquivos são recomprimidos com sucesso, causando bugs
:: no processo de remontagem. Use com cautela.
::
:: Escrito por Solid One - Outubro de 2023
@echo off
echo ==Recomprimindo graficos comprimidos, na pasta "Graficos/Comprimidos/Editados"==
copy ".\Graficos\Comprimidos\Editados\*.gba" ".\Graficos\Comprimidos\Recomprimidos\"
for /f "delims=" %%f in ('dir /b .\Graficos\Comprimidos\Recomprimidos\*.gba') do (
    .\Ferramentas\lzss.exe -evn ".\Graficos\Comprimidos\Recomprimidos\%%f"
)

::echo Recomprimindo grafico do offset '01f24c', da cidade ACDC...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f24c-td"

echo Recomprimindo grafico do offset '01f3fc', do logo 'Official Center' miudo em Ameropa...
.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f3fc-td"

::echo Recomprimindo grafico do offset '01f2d0'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f2d0-td"

::echo Recomprimindo grafico do offset '01f2dc', da estação de metro do porto das aguas...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f2dc-td"

::echo Recomprimindo grafico do offset '01f2e8'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f2e8-td"

::echo Recomprimindo grafico do offset '01f33c'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f33c-td"

::echo Recomprimindo grafico do offset '01f36c'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f36c-td"

::echo Recomprimindo grafico do offset '01f378'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f378-td"

::echo Recomprimindo grafico do offset '01f384'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f384-td"

::echo Recomprimindo grafico do offset '01f390', da estação de metro do aeroporto...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f390-td"

::echo Recomprimindo grafico do offset '01f39c'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f39c-td"

::echo Recomprimindo grafico do offset '01f3a8'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f3a8-td"

::echo Recomprimindo grafico do offset '01f3c0'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f3c0-td"

::echo Recomprimindo grafico do offset '01f4a4'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f4a4-td"

::echo Recomprimindo grafico do offset '01f528'...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f528-td"

::echo Recomprimindo grafico do offset '01f720', do PC da Yai...
::.\Ferramentas\armips.exe .\Asm\remontar_bgs_comprimidos.asm -strequ output "img-01f720-td"

echo Deletando arquivos temporarios...
del ".\Graficos\Comprimidos\Recomprimidos\*_grafico*.gba"