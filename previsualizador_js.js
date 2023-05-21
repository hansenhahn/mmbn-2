let $textareaDescricoes = $('#descricoes');

let codeMirrorObject = CodeMirror.fromTextArea($textareaDescricoes[0], {
    lineNumbers: true,
    mode: 'python',
    theme: 'abcdef',
});

codeMirrorObject.on('cursorActivity', function(i, c) {
    let $divPrevia = $('#previa');
    let $spanDescricao = $divPrevia.children('span.descricao');

    let cursor = codeMirrorObject.doc.getCursor(); 
    let currentLine = cursor.line;
    let firstLineSelection = currentLine - 6;
    let lastLineSelection = currentLine + 6;

    if (firstLineSelection < 0) firstLineSelection = 0;
    
    let range = codeMirrorObject.doc.getRange({line: firstLineSelection, ch: 0}, {line: lastLineSelection, ch: 0});
    const regex = /"""([^\"]*)\"""/mg;
    while ((m = regex.exec(range)) !== null) {
        if (m.index === regex.lastIndex) {
            regex.lastIndex++;
        }
        
        m.forEach((match, groupIndex) => {
            if (groupIndex == 1) {
                match = match.replace(/\t/g, '').trim();

                $spanDescricao.html('');
                if (!match.includes('keyWait') && !match.includes('msgCloseQuick')) {
                    for(let i = 0; i < match.length; i++) {
                        if (match[i] == '\n') {
                            $spanDescricao.append('<br />');
                        } else {
                            let char = formatarCaractere(match[i]);
                            
                            var $spanCaractere = $('<span />').addClass('caractere ' + char).html('&nbsp;');
                            $spanDescricao.append($spanCaractere);
                        }
                    }
                }
            }
        });
    }
});

function formatarCaractere(char) {
    var charTable = {
        // Symbols
        ' ': 'space', '!': 'exclamation', '"': 'double-quotes', '#': 'cerquilha',
        '$': 'money-sign', '%': 'percent', '&': 'ampersand', "'": 'quotes',
        "(": 'open-parenthesis', ")": 'close-parenthesis', '*': 'asterisk',
        '+': 'plus', ',': 'comma', '-': 'minus', '.': 'dot', '/': 'slash',
        ':': 'colon', ';': 'semicolon', '<': 'less-than', '=': 'equal', '>': 'greater-than',
        '?': 'interrogation', '@': 'at-sign',
        '©': 'copyright', '[': 'open-square-brackets', ']': 'close-square-brackets',
        '_': 'underscore', '¡': 'inverted-exclamation',
        '¿': 'inverted-interrogation', 'º': 'o-ordinal', 'ª': 'a-ordinal',
        
        // Numbers
        '0': 'n0', '1': 'n1', '2': 'n2', '3': 'n3', '4': 'n4', '5': 'n5',
        '6': 'n6', '7': 'n7', '8': 'n8', '9': 'n9',
        
        // Uppercase accents
        'À': 'A-grave', 'Á': 'A-acute', 'Â': 'A-circumflex', 'Ã': 'A-tilde',
        'Ä': 'A-diaeresis', 'Ç': 'C-cedilla', 'È': 'E-grave', 'É': 'E-acute', 
        'Ê': 'E-circumflex', 'Ë': 'E-diaeresis', 'Ẽ': 'E-tilde', 'Ì': 'I-grave',
        'Í': 'I-acute', 'Ï': 'I-diaeresis', 'Î': 'I-circumflex', 'Ò': 'O-grave',
        'Ó': 'O-acute', 'Ô': 'O-circumflex', 'Õ': 'O-tilde', 'Ö': 'O-diaeresis',
        'Ù': 'U-grave', 'Ú': 'U-acute', 'Û': 'U-circumflex', 'Ü': 'U-diaeresis',
        'Ñ': 'N-tilde', 'Ÿ': 'Y-diaeresis',
        
        // Lowercase accents
        'à': 'a-grave', 'á': 'a-acute', 'â': 'a-circumflex', 'ã': 'a-tilde',
        'ä': 'a-diaeresis', 'ç': 'c-cedilla', 'è': 'e-grave', 'é': 'e-acute', 
        'ê': 'e-circumflex', 'ẽ': 'e-tilde', 'ë': 'e-diaeresis', 'ì': 'i-grave',
        'í': 'i-acute', 'ï': 'i-diaeresis', 'î': 'i-circumflex', 'ò': 'o-grave',
        'ó': 'o-acute', 'ô': 'o-circumflex', 'õ': 'o-tilde', 'ö': 'o-diaeresis',
        'ù': 'u-grave', 'ú': 'u-acute', 'û': 'u-circumflex', 'ü': 'u-diaeresis',
        'ñ': 'n-tilde', 'ÿ': 'y-diaeresis'
        
    }
    
    var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".split("");
    for(var i in alphabet){
        var letter = alphabet[i];
        
        charTable[letter] = letter;
    }
    
    var key, newChar;
    for (key in charTable) {
        if(key == char){
            var newValue = charTable[key];
            newChar = char.replace(key, newValue);
            break;
        }
    }
    if(typeof newChar == 'string'){
        return newChar;
    } else {
        return 'unknown';
    }
}

function salvarArquivo() {
    $.post("previsualizador.php", {
        submit: true,
        descricoes: codeMirrorObject.doc.getValue()
    }).done(function (data) {
        var result = $.parseJSON(data);
        
        if(result.success) {
            alert(result.message);
        } else {
            alert('Erro ao salvar arquivo. Detalhes:\n' + result.message);
        }
    });
    
    return false;
}