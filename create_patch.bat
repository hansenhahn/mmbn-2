@echo off
del "[GBA] Mega Man Battle Network 2 (U) (1.2).*"
cd ".\Ferramentas\"
.\flips.exe -c "..\Mega Man Battle Network 2 (USA).gba" "..\Mega Man Battle Network 2 (BR).gba" "..\[GBA] Mega Man Battle Network 2 (U) (1.2).ips"
.\xdelta.exe -e -s "..\Mega Man Battle Network 2 (USA).gba" "..\Mega Man Battle Network 2 (BR).gba" "..\[GBA] Mega Man Battle Network 2 (U) (1.2).xdelta"
.\7z.exe a -tzip "..\[GBA] Mega Man Battle Network 2 (U) (1.2).zip" "..\[GBA] Mega Man Battle Network 2 (U) (1.2).xdelta" "..\[GBA] Mega Man Battle Network 2 (U) (1.2).ips" "..\LEIAME.txt"