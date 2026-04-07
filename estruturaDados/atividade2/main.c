#include <stdio.h>
#include <math.h>
#include "lista2.h"

// Função auxiliar para o relatório de erros
void reportar(char* ex, int condicao) {
    if (condicao) printf("[OK] %s passou no teste.\n", ex);
    else printf("[ERRO] %s falhou. Verifique a logica!\n", ex);
}

int main() {
    printf("=== RELATORIO DE CORRECAO AUTOMATICA - LISTA 2 ===\n\n");

    //Ativadade 1
    int v[10]; 
    lerVetor(v, 10);

    // Cenários de Teste
    int vOrdenado[5] = {10, 20, 30, 40, 50};
    int vDesordenado[10] = {5, -2, 10, 0, 10, 8, 15, 3, 10, 7}; // Possui negativos e repetidos
    int vPares[10]; 
    int vVazio[5] = {1, 3, 5, 7, 9}; // Apenas ímpares

    // EX 2: Media (Testando com negativos e zero)
    // Soma = 64 / 10 = 6.4
    
    float media = calcularMedia(vDesordenado, 10);
    reportar("Exercicio 2 (Media)", fabs(media - 6.6) < 0.01);
    

    
    //Exercicio 3

    imprimirMaiorMenor(vDesordenado, 10);




    // EX 4: Busca (Testando valor repetido e inexistente)
    int idx1 = buscarElemento(vDesordenado, 10, 10); // O 10 aparece nos índices 2, 4 e 8
    int idx2 = buscarElemento(vDesordenado, 10, 99); // Inexistente
    reportar("Exercicio 4 (Busca)", (idx1 != -1) && (idx2 == -1));
    printf("   > Nota: Para valores repetidos, sua funcao retornou o indice %d.\n", idx1);
    

    // EX 5: Ordenacao
    int ord1 = estaOrdenado(vOrdenado, 5);
    int ord2 = estaOrdenado(vDesordenado, 10);
    reportar("Exercicio 5 (Ordenacao)", (ord1 == 1) && (ord2 == 0));

    
    // EX 6: Filtro de Pares (Caso com apenas ímpares)
    int qtdPares = filtrarPares(vVazio, 5, vPares);
    reportar("Exercicio 6 (Filtro Pares)", qtdPares == 0);
    if(qtdPares > 0) printf("   > Cuidado: Voce encontrou pares onde nao existiam ou imprimiu lixo!\n");

    int calcularProduto = calcularProdutoEscalar(vOrdenado, vOrdenado, 5);
    reportar("Exercicio 7 (Produto Escalar)", calcularProduto == 5500);

    // EX 8: Inversao In-Place (Verificando se alterou o vetor original)
    int vOriginal[3] = {1, 2, 3};
    inverterVetorInPlace(vOriginal, 3);
    reportar("Exercicio 8 (In-place)", (vOriginal[0] == 3) && (vOriginal[2] == 1));

    // EX 9: Frequencia (Valor repetido 3 vezes)
    int freq = contarFrequencia(vDesordenado, 10, 10);
    reportar("Exercicio 9 (Frequencia)", freq == 3);

    // EX 10: Aritmetica de Ponteiros
    float mediaPtr = calcularMediaPonteiros(vOrdenado, 5);
    reportar("Exercicio 10 (Ponteiros)", fabs(mediaPtr - 30.0) < 0.01);

    printf("\n=== FIM DO TESTE ===\n");
    return 0;
}