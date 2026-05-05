#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {
    ofstream arquivo("dados.csv");

    for (int i = 0; i < 100000; i++) {
        // Criando um padrão: a cada 10 linhas o ID muda
        int id = i / 10; 
        string nomeCategoria = "Cat_" + to_string(id);
        
        // Coluna 2 terá um valor que quebra a dependência (id % 2)
        int valorQuebra = i % 2; 

        arquivo << id << ","                // Coluna 0
                << nomeCategoria << ","     // Coluna 1 (Dependente de 0)
                << valorQuebra << ","       // Coluna 2 (NÃO dependente de 0)
                << "Dada_" << i << ","      // Coluna 3 (Único)
                << "Fixo" << "\n";          // Coluna 4 (Constante)
    }

    arquivo.close();
    cout << "Arquivo dados.csv gerado!" << endl;
    return 0;
}