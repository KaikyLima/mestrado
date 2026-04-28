#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>

using namespace std;

void achar_imprimir_pli(char nome, string coluna[], int tamanho) {
    unordered_map<string, vector<int>> grupos;
    for (int i = 0; i < tamanho; i++) {
        grupos[coluna[i]].push_back(i);
    }
    cout << "PLI da Coluna " << nome << ": ";
    bool encontrou = false;

    for (auto& par : grupos) {
        if (par.second.size() > 1) {
            encontrou = true;
            cout << "[ ";
            for (int idx : par.second) {
                cout << idx << " ";
            }
            cout << "] ";
        }
    }
    if (!encontrou) {
        cout << "Sem duplicata";
    }
    cout << endl;
}

int main() {
    int tamanho = 5;
    string colunaA[tamanho] = {"1", "2", "1", "4", "1"};
    string colunaB[tamanho] = {"9", "8", "9", "6", "8"};
    string colunaC[tamanho] = {"3", "3", "4", "3", "4"};
    string colunaD[tamanho] = {"0", "0", "1", "1", "0"};

    cout << "--- Construindo as PLIs ---\n\n";

    achar_imprimir_pli('A', colunaA, tamanho);

    achar_imprimir_pli('B', colunaB, tamanho);

    achar_imprimir_pli('C', colunaC, tamanho);

    achar_imprimir_pli('D', colunaD, tamanho);

    return 0;
}