#include "lista7.h"

int main(int argc, char *argv[]) {

    /*
    VALIDAÇÃO CLI
    */
    if (argc < 2) {

        fprintf(stderr,
                "Erro: Expressao nao fornecida.\n");

        fprintf(stderr,
                "Uso: %s \"( 1 + 2 ) * 3\"\n",
                argv[0]);

        return 1;
    }

    char *expressaoOriginal = argv[1];

    printf("Expressao infixa: %s\n",
           expressaoOriginal);

    /*
    FASE 1
    */
    char posfixa[MAX];

    converterParaPosfixa(expressaoOriginal,
                         posfixa);

    printf("Expressao posfixa: %s\n",
           posfixa);

    /*
    FASE 2
    */
    double resultado =
        avaliarPosfixa(posfixa);

    printf("Resultado final: %.2lf\n",
           resultado);

    return 0;
}