#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

void exibirEmOrdem(No *raiz) {
    if (raiz != NULL) {
        exibirEmOrdem(raiz->esq);
        printf("ID: %d [FB: %d]\n", raiz->id, raiz->fb);
        exibirEmOrdem(raiz->dir);
    }
}

int main() {
    AVL minhaArvore;
    inicializar(&minhaArvore);

    printf("--- Teste de Inserção (Provocando Rotações) ---\n");
    inserir(&minhaArvore.raiz, 30);
    inserir(&minhaArvore.raiz, 20);
    inserir(&minhaArvore.raiz, 10); // Deve provocar uma rotação para a direita
    inserir(&minhaArvore.raiz, 40);
    inserir(&minhaArvore.raiz, 50); // Deve provocar uma rotação para a esquerda
    inserir(&minhaArvore.raiz, 25); // Inserção comum

    printf("\nÁrvore resultante (Em-Ordem):\n");
    exibirEmOrdem(minhaArvore.raiz);

    printf("\n--- Teste de Remoção ---\n");
    printf("Removendo o nó 10 (nó folha)...\n");
    remover(&minhaArvore.raiz, 10);

    printf("\nÁrvore após remoção (Em-Ordem):\n");
    exibirEmOrdem(minhaArvore.raiz);

    printf("\n--- Teste de Destruição e Memória ---\n");
    printf("Destruindo a árvore completamente...\n");
    destruirArvore(&minhaArvore.raiz);

    if (minhaArvore.raiz == NULL) {
        printf("Sucesso: O ponteiro da raiz agora é NULL!\n");
    } else {
        printf("Aviso: O ponteiro da raiz NÃO é NULL. Verifique sua implementação.\n");
    }

    return 0;
}