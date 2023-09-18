<?php
$graficos = [
    (object)['nome' => 'Trap pequeno', 'offset' => '0x3157FC', 'tiles' => '1x4'],
    (object)['nome' => 'Trap grande', 'offset' => '0x315A20', 'tiles' => '2x4'],
    (object)['nome' => 'Trap grande', 'offset' => '0x315D24', 'tiles' => '2x4'],
    (object)['nome' => 'Trap grande', 'offset' => '0x315FA8', 'tiles' => '2x4'],
    (object)['nome' => 'Fonte menus', 'offset' => '0x69E650', 'tiles' => '9x32'],
    (object)['nome' => 'New', 'offset' => '0x6A1150', 'tiles' => '2x8'],
    (object)['nome' => 'Fonte nomes batalhas', 'offset' => '0x6BFAA8', 'tiles' => '6x16'],
    (object)['nome' => 'Busy', 'offset' => '0x6C0968', 'tiles' => '7x4'],
    (object)['nome' => 'PAUSE', 'offset' => '0x6CB908', 'tiles' => '2x6'],
    (object)['nome' => 'CUSTOM', 'offset' => '0x6CBFC8', 'tiles' => '1x4'],
    (object)['nome' => 'L or R', 'offset' => '0x6CC0A8', 'tiles' => '2x4'],
    (object)['nome' => 'CHIP SELECT', 'offset' => '0x6CC7E8', 'tiles' => '1x7'],
    (object)['nome' => 'OK slash ADD', 'offset' => '0x6CD200', 'tiles' => '3x7'],
    (object)['nome' => 'Fontes nomes batalhas', 'offset' => '0x6CDF20', 'tiles' => '2x27'],
    (object)['nome' => 'Nomes tela vitória', 'offset' => '0x6CE840', 'tiles' => '19x6'],
    (object)['nome' => 'WINNER', 'offset' => '0x6CF9F0', 'tiles' => '11x3'],
    (object)['nome' => 'DeltTime', 'offset' => '0x6CFF70', 'tiles' => '12x2'],
    (object)['nome' => 'Busting level', 'offset' => '0x6D0290', 'tiles' => '9x2'],
    (object)['nome' => 'GET DATA', 'offset' => '0x6D0610', 'tiles' => '9x2'],
    (object)['nome' => 'LOSER', 'offset' => '0x6D0E40', 'tiles' => '10x3'],
    (object)['nome' => 'Lost chip data', 'offset' => '0x6D13E0', 'tiles' => '16x2'],
    (object)['nome' => 'LOST DATA', 'offset' => '0x6D1960', 'tiles' => '9x2'],
    (object)['nome' => 'Fonte nomes chips ganhos ou perdidos após a batalha', 'offset' => '0x6D2190', 'tiles' => '2x27'],
    (object)['nome' => 'Press A button', 'offset' => '0x6D2BD0', 'tiles' => '9x2'],
    (object)['nome' => 'ATTACK + 20', 'offset' => '0x6E0730', 'tiles' => '8x7'],
    (object)['nome' => 'ATTACK + 30', 'offset' => '0x6E0E30', 'tiles' => '8x7'],
    (object)['nome' => 'NAVI + 30', 'offset' => '0x6E1530', 'tiles' => '8x7'],
    (object)['nome' => 'Diversos chips com nomes', 'offset' => '0x70B530', 'tiles' => '8x42'],
    (object)['nome' => 'ADDITIONAL CHIP DATA - Discard selected chips', 'offset' => '0x71B830', 'tiles' => '8x7'],
    (object)['nome' => 'CHIP DATA TRANSMISSION - Sending chip data', 'offset' => '0x71BF30', 'tiles' => '8x7'],
    (object)['nome' => 'NO DATA SELECTED - Choose a chip', 'offset' => '0x71D430', 'tiles' => '8x7'],
    (object)['nome' => 'NO DATA', 'offset' => '0x71DB30', 'tiles' => '8x7'],
    (object)['nome' => 'Números andares prédio', 'offset' => '0x7AE7C0', 'tiles' => '4x18'],
    (object)['nome' => 'NAL animado no monitor', 'offset' => '0x7AC6E0', 'tiles' => '18x13'],
    (object)['nome' => 'Nomes menus (folder chips mail)', 'offset' => '0x7CE940', 'tiles' => '7x10'],
    (object)['nome' => 'Nomes menus (folder pack PAmemory patttern chips battles)', 'offset' => '0x7D08DC', 'tiles' => '10x29'],
    (object)['nome' => 'Board', 'offset' => '0x7D261C', 'tiles' => '7x2'],
    (object)['nome' => 'Request', 'offset' => '0x7D295C', 'tiles' => '6x2'],
    (object)['nome' => 'Fonte números menus', 'offset' => '0x7D7068', 'tiles' => '11x2'],
    (object)['nome' => 'Bug Frag', 'offset' => '0x7D8B54', 'tiles' => '5x2'],
    (object)['nome' => 'Presented By Capcom', 'offset' => '0x7E6D7C', 'tiles' => '12x5'],
    (object)['nome' => 'Licensed by nintendo', 'offset' => '0x7E97A8', 'tiles' => '14x1'],
    (object)['nome' => 'GAME OVER', 'offset' => '0x7EA268', 'tiles' => '25x4'],
    (object)['nome' => 'PRESS START', 'offset' => '0x7EBAE8', 'tiles' => '4x8'],
    (object)['nome' => 'NEW GAME CONTINUE', 'offset' => '0x7EC3A8', 'tiles' => '4x9'],
    (object)['nome' => 'COPYRIGHT tela-título', 'offset' => '0x7EC928', 'tiles' => '4x31'],
    (object)['nome' => 'CONT HARD', 'offset' => '0x7ED8A8', 'tiles' => '4x6'],
];

foreach($graficos as $g){
    $caminho = "Graficos/Originais/{$g->offset} - {$g->nome}.gba";
    $offset_decimal = hexdec(str_replace('0x', '', $g->offset));
    $tiles = explode('x', $g->tiles);
    $tamanho = $tiles[0] * $tiles[1] * 32;

    shell_exec("dd if='Mega Man Battle Network 2 (USA).gba' of='$caminho' skip=$offset_decimal count=$tamanho bs=1");
}