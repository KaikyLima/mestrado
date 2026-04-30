#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "lista4.h"

void rodar_cenario(char* titulo, int modo) {
    Lista l;
    inicializar(&l);
    long comps_totais = 0;

    printf("\n>>> %s <<<\n", titulo);

    for (int i = 0; i < 1000; i++) {
        int v;
        if (modo == 1) v = i;               // Crescente
        else if (modo == 2) v = 1000 - i;   // Decrescente
        else v = rand() % 5000;             // Aleatório
        
        comps_totais += inserirOrdenado(&l, v);
    }

    printf("Total de Comparacoes: %ld\n", comps_totais);
    printf("Media por Insercao:   %.2f\n", comps_totais / 1000.0);
    
    printf("Amostra Inversa: ");
    imprimirInverso(&l);
    printf("\n");

    destruir(&l);
}

int main() {
    srand(time(NULL));
    printf("====================================================\n");
    printf("        PPGCC - EXPERIMENTO DE LISTAS TAD\n");
    printf("====================================================\n");

    rodar_cenario("CENARIO 1: INSERCAO CRESCENTE", 1); 		//inserção em ordem crescente (1)
    rodar_cenario("CENARIO 2: INSERCAO DECRESCENTE", 2);	//inserção em ordem decrescente (2)
    rodar_cenario("CENARIO 3: INSERCAO ALEATORIA", 3);		//inserção em ordem aleatoria (3)

    printf("\n====================================================\n");
    return 0;
}
