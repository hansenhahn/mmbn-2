@echo off
del "[GBA] Mega Man Battle Network 2 (U) (1.1).*"
cd ".\Ferramentas\"
.\xdelta.exe -e -s "..\Mega Man Battle Network 2 (USA).gba" "..\Mega Man Battle Network 2 (BR).gba" "..\[GBA] Mega Man Battle Network 2 (U) (1.1).xdelta"
.\7z.exe a -tzip "..\[GBA] Mega Man Battle Network 2 (U) (1.1).zip" "..\[GBA] Mega Man Battle Network 2 (U) (1.1).xdelta" "..\LEIAME.txt"