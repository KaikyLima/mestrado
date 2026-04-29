#ifndef LISTA_H
#define LISTA_H

// Definições das Structs (conforme Slide 5)

void inicializar(Lista *l);
int obter_tamanho(Lista *l);
int esta_vazia(Lista *l);

// Retornam 1 para Sucesso e 0 para Falha
int inserir_inicio(Lista *l, elemento e);
int inserir_fim(Lista *l, elemento e);
int inserir_posicao(Lista *l, elemento e, int pos);

int remover_posicao(Lista *l, int pos);
int alterar_elemento(Lista *l, int pos, elemento novo);

int buscar(Lista *l, elemento e);
void imprimir(Lista *l);
void liberar_lista(Lista *l);

#endif