#include "heap.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    Heap *h = heap_criar(16);
    char linha[256];
    char cmd;
    char nome[50];
    int prioridade;

    while (1) {
        fgets(linha, sizeof(linha), stdin);
        sscanf(linha, " %c", &cmd);

        if (cmd == 'S') {
            heap_destruir(h);
            break;
        }
        else if (cmd == 'I') {
            sscanf(linha, " %c %s %d", &cmd, nome, &prioridade);
            heap_inserir(h, prioridade);
        }
        else if (cmd == 'C') {
            int atendido = heap_remover(h);
            printf("Chamando paciente de prioridade %d\n", atendido);
        }
        else if(cmd == 'M'){
            heap_mostrar(h);
        }
        else if (cmd == 'T'){
            int atendido = heap_topo(h);
            printf("Topo da fila: prioridade %d\n", atendido);
        }
    }

    return 0;
}