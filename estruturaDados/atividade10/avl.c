#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

void inicializar(AVL *arvore) {
    if (arvore != NULL) {
        arvore->raiz = NULL;
    }
}

void destruirArvore(No **ppRaiz) {
    if (ppRaiz == NULL || *ppRaiz == NULL) {
        return;
    }
    destruirArvore(&((*ppRaiz)->esq));
    destruirArvore(&((*ppRaiz)->dir));
    free(*ppRaiz);
    *ppRaiz = NULL;
}

void rotacaoDireita(No **ppRaiz) {
    No *aux = (*ppRaiz)->esq;
    (*ppRaiz)->esq = aux->dir;
    aux->dir = *ppRaiz;
    *ppRaiz = aux;
}

void rotacaoEsquerda(No **ppRaiz) {
    No *aux = (*ppRaiz)->dir;
    (*ppRaiz)->dir = aux->esq;
    aux->esq = *ppRaiz;
    *ppRaiz = aux;
}

int inserir(No **ppRaiz, int id) {
    if (*ppRaiz == NULL) {
        No *novo = (No *)malloc(sizeof(No));
        novo->id  = id;
        novo->fb  = 0;
        novo->esq = NULL;
        novo->dir = NULL;
        *ppRaiz = novo;
        return 1;
    }
    if (id == (*ppRaiz)->id) return 0;

    if (id < (*ppRaiz)->id) {
        if (inserir(&(*ppRaiz)->esq, id) == 0) return 0;
        (*ppRaiz)->fb++;
        if ((*ppRaiz)->fb == 0) return 0;
        if ((*ppRaiz)->fb == 1) return 1;
        if ((*ppRaiz)->esq->fb > 0) {
            (*ppRaiz)->esq->fb = 0;
            (*ppRaiz)->fb      = 0;
            rotacaoDireita(ppRaiz);
        } else {
            int fb_neto = (*ppRaiz)->esq->dir->fb;
            rotacaoEsquerda(&(*ppRaiz)->esq);
            rotacaoDireita(ppRaiz);
            (*ppRaiz)->fb      = 0;
            (*ppRaiz)->esq->fb = (fb_neto ==  1) ?  0 : (fb_neto == -1 ?  1 : 0);
            (*ppRaiz)->dir->fb = (fb_neto == -1) ?  0 : (fb_neto ==  1 ? -1 : 0);
        }
        return 0;

    } else {
        if (inserir(&(*ppRaiz)->dir, id) == 0) return 0;
        (*ppRaiz)->fb--;
        if ((*ppRaiz)->fb ==  0) return 0;
        if ((*ppRaiz)->fb == -1) return 1;
        if ((*ppRaiz)->dir->fb < 0) {
            (*ppRaiz)->dir->fb = 0;
            (*ppRaiz)->fb      = 0;
            rotacaoEsquerda(ppRaiz);
        } else {
            int fb_neto = (*ppRaiz)->dir->esq->fb;
            rotacaoDireita(&(*ppRaiz)->dir);
            rotacaoEsquerda(ppRaiz);
            (*ppRaiz)->fb      = 0;
            (*ppRaiz)->dir->fb = (fb_neto == -1) ?  0 : (fb_neto ==  1 ? -1 : 0);
            (*ppRaiz)->esq->fb = (fb_neto ==  1) ?  0 : (fb_neto == -1 ?  1 : 0);
        }
        return 0;
    }
}

