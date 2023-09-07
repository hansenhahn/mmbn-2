<?php
$graficos = glob('Graficos/Originais/*.gba', GLOB_BRACE);
foreach($graficos as $g){
    $nome_arquivo = str_replace('Graficos/Originais/', '', $g);
    $tmp = explode(' - ', $nome_arquivo);
    
    $offset = str_replace('0x', '', $tmp[0]);

    $x = <<<EOT

;.org 0x08$offset
;.incbin "Graficos/Editados/$nome_arquivo"

EOT;
    echo($x);
}