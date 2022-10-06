@echo off

copy "ROM Original\0468 - MegaMan Battle Network 2 (U)(Mode7).gba" "ROM Modificada\0468 - MegaMan Battle Network 2 (U)(Mode7).gba" /B/Y

cd Asm
armips.exe  mmbn_nointro.asm
armips.exe  mmbn_vwf.asm
cd ..

cd Programas
pypy tl_dumper.py -m i -s "../Textos Traduzidos" -d "../ROM Modificada/0468 - MegaMan Battle Network 2 (U)(Mode7).gba"
cd ..

cd "ROM Modificada"
call do_patch.bat
cd ..
