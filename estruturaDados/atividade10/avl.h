#ifndef AVL_H
#define AVL_H

typedef struct No {
    int id;
    int fb;
    struct No *esq;
    struct No *dir;
} No;

typedef struct {
    No *raiz;
} AVL;

void inicializar(AVL *arvore);
int inserir(No **ppRaiz, int id);
int remover(No **ppRaiz, int id);
void destruirArvore(No **ppRaiz);

#endif