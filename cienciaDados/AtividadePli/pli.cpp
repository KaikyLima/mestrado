#include <iostream>
#include <unordered_map>
#include <vector>

using namespace std;

void imprimir_pli(char nome, int coluna[], int tamanho) {
    unordered_map<int, vector<int>> grupos;
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
        cout << "Vazia (não há redundância)";
    }
    cout << endl;
}

int main() {
    int tamanho = 5;
    int colunaA[tamanho] = {1, 2, 1, 4, 1};
    int colunaB[tamanho] = {9, 8, 9, 6, 8};
    int colunaC[tamanho] = {3, 3, 4, 3, 4};

    cout << "--- Construindo as PLIs ---\n\n";

    imprimir_pli('A', colunaA, tamanho);

    imprimir_pli('B', colunaB, tamanho);

    imprimir_pli('C', colunaC, tamanho);

    return 0;
}