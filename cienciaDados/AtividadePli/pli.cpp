#include <iostream>

using namespace std;

// Função ultra-simples para calcular e imprimir a PLI de uma coluna
void imprimir_pli(char nome, int coluna[], int tamanho) {
    // Array para não contarmos a mesma linha duas vezes
    bool visitado[10] = {false}; 
    bool encontrou_algum_grupo = false;

    cout << "PLI da Coluna " << nome << ": ";

    // Percorre cada linha da coluna
    for (int i = 0; i < tamanho; i++) {
        
        // Se já agrupamos essa linha antes, pula para a próxima
        if (visitado[i]) continue;

        // Verifica se existe alguém com o mesmo valor mais para frente
        bool tem_repetido = false;
        for (int j = i + 1; j < tamanho; j++) {
            if (coluna[i] == coluna[j]) {
                tem_repetido = true;
                break;
            }
        }

        // A regra de Ouro da PLI (Stripped Partition): 
        // Só nos importam valores que se repetem! Valores únicos são ignorados.
        if (tem_repetido) {
            encontrou_algum_grupo = true;
            cout << "[ "; // Abre um novo grupo (cluster)

            // Varre a coluna novamente pegando os ÍNDICES das linhas iguais
            for (int j = i; j < tamanho; j++) {
                if (coluna[i] == coluna[j]) {
                    cout << j << " "; // Imprime o ID da linha (posição)
                    visitado[j] = true; // Marca como visitado
                }
            }
            cout << "] "; // Fecha o grupo
        }
    }

    // Se nenhuma linha se repetiu, a PLI é vazia
    if (!encontrou_algum_grupo) {
        cout << "Vazia (não há redundância)";
    }
    cout << endl;
}

int main() {
    int tamanho = 5;

    // O mesmo banco de dados "hardcoded" do seu exemplo
    int colunaA[5] = {1, 2, 1, 4, 5};
    int colunaB[5] = {9, 8, 9, 6, 7};
    int colunaC[5] = {3, 3, 4, 3, 3};

    cout << "--- Construindo as PLIs (Position List Indices) ---\n\n";

    // PLI da Coluna A: O valor '1' aparece nas linhas 0 e 2.
    imprimir_pli('A', colunaA, tamanho);

    // PLI da Coluna B: O valor '9' aparece nas linhas 0 e 2.
    imprimir_pli('B', colunaB, tamanho);

    // PLI da Coluna C: O valor '3' aparece nas linhas 0, 1, 3 e 4.
    imprimir_pli('C', colunaC, tamanho);

    cout << "\n---------------------------------------------------\n";
    cout << "Repare que os VALORES sumiram. A PLI guarda apenas\n";
    cout << "as POSICOES das linhas que sao iguais. E o que e unico\n";
    cout << "foi descartado para economizar memoria!\n";

    return 0;
}