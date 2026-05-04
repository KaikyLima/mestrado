#include <stdio.h>
#include <stdlib.h>
#include "lista4.h"

void inicializar(Lista* l){
    l->tamanho = 0;
    l->inicio = NULL;
    l->fim = NULL;

}

int inserirOrdenado(Lista* l, ELEMENTO e) {
    No* novo = (No*)malloc(sizeof(No));
    if (novo == NULL) return 0;
    novo->dado = e;
    novo->proximo = NULL;

    int contador = 0;

    if (l->inicio == NULL || e < l->inicio->dado) {
        novo->proximo = l->inicio;
        l->inicio = novo;
        if (l->tamanho == 0) l->fim = novo;
        l->tamanho++;
        return 0;
    }
    contador++; 
    if (e >= l->fim->dado) {
        l->fim->proximo = novo;
        l->fim = novo;
        l->tamanho++;
        return contador;
    }

    No* atual = l->inicio;
    while (atual->proximo != NULL && atual->proximo->dado < e) {
        contador++;
        atual = atual->proximo;
    }
    contador++; 

    novo->proximo = atual->proximo;
    atual->proximo = novo;
    l->tamanho++;

    return contador;
}

void destruir(Lista* l) {
    No* atual = l->inicio;
    while (atual != NULL) {
        No* prox = atual->proximo;
        free(atual);
        atual = prox;
    }
    l->inicio = NULL;
    l->fim = NULL;
    l->tamanho = 0;
}

void imprimirRecursivo(No* n) {
    if (n == NULL) return;
    imprimirRecursivo(n->proximo);
    printf("%d ", n->dado);
}

void imprimirInverso(Lista* l) {
    if (l->inicio == NULL) return;
    imprimirRecursivo(l->inicio);
}