load-plugins "Ferramentas/plugins"
game mmbn2
load-file-index "Ferramentas/indexes/mmbn2-us.tpi"
read-text-archives "Mega Man Battle Network 2 (USA).gba"
read-text-archives "Scripts/script.tpl" --format tpl --patch
write-text-archives "Mega Man Battle Network 2 (BR).gba"