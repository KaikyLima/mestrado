#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

// Entrada e sa�da.
float *h_a;
float *h_b;
float *h_c;

int n = 0;

void init_array(int n) {
  fprintf(stdout, "Inicializando os arrays.\n");
  int i;
  // Initialize vectors on host.
	for (i = 0; i < n; i++) {
	  h_a[i] = 0.5;
	  h_b[i] = 0.5;
	}
}

void print_array(int n) {
  int i;
  for (i = 0; i < n; i++) {
	fprintf(stdout, "h_c[%07d]: %f\n", i, h_c[i]);
  }
}

void check_result(int n){
  // Soma dos elementos do array C e divide por N, o valor deve ser igual a 1.
  int i;
  float sum = 0;
  fprintf(stdout, "Verificando o resultado.\n");  
  
  for (i = 0; i < n; i++) {
	  sum += h_c[i];
	}
	
	fprintf(stdout, "Resultado Final: (%f, %f)\n", sum, (float)(sum / (float)n));
}

void *vecadd(void *ptr) {
  long int *id, i;
  
  id = (long int *) ptr;

  i = (*id);

  printf("  Thread[%lu]: Calculando elemento: %lu.\n", (long int) pthread_self(), *id);
  
  h_c[i] = h_a[i] + h_b[i];

  printf("  Thread[%lu]: Terminando...\n", (long int) pthread_self());
  pthread_exit(0);
}

int main(int argc, char *argv[]) {
  long int i, num_elementos, num_threads = 0;

  if(argc < 2){
    printf("Uso: %s <num_elementos>\n", argv[0]);
    exit(0);
  }

  num_elementos = atoi(argv[1]);

  num_threads = num_elementos;

  n = num_elementos;

  printf("num_elementos: %lu num_threads: %lu\n", num_elementos, num_threads);

  h_a = (float *) malloc(num_elementos * sizeof(float));
  h_b = (float *) malloc(num_elementos * sizeof(float));
  h_c = (float *) malloc(num_elementos * sizeof(float));

  init_array(num_elementos);

  pthread_t *threads;

  threads = (pthread_t *) malloc(num_threads * sizeof(pthread_t));

  int *irets;
  irets = (int *) malloc (num_threads * sizeof(int));

  long int *ids;
  ids = (long int *) malloc (num_threads * sizeof(long int));

  for(i=0; i<num_threads; i++){
    ids[i] = i;
    irets[i] = pthread_create(&threads[i], NULL, vecadd, (void *)&ids[i]);
    printf("Thread[%lu]: Criacao da Thread %lu com o id: %lu [%s]\n", (long int) pthread_self(), i, threads[i], ((irets[i] == 0)? "OK" : "Erro"));
  }
  
  for(i=0; i<num_threads; i++){
	  printf("Thread[%lu]: Aguardando o termino das threads...\n", (long int) pthread_self());
    pthread_join(threads[i], NULL);
  }

  printf("Thread[%lu]: Todas as threads terminaram...\n", (long int) pthread_self());
  
  printf("Thread[%lu]: Imprimindo o resultado.\n", (long int) pthread_self());
	
  printf("Thread[%lu]: Verificando o resultado.\n", (long int) pthread_self());
	check_result(num_elementos);

  printf("Thread[%lu]: Fui, Tchau!\n", (long int) pthread_self());
  
  return 0;
}
