#include <stdio.h>
#include <stdlib.h>
#include "lista4.h"

int main() {

    printf("=== TESTE PONTO ===\n");
    Ponto* p = alocarPonto(10, 20);
    imprimirPonto(p);
    printf("\n");

    printf("\n=== TESTE TURMA ===\n");
    int n = 3;
    Aluno* turma = alocarTurma(n);

    // Preenchendo automaticamente
    turma[0].ra = 101; turma[0].nota = 7.5;
    turma[1].ra = 102; turma[1].nota = 8.0;
    turma[2].ra = 103; turma[2].nota = 9.0;

    printf("Turma:\n");
    for(int i = 0; i < n; i++) {
        printf("RA: %d | Nota: %.2f\n", turma[i].ra, turma[i].nota);
    }

    float media = mediaTurma(turma, n);
    printf("Media da turma: %.2f\n", media);

    printf("\n=== TESTE BUSCA ===\n");
    Aluno* encontrado = buscarAluno(turma, 102, n);

    if(encontrado != NULL){
        printf("Encontrado: RA %d | Nota %.2f\n",
               encontrado->ra, encontrado->nota);
    } else {
        printf("Aluno nao encontrado\n");
    }

    printf("\n=== TESTE CLONAGEM ===\n");
    Aluno* copia = clonaTurma(turma, n);

    printf("Turma clonada:\n");
    for(int i = 0; i < n; i++) {
        printf("RA: %d | Nota: %.2f\n", copia[i].ra, copia[i].nota);
    }

    printf("\n=== TESTE CIRCULO ===\n");
    Circulo* c = criarCirculo(5.0, 2, 3);

    printf("Raio: %.2f | Centro: (%d, %d)\n",
           c->raio, c->centro.x, c->centro.y);

    float area = calcularArea(c);
    printf("Area do circulo: %.2f\n", area);

    printf("\n=== LIBERANDO MEMORIA ===\n");

    liberarMemoria((void**)&p);
    liberarMemoria((void**)&turma);
    liberarMemoria((void**)&copia);
    liberarMemoria((void**)&c);

    printf("Memoria liberada com sucesso!\n");

    return 0;
}