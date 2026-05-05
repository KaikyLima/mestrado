#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>
#include <fstream>  
#include <sstream>  

using namespace std;

vector<vector<int>> gerar_pli(const vector<string>& coluna) {
    unordered_map<string, vector<int>> grupos; // criar os 'grupos' de valores iguais
    vector<vector<int>> pli; // aux armazenar grupos com itens repetidos
    int tamanho = coluna.size(); // obtém o tamanho dinamicamente

    for (int i = 0; i < tamanho; i++) { // percorre a coluna e agrupa índices por valor (O(n))
        grupos[coluna[i]].push_back(i); 
    }

    for (auto& par : grupos) { // percorre os grupos (O(k), onde k = número de valores distintos)
        if (par.second.size() > 1) { // mantém apenas valores que aparecem mais de uma vez (O(1))
            pli.push_back(par.second); // adiciona o grupo de índices ao PLI
        }
    }
    return pli; //retorna o grupo de index
}

bool verifica_df(const vector<vector<int>>& pli_determinante, const vector<string>& coluna_dependente) {
    // Para cada grupo da PLI da esquerda
    for (const auto& grupo : pli_determinante) {
        // Para cada vetor dentro do grupo, pega o primeiro valor na coluna dependente na quele index e compara com os proximos index 
        string valor_referencia = coluna_dependente[grupo[0]];
        for (size_t i = 1; i < grupo.size(); i++) {
            if (coluna_dependente[grupo[i]] != valor_referencia) { //se alguem for diferente = NAO
                return false; 
            }
        }
    }
    return true;
}

int main() {
    ifstream arquivo("dados.csv");
    string linha;
    vector<vector<string>> colunas;
    bool primeiraLinha = true;

    while (getline(arquivo, linha)) { //O(n × m) linha x coluna
        stringstream ss(linha);
        string celula;
        int i = 0;

        while (getline(ss, celula, ',')) {
            if (primeiraLinha) {
                colunas.push_back({celula});
            } else {
                colunas[i].push_back(celula);
            }
            i++;
        }
        primeiraLinha = false;
    }
    vector<vector<int>> pli0 = gerar_pli(colunas[0]);
    cout << "0 -> 1: " << (verifica_df(pli0, colunas[1]) ? "SIM" : "NAO") << endl;
    cout << "0 -> 2: " << (verifica_df(pli0, colunas[2]) ? "SIM" : "NAO") << endl;

    return 0;
}