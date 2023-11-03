@echo off
del "[GBA] Mega Man Battle Network 2 (U) (1.0).*"
cd ".\Ferramentas\"
.\xdelta.exe -e -s "..\Mega Man Battle Network 2 (USA).gba" "..\Mega Man Battle Network 2 (BR).gba" "..\[GBA] Mega Man Battle Network 2 (U) (1.0).xdelta"
7z a -tzip "..\[GBA] Mega Man Battle Network 2 (U) (1.0).zip" "..\[GBA] Mega Man Battle Network 2 (U) (1.0).xdelta" "..\LEIAME.txt"