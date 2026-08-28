/*
 * Fonte: http://www.cs.cf.ac.uk/Dave/C/node27.html
 */
/*
 * shm-client - client program to demonstrate shared memory.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>

#define SHMSZ (sizeof(tshare))

typedef struct tshare {
  int ii;
  float ff;
  char str[10];
  int alterou;
} tshare;

int main() {
  int shmid;
  key_t key;
  tshare *shm, *s;

  /* É preciso pegar o segmento nomeado como "5678", criado pelo servidor. */
  key = 5678;

  /* Localizando o segmento (locate). */
  if ((shmid = shmget(key, SHMSZ, 0666)) < 0) {
    perror("Erro ao tentar acessar o segmento de shm (shmget).");
    exit(1);
  }

  /* Acoplamento do segmento ao espaço de endereços de dados. */
  if ((shm = shmat(shmid, NULL, 0)) == (void *)-1) {
    perror(
        "Erro ao acoplar o segmento ao espaço de dados do programa (shmat).");
    exit(1);
  }

  /* Lendo o que o servidor colocou na região de memória. */
  s = shm;
  printf("Inteiro: %d\n", s->ii);
  printf("Float: %f\n", s->ff);
  printf("String: %s\n", s->str);
  printf("Alterou: %d\n", s->alterou);

  /* Modificando o primeiro caracter do segmento para '*', indicando que os
   * dados já foram lidos. */
  shm->ii = 10;
  shm->ff = 100.0;
  strncpy(shm->str, "Alterado\0", 9);
  shm->alterou = 1;

  /* Elimina a região de memória compartilhada. */
  if (shmdt(shm) == -1) {
    perror("Erro ao desacoplar a região de memória compartilhada (shmdt).");
    exit(1);
  }

  return EXIT_SUCCESS;
}
