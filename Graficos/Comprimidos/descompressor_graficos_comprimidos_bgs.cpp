
/**
 * Script de descompressão de gráficos comprimidos de Backgrounds.
 * 
 * Originalmente compostos por um cabeçalho de 9 DWORds, seguido por três
 * gráficos comprimidos em LZSS. Esse programa extrai dados desses arquivos
 * na forma de um arquivo .ini de cabeçalho, e 3 arquivos de gráficos
 * descomprimidos.
 * 
 * 
 * Escrito por Solid One e pelo ChatGPT - Setembro de 2023
 */
#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdlib>
#include <array>
using namespace std;

std::array<int,3> extractHeaderInfo(std::ifstream& inputFile, std::ofstream& iniFile, std::string& baseName) {
    unsigned int size, pointer, vramPosition;
    std::array<int,3> pointers;

    for (int i = 1; i <= 3; i++) {
        inputFile.read((char*)&size, sizeof(unsigned int));
        inputFile.read((char*)&pointer, sizeof(unsigned int));
        inputFile.read((char*)&vramPosition, sizeof(unsigned int));

        std::string graphBinName = baseName + "_grafico" + std::to_string(i) + ".gba";

        iniFile << "[Grafico" << i << "]\n";
        iniFile << "Arquivo=" << graphBinName << "\n";
        iniFile << "Tamanho=" << size << "\n";
        iniFile << "VRAM=" << vramPosition << "\n\n";
        
        pointers[i-1] = pointer;
    }
    
    return pointers;
}

void runExternalCommand(const std::string& command) {
    std::cout << command.c_str() << std::endl;
    int result = system(command.c_str());
    if (result != 0) {
        std::cerr << "Erro ao executar o comando: " << command << std::endl;
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        std::cout << "MMBN2 - Descompressor de graficos comprimidos de BGs" << std::endl;
        std::cout << "Funciona em conjunto com o GBAmdc.exe para a descompressao." << std::endl << std::endl;
        std::cout << "Uso: " << argv[0] << " <caminho_do_arquivo_binario>" << std::endl;
        return 1;
    }

    std::string filePath = argv[1];
    std::string baseName = filePath.substr(0, filePath.find_last_of('.'));
    std::string headerIniName = baseName + "_cabecalho.ini";
    std::string graphBinName;

    std::ifstream inputFile(filePath, std::ios::binary);
    std::ofstream headerIniFile(headerIniName);

    if (!inputFile.is_open() || !headerIniFile.is_open()) {
        std::cerr << "Erro ao abrir os arquivos." << std::endl;
        return 1;
    }

    std::cout << "Extraindo dados do cabecalho..." << std::endl;
    std::array<int,3> pointers;
    pointers = extractHeaderInfo(inputFile, headerIniFile, baseName);

    std::cout << "Extraindo e descomprimidos graficos pelo 'GBAmdc.exe'..." << std::endl;
    for (int i = 1; i <= 3; i++) {
        graphBinName = baseName + "_grafico" + std::to_string(i) + ".gba";
        int pointer = pointers[i-1];
        std::stringstream command;		
        command << "GBAmdc.exe -e " << filePath << " " << graphBinName << " 0x";
        command << std::hex << (unsigned int)(pointer);
        runExternalCommand(command.str());
    }

    std::cout << "Terminado. Verifique se os arquivos .bin e .gba foram criados de acordo." << std::endl;
    inputFile.close();
    headerIniFile.close();

    return 0;
}
