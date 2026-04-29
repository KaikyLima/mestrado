void inicializar(Lista *l) {
    l->inicio = NULL;
    l->tamanho = 0;
}

void imprimir(Lista *l) {
    No *atual = l->inicio; // Começamos pelo primeiro
    printf("Lista (%d itens): ", l->tamanho);
    
    while (atual != NULL) {
        printf("%d -> ", atual->dado);
        atual = atual->proximo; // O ponteiro "pula" para o próximo endereço
    }
    printf("NULL\n");
}

int inserir_inicio(Lista *l, elemento e) {
    No *novo = (No*) malloc(sizeof(No));
    if (novo == NULL) return 0; // Falha na alocação

    novo->dado = e;
    novo->proximo = l->inicio; // O novo aponta para quem era o primeiro
    l->inicio = novo;          // O gerente agora aponta para o novo
    l->tamanho++;
    
    return 1;
}
int remover_posicao(Lista *l, int pos) {
    if (pos < 0 || pos >= l->tamanho || esta_vazia(l)) return 0;

    No *aux;

    // Caso especial: remover o primeiro
    if (pos == 0) {
        aux = l->inicio;
        l->inicio = aux->proximo;
    } else {
        // Precisamos achar o anterior ao que será removido
        No *anterior = l->inicio;
        for (int i = 0; i < pos - 1; i++) {
            anterior = anterior->proximo;
        }
        aux = anterior->proximo;      // O nó que vai sumir
        anterior->proximo = aux->proximo; // O anterior pula o aux e aponta para o sucessor
    }

    free(aux); // Devolve a memória para o sistema
    l->tamanho--;
    return 1;
}
int buscar(Lista *l, elemento e) {
    No *atual = l->inicio;
    int indice = 0;

    while (atual != NULL) {
        if (atual->dado == e) return indice;
        atual = atual->proximo;
        indice++;
    }

    return -1; // Não encontrado
}

int inserir_fim(Lista *l, elemento e) {
    No *novo = (No*) malloc(sizeof(No));
    if (novo == NULL) return 0;

    novo->dado = e;
    novo->proximo = NULL;

    if (esta_vazia(l)) {
        l->inicio = novo;
    } else {
        No *aux = l->inicio;
        // Percorre até encontrar o nó cujo próximo é NULL
        while (aux->proximo != NULL) {
            aux = aux->proximo;
        }
        aux->proximo = novo;
    }
    
    l->tamanho++;
    return 1;
}