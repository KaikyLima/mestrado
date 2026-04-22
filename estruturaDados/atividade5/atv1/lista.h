#ifndef LISTA_H
#define LISTA_H

#define MAX 12

typedef struct {
    float itens[MAX];
    int total;
} Lista;

void inicializar(Lista *l);
int inserir_fim(Lista *l, float valor);
int obter_elemento(Lista *l, int p, float *valor);
int alterar_elemento(Lista *l, int p, float novo_valor);

#endif