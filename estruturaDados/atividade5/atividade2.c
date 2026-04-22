#include <stdio.h>
#include <math.h>
#include "lista.h"

int main() {
    Lista drone;
    inicializar(&drone);
    elemento temp;

    printf("\n1. insercao\n");
    inserir_fim(&drone, 101);
    inserir_fim(&drone, 102);
    inserir_fim(&drone, 103);
    inserir_fim(&drone, 104);
    inserir_fim(&drone, 105);
    imprimir(&drone);

    printf("\n2. Insetir prioridade\n");
    inserir_posicao(&drone, 999, 0);
    imprimir(&drone);

    printf("\n3. atingir Limite 8):\n");
    
    while (tamanho(&drone) < 8) {
        inserir_fim(&drone, 100 + tamanho(&drone));
    }
    imprimir(&drone);
    if (inserir_fim(&drone, 145) == 0) {
        printf("Drone Lotado\n");
    }

    printf("\n4. Removendo posicao 3:\n");
    if (remover_posicao(&drone, 3)) {
        printf("Pacote removido com sucesso.\n");
    }
    
    imprimir(&drone);

    printf("\n5. Substituindo Pacote:\n");
    int pos = buscar(&drone, 104);

    if (pos != -1) {
        alterar_elemento(&drone, pos, 777);
        printf("subistituido.\n");
    }

    imprimir(&drone);

    printf("\n6. Status Final da Carga:\n");
    imprimir(&drone);
    printf("Total de pacotes: %d\n", tamanho(&drone));

    return 0;
}
