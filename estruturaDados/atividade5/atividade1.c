#include <stdio.h>
#include <math.h> // Para a função fabs (valor absoluto)
#include "lista.h"

int main() {
    Lista ano;
    inicializar(&ano);
    
    char *meses[] = {"Jan", "Fev", "Mar", "Abr", "Mai", "Jun", 
                     "Jul", "Ago", "Set", "Out", "Nov", "Dez"};

    // 1. Inserindo dados iniciais (Janeiro a Dezembro)
    float dados[] = {28.5, 30.1, 27.4, 23.2, 18.5, 15.0, 14.2, 16.7, 20.1, 23.5, 26.0, 27.8};
    for(int i = 0; i < 12; i++) inserir_fim(&ano, dados[i]);

    // 4. Correção de temperatura (Ex: Julho estava errado, era 13.5)
    printf("Corrigindo temperatura de Julho (posicao 6)...\n");
    alterar_elemento(&ano, 6, 13.5);

    // 2. Localizando Maior e Menor
    float maior, menor, temp_atual;
    int mes_maior = 0, mes_menor = 0;

    obter_elemento(&ano, 0, &maior);
    obter_elemento(&ano, 0, &menor);

    for(int i = 1; i < 12; i++) {
        obter_elemento(&ano, i, &temp_atual);
        if(temp_atual > maior) { maior = temp_atual; mes_maior = i; }
        if(temp_atual < menor) { menor = temp_atual; mes_menor = i; }
    }

    // 3. Maior diferença entre meses consecutivos
    float maior_dif = 0, temp_prox;
    int indice_dif = 0;

    for(int i = 0; i < 11; i++) {
        obter_elemento(&ano, i, &temp_atual);
        obter_elemento(&ano, i+1, &temp_prox);
        
        float dif = fabs(temp_prox - temp_atual);
        if(dif > maior_dif) {
            maior_dif = dif;
            indice_dif = i;
        }
    }

    // Resultados
    printf("\n--- RELATORIO CLIMATICO ---\n");
    printf("Maior temperatura: %.1f C (%s)\n", maior, meses[mes_maior]);
    printf("Menor temperatura: %.1f C (%s)\n", menor, meses[mes_menor]);
    printf("Maior variacao entre meses: %.1f C (entre %s e %s)\n", 
            maior_dif, meses[indice_dif], meses[indice_dif+1]);

    return 0;
}
