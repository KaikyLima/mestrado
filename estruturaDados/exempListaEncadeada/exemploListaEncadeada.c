#include <stdio.h>
#include "lista.h"

int main() {
    Lista l;
    inicializar(&l);

    printf("--- Teste: Lista Encadeada Dinamica ---\n");

    // 1. Inserções iniciais
    inserir_inicio(&l, 10); // Lista: 10
    inserir_inicio(&l, 20); // Lista: 20 -> 10
    inserir_fim(&l, 30);    // Lista: 20 -> 10 -> 30
    
    printf("Apos insercoes iniciais:\n");
    imprimir(&l);

    // 2. Teste de Busca
    int valor = 10;
    int pos = buscar(&l, valor);
    if (pos != -1) {
        printf("\nO valor %d foi encontrado na posicao %d.\n", valor, pos);
    }

    // 3. Remoção no meio
    printf("\nRemovendo o elemento da posicao 1 (o numero %d)...\n", 10);
    if (remover_posicao(&l, 1)) {
        imprimir(&l);
    }

    // 4. Teste de limite/erro
    printf("\nTentando remover posicao inexistente (99)...\n");
    if (!remover_posicao(&l, 99)) {
        printf("Erro capturado com sucesso: Posicao invalida.\n");
    }

    // 5. Finalização
    printf("\nLimpando memoria...\n");
    // Aqui voce chamaria a funcao de liberar_lista
    
    return 0;
}