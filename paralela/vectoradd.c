#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <unistd.h>

// Size of vectors.
#ifndef N
#define N 10
#endif
// Entrada e sa�da.
float h_a[N];
float h_b[N];
float h_c[N];

// Compartilhamento de memoria
#define SHMSZ (sizeof(tshare))
typedef struct tshare {
  float h_c[N];
} tshare;

void init_array() {
  fprintf(stdout, "Inicializando os arrays.\n");
  int i;
  // Initialize vectors on host.
  for (i = 0; i < N; i++) {
    h_a[i] = 0.5;
    h_b[i] = 0.5;
  }
}

void print_array(tshare *shm) {
  int i;
  for (i = 0; i < N; i++) {
    fprintf(stdout, "h_c[%07d]: %f\n", i, shm->h_c[i]);
  }
}

void check_result(tshare *shm) {
  // Soma dos elementos do array C e divide por N, o valor deve ser igual a 1.
  int i;
  float sum = 0;
  fprintf(stdout, "Verificando o resultado.\n");

  for (i = 0; i < N; i++) {
    sum += shm->h_c[i];
  }

  fprintf(stdout, "Resultado Final: (%f, %f)\n", sum, (float)(sum / (float)N));
}

int main() {
  int shmid;
  key_t key;
  tshare *shm, *s;
  /* Nome do segmento de memória compartilhada "5678". */
  key = 5678;

  /* Cria o segmento compartilhado. */
  if ((shmid = shmget(key, SHMSZ, IPC_CREAT | 0666)) < 0) {
    perror("Erro ao tentar criar o segmento de shm (shmget).");
    exit(1);
  }

  printf("Identificação da região criada: %d. \nPara verificar use:\n ipcs -m "
         "| grep \"%d\"\n",
         shmid, shmid);

  /* Acoplamento do segmento criado ao espaço de dados. */
  if ((shm = shmat(shmid, NULL, 0)) == (void *)-1) {
    perror(
        "Erro ao acoplar o segmento ao espaço de dados do programa (shmat).");
    exit(1);
  }

 //FORK
  pid_t pid = fork();
  int aux = N/2;
  if (pid ==0){
    printf("processo filho: ");
  }
  else{
    printf("processo pai: ");
  }

  int i;
  /* Inicializacao  dos vetores. */
  init_array();

  if (pid ==0){
    //FILHO
    for (i = aux; i < N; i++){
      shm->h_c[i] = h_a[i] + h_b[i];
    }
  }
  else{
    //PAI
    for (i = 0; i < aux; i++){
      shm->h_c[i] = h_a[i] + h_b[i];
    }
  }
  /* Calculo. */
  /*
  for (i = 0; i < N; i++) {
    h_c[i] = h_a[i] + h_b[i];
  }
  */
  /* Resultados. */
  print_array(shm);
  check_result(shm);

  return 0;
}
