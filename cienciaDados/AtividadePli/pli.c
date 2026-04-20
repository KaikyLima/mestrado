#include <stdio.h>
#include <stdbool.h>

// A mesmíssima função pura de antes! Nenhuma linha mudou.
bool verifica_dependencia(int X[], int Y[], int tamanho) {
    for (int i = 0; i < tamanho; i++) {
        for (int j = i + 1; j < tamanho; j++) {
            if (X[i] == X[j]) {           
                if (Y[i] != Y[j]) {       
                    return false;         
                }
            }
        }
    }
    return true; 
}

int main() {
    int tamanho = 5;
    int num_colunas = 3;
    
    // Nomes para ficar bonito na tela
    char nomes[3] = {'A', 'B', 'C'};

    // Colocamos as colunas dentro de uma estrutura única (uma matriz)
    // Onde o índice 0 é a coluna A, índice 1 é a B, e índice 2 é a C.
    int colunas[3][5] = {
        {1, 2, 1, 4, 5}, // [0] Coluna A
        {9, 8, 9, 6, 7}, // [1] Coluna B
        {3, 3, 4, 3, 3}  // [2] Coluna C
    };

    printf("Testando TODAS as combinacoes automaticamente:\n\n");

    // Loop da Esquerda (A, depois B, depois C)
    for (int esq = 0; esq < num_colunas; esq++) {
        
        // Loop da Direita (A, depois B, depois C)
        for (int dir = 0; dir < num_colunas; dir++) {
            
            // Nós não queremos testar se A -> A (pois a mesma coluna sempre determina ela mesma)
            if (esq == dir) {
                continue; 
            }

            // Chama a nossa função passando a coluna da esquerda e a coluna da direita
            if (verifica_dependencia(colunas[esq], colunas[dir], tamanho)) {
                printf("%c -> %c : VERDADEIRO\n", nomes[esq], nomes[dir]);
            } else {
                printf("%c -> %c : FALSO\n", nomes[esq], nomes[dir]);
            }
            
        }
    }

    return 0;
}