int remover(No **ppRaiz, int id) {

    if (*ppRaiz == NULL) return 0;

    int diminuiu = 0;

    if (id < (*ppRaiz)->id) {
        diminuiu = remover(&(*ppRaiz)->esq, id);
        if (diminuiu) {
            (*ppRaiz)->fb--;
            if ((*ppRaiz)->fb == -1) return 0;
            if ((*ppRaiz)->fb ==  0) return 1;
            if ((*ppRaiz)->dir->fb <= 0) {
                if ((*ppRaiz)->dir->fb == 0) {
                    (*ppRaiz)->fb      = -1;
                    (*ppRaiz)->dir->fb =  1;
                    rotacaoEsquerda(ppRaiz);
                    return 0;
                }
                (*ppRaiz)->fb      = 0;
                (*ppRaiz)->dir->fb = 0;
                rotacaoEsquerda(ppRaiz);
                return 1;
            } else {
                int fb_neto = (*ppRaiz)->dir->esq->fb;
                rotacaoDireita(&(*ppRaiz)->dir);
                rotacaoEsquerda(ppRaiz);
                (*ppRaiz)->fb      = 0;
                (*ppRaiz)->dir->fb = (fb_neto == -1) ?  0 : (fb_neto == 1 ? -1 : 0);
                (*ppRaiz)->esq->fb = (fb_neto ==  1) ?  0 : (fb_neto == -1? 1 : 0);
                return 1;
            }
        }

    } else if (id > (*ppRaiz)->id) {
        diminuiu = remover(&(*ppRaiz)->dir, id);
        if (diminuiu) {
            (*ppRaiz)->fb++;
            if ((*ppRaiz)->fb == 1) return 0;
            if ((*ppRaiz)->fb == 0) return 1;
            if ((*ppRaiz)->esq->fb >= 0) {
                if ((*ppRaiz)->esq->fb == 0) {
                    (*ppRaiz)->fb      =  1;
                    (*ppRaiz)->esq->fb = -1;
                    rotacaoDireita(ppRaiz);
                    return 0;
                }
                (*ppRaiz)->fb      = 0;
                (*ppRaiz)->esq->fb = 0;
                rotacaoDireita(ppRaiz);
                return 1;
            } else {
                int fb_neto = (*ppRaiz)->esq->dir->fb;
                rotacaoEsquerda(&(*ppRaiz)->esq);
                rotacaoDireita(ppRaiz);
                (*ppRaiz)->fb      = 0;
                (*ppRaiz)->esq->fb = (fb_neto ==  1) ?  0 : (fb_neto == -1 ?  1 : 0);
                (*ppRaiz)->dir->fb = (fb_neto == -1) ?  0 : (fb_neto ==  1 ? -1 : 0);
                return 1;
            }
        }

    } else {
        if ((*ppRaiz)->esq == NULL || (*ppRaiz)->dir == NULL) {
            No *aux = ((*ppRaiz)->esq != NULL) ? (*ppRaiz)->esq : (*ppRaiz)->dir;
            free(*ppRaiz);
            *ppRaiz = aux;
            return 1;
        } else {
            No *maior = (*ppRaiz)->esq;
            while (maior->dir != NULL) maior = maior->dir;
            (*ppRaiz)->id = maior->id;
            diminuiu = remover(&(*ppRaiz)->esq, maior->id);
            if (diminuiu) {
                (*ppRaiz)->fb--;
                if ((*ppRaiz)->fb == -1) return 0;
                if ((*ppRaiz)->fb ==  0) return 1;
                if ((*ppRaiz)->dir->fb <= 0) {
                    if ((*ppRaiz)->dir->fb == 0) {
                        (*ppRaiz)->fb      = -1;
                        (*ppRaiz)->dir->fb =  1;
                        rotacaoEsquerda(ppRaiz);
                        return 0;
                    }
                    (*ppRaiz)->fb      = 0;
                    (*ppRaiz)->dir->fb = 0;
                    rotacaoEsquerda(ppRaiz);
                    return 1;
                } else {
                    int fb_neto = (*ppRaiz)->dir->esq->fb;
                    rotacaoDireita(&(*ppRaiz)->dir);
                    rotacaoEsquerda(ppRaiz);
                    (*ppRaiz)->fb      = 0;
                    (*ppRaiz)->dir->fb = (fb_neto == -1) ?  0 : (fb_neto == 1 ? -1 : 0);
                    (*ppRaiz)->esq->fb = (fb_neto ==  1) ?  0 : (fb_neto == -1?  1 : 0);
                    return 1;
                }
            }
        }
    }

    return 0;
}