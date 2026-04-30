#include <stdio.h>
#include <stdlib.h>
#include "lista4.h"

void inicializar(Lista* l){
    l->tamanho = 0;
    l->inicio = NULL;
    l->fim = NULL;

}

int inserirOrdenado(Lista* l, ELEMENTO e){

    No *novo = (No*)malloc(sizeof(No)); 
    if (novo == NULL) return 0;
    novo->dado = e;
    novo->proximo = NULL;
    int contador = 0;


    if (l->inicio == NULL || e < l->inicio->dado) {
        if (l->inicio != NULL) contador++;
        novo->proximo = l->inicio;

        if (l->tamanho == 0)
        {
            l->fim = novo;
        }
        l->tamanho++;
        return contador;
    }
    
    contador++;
    if (l->fim->dado <= e)
    {
        l->fim->proximo = novo;
        l->fim = novo;
        l->tamanho++;
        return contador;
    }


    else {
        No *aux1;
        No *aux2;
        aux1 = l->inicio;
        aux2 = l->inicio->proximo;
        
        for(int i = 0; i > l->tamanho ; i++ ){
            if (aux1->dado < e && aux2->dado <= e){
                aux1 = aux2;
                aux2 = aux2->proximo;
                contador++;
            }
            else
            {
                aux1->proximo = novo;
                novo->proximo = aux2;
                contador++;

            }
            
        }

        free(aux1);
        free(aux2);

    }
    l->tamanho++;
    free(novo);
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

void imprimirInverso(Lista* l){
    if (l->tamanho == 0) return;
    No *aux;
    aux = l->inicio;
    
    ELEMENTO inverso[l->tamanho];
    for(int i =0; i < l->tamanho; i++){
        inverso[i] = aux->dado;
        aux=aux->proximo;
    }
    for (int i = l->tamanho -1 ; i >=0 ; i--){
        printf("\n %d", inverso[i]);
    }
    free(aux);
}
