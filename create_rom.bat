@echo off

copy "ROM Original\0468 - MegaMan Battle Network 2 (U)(Mode7).gba" "ROM Modificada\0468 - MegaMan Battle Network 2 (U)(Mode7).gba" /B/Y

cd Asm
armips.exe  mmbn_nointro.asm
armips.exe  mmbn_vwf.asm
cd ..
