@echo off
:: Remontando gráfico do "NAL" ao acessar a rede dentro do aeroporto, e copiando ele para a pasta de gráficos recomprimidos
unpacker.exe -is -p 1f678
copy ".\data\img-01f678.bin" "..\..\Graficos\Comprimidos\Recomprimidos\img-01f678-td.bin"
copy ".\data\tm-01f678.bin" "..\..\Mapas de Tiles\img-01f678-tm-a.bin"
copy ".\data\tm-01f678-b.bin" "..\..\Mapas de Tiles\img-01f678-tm-b.bin"
copy ".\data\tm-01f678-c.bin" "..\..\Mapas de Tiles\img-01f678-tm-c.bin"
copy ".\data\tm-01f678-d.bin" "..\..\Mapas de Tiles\img-01f678-tm-d.bin"
copy ".\data\tm-01f678-e.bin" "..\..\Mapas de Tiles\img-01f678-tm-e.bin"
..\lzss.exe -evn "..\..\Mapas de Tiles\img-01f678-tm-a.bin"
..\lzss.exe -evn "..\..\Mapas de Tiles\img-01f678-tm-b.bin"
..\lzss.exe -evn "..\..\Mapas de Tiles\img-01f678-tm-c.bin"
..\lzss.exe -evn "..\..\Mapas de Tiles\img-01f678-tm-d.bin"
..\lzss.exe -evn "..\..\Mapas de Tiles\img-01f678-tm-e.bin"