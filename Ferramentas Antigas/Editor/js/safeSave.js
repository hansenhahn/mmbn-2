/* Functions used to force save files in ANSI format
 */
var safeSaveLoad = 0;

function splitPath(DatLen, Len) {
	var outSplit = [];
	while (DatLen >= Len) {
		outSplit.push(Len);
		DatLen -= Len;
	}
	if (DatLen != 0) {
		outSplit.push(DatLen);
	}
	return outSplit;
}

function safeSave(name, Data, PathLength) {//Data as array             
	// !Elem:LoadSaveDi
	safeSaveLoad = 0;
	if (!PathLength) {
		PathLength = 100000;
	}
	var buffer = new ArrayBuffer(Data.length)
			, temp = new DataView(buffer)
			, n32 = Math.floor(Data.length / 4)
			, n16 = Math.floor((Data.length - n32 * 4) / 2)
			, n8 = Data.length - n32 * 4 - n16 * 2
			, Kkey = 0, K = -1
			, APath = splitPath(n32, PathLength)
			;
	if (APath == '') {
		APath = [0]
	}

	var RunSasa = setInterval(function () {
		if (Kkey == 0) {
			Kkey = 1;
			K += 1;
		}
		for (var i = 0; i < APath[K]; i++) {
			temp.setUint32((i + K * PathLength) * 4, Data[(i + K * PathLength) * 4] * Math.pow(256, 3) + Data[(i + K * PathLength) * 4 + 1] * Math.pow(256, 2) + Data[(i + K * PathLength) * 4 + 2] * 256 + Data[(i + K * PathLength) * 4 + 3]);
		}
		Kkey = 0;
		safeSaveLoad = Math.round(1000 * (K + 1) / APath.length) / 1000;
		if (K + 1 == APath.length) {
			clearInterval(RunSasa);
			if (n16 != 0) {
				temp.setUint16(n32 * 4, Data[n32 * 4] * 256 + Data[n32 * 4 + 1]);
			}
			if (n8 != 0) {
				temp.setUint8(n32 * 4 + n16 * 2, Data[n32 * 4 + n16 * 2]);
			}
			saveAs(new Blob([buffer], {type: "binary"}), name);
		}
	}, 10);
}