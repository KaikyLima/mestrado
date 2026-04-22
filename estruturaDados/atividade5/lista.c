#include "lista.h"
#include <stdio.h>
void inicializar(Lista *l) {
    l->quantidade = 0;
}

int inserir_fim(Lista *l, float valor){
    if (l->quantidade < MAX){

        l->itens[l->quantidade] = valor;
        l->quantidade++;
        return 1;

    }
    return 0;
}

int obter_elemento(Lista *l, int p, float *valor) {
    if (p < l->quantidade) {
        *valor = l->itens[p];
        return 1;
    }
    return 0; 
}

int alterar_elemento(Lista *l, int p, float novoValor){
    if (p < l->quantidade) {
        l->itens[p] = novoValor;
        return 1;
    }
    return 0; 
}

void imprimir(Lista *l) {
    for (int i = 0; i < l->quantidade; i++) {
        printf("%.0f ", l->itens[i]);
    }
    printf("\n");
}

int inserir_posicao(Lista *l, elemento e, int pos) {
    if (l->quantidade >= MAX || pos < 0 || pos > l->quantidade) {
        return 0;
    }
    for (int i = l->quantidade; i > pos; i--) {
        l->itens[i] = l->itens[i - 1];
    }
    l->itens[pos] = e;
    l->quantidade++;
    return 1;
}
int tamanho(Lista *l) {
    return l->quantidade;
}
int esta_cheia(Lista *l) {
    return l->quantidade == MAX;
}
int esta_vazia(Lista *l) {
    return l->quantidade == 0;
}

int remover_posicao(Lista *l, int pos) {
    for (int i = pos; i < l->quantidade - 1; i++) {
        l->itens[i] = l->itens[i + 1];
    }
    l->quantidade--;
    return 1;
}
int buscar(Lista *l, elemento e) {
    for (int i = 0; i < l->quantidade; i++) {
        if (l->itens[i] == e) return i;
    }
    return -1;
}