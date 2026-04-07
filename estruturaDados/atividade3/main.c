#include <stdio.h>
#include <math.h>
#include "lista3.h"
#define TAM 3

int main() {
    // --- DADOS PARA TESTE ---
    int m1[TAM][TAM] = {{1,2,3}, {4,5,6}, {7,8,9}};
    int mId[TAM][TAM];
    int mTrans[TAM][TAM];
    char listaNomes[ROWS][COLS] = {"Pedro", "Ana", "Jose", "Maria"};
    float boletim[3][3] = {{8.0, 7.0, 0}, {5.0, 5.0, 0}, {9.0, 10.0, 0}};
    float mNegativos[TAM][TAM] = {{-1.5, 2.0, -3.0}, {4.0, -5.5, 0.0}, {7.0, 8.0, -9.0}};


    printf("--- INICIANDO VALIDACAO DOS EXERCICIOS ---\n\n");


    // 1. Soma Diagonal Principal
    printf("Ex 01 (Soma Diagonal): %s\n", (somaDiagonalPrincipal(TAM, m1) == 15) ? "OK" : "ERRO");


    // 2. Gerar Identidade
    gerarIdentidade(TAM, mId);
    printf("Ex 02 (Identidade): %s\n", (mId[0][0] == 1 && mId[0][1] == 0 && mId[1][1] == 1) ? "OK" : "ERRO");


    // 3. Calcular Medias
    calcularMedias(boletim);
    printf("Ex 03 (Medias Coluna 2): %s\n", (boletim[0][2] == 7.5 && boletim[1][2] == 5.0) ? "OK" : "ERRO");


    // 4. Zerar Negativos
    zerarNegativos(mNegativos);
    printf("Ex 04 (Zerar Negativos): %s\n", (mNegativos[0][0] == 0.0 && mNegativos[2][2] == 0.0) ? "OK" : "ERRO");


    // 5. Transposta
    transposta(m1, mTrans);
    printf("Ex 05 (Transposta): %s\n", (mTrans[1][0] == 2 && mTrans[0][1] == 4) ? "OK" : "ERRO");


    // 6. Comparar Linhas
    // Linha 2 (7,8,9 = 24) > Linha 0 (1,2,3 = 6)
    printf("Ex 06 (Comparar L2 > L0): %s\n", (compararLinhas(m1, 2, 0) == 1) ? "OK" : "ERRO");


    // 7. Buscar Nome
    printf("Ex 07 (Busca 'Ana'): %s\n", (buscarNome(listaNomes, "Ana") == 1) ? "OK" : "ERRO");
    printf("Ex 07 (Busca 'Inexistente'): %s\n", (buscarNome(listaNomes, "Carlos") == 0) ? "OK" : "ERRO");

/*
    // 8. Contar Vogais (Pedro=2, Ana=2, Jose=2, Maria=3 -> Total 9)
    // Obs: A funcao imprime o valor, mas aqui validamos a logica se retornar o int
    printf("Ex 08 (Contagem Vogais): (Verifique se o output impresso eh 9)\n");
    contarVogais(listaNomes);


    // 9. Inverter Strings
    inverterStrings(listaNomes);
    printf("Ex 09 (Inverter): %s\n", (strcmp(listaNomes[0], "Maria") == 0) ? "OK" : "ERRO");


    // 10. Formatar (Ex: "pEDRO" -> "Pedro")
    char nomeSujo[ROWS][COLS] = {"pEDRO"};
    // formatarIdentificadores(nomeSujo); // Adicione se implementar a 10
    // printf("Ex 10 (Formatacao): %s\n", (strcmp(nomeSujo[0], "Pedro") == 0) ? "OK" : "ERRO");
    */

    printf("\n--- FIM DOS TESTES ---\n");
    return 0;
}