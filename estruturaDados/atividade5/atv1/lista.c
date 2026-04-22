#include "lista.h"
void inicializar(Lista *l) {
    l->total = 0;
}

int inserir_fim(Lista *l, float valor){
    if (l->total < MAX){

        l->itens[l->total] = valor;
        l->total++;
        return 1;

    }
    return 0;
}

int obter_elemento(Lista *l, int p, float *valor) {
    if (p < l->total) {
        *valor = l->itens[p];
        return 1;
    }
    return 0; 
}

int alterar_elemento(Lista *l, int p, float novoValor){
    if (p < l->total) {
        l->itens[p] = novoValor;
        return 1;
    }
    return 0; 
}