#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs()                             \
  (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

// Entrada e sa�da.
float *h_a;
float *h_b;
float *h_c;

int partition = 0;
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

int main(int argc, char *argv[]) {
  int i, num_elementos, num_threads = 0;
  long id, ii, ff;

  if(argc < 3){
    printf("Uso: %s <size> <numthreads>\n", argv[0]);
    exit(0);
  }

  num_elementos = atoi(argv[1]);
  num_threads = atoi(argv[2]);

  partition = num_elementos / num_threads;

  n = num_elementos;

  printf("num_elementos: %d num_threads: %d\n", num_elementos, num_threads);

  h_a = (float *) malloc(num_elementos * sizeof(float));
  h_b = (float *) malloc(num_elementos * sizeof(float));
  h_c = (float *) malloc(num_elementos * sizeof(float));

  init_array(num_elementos);

  #pragma omp parallel num_threads(num_threads) default(none) private(i, id, ii, ff) shared(n, partition, h_a, h_b, h_c)
  {
    id = omp_get_thread_num();

    ii = id * partition;
    ff = ii + partition; // ff = (ii + 1) * partition;

    printf("  Thread[%lu]: Particao prevista: %ld [%ld..%ld]: %ld.\n", (long int) pthread_self(), id, ii, ff,  (ff - ii));

    /* A sobra n - ff sempre ser� maior que uma particao at� a pen�ltima thread. Na �ltima thread se sobrar algumas itera��es
    no final, a �ltima thread assume estendendo seu ff para n. */ 
    if((n - ff) < partition){
      ff = n;
    }

    printf("  Thread[%lu]: Executando sobre particao: %ld [%ld..%ld]: %ld.\n", (long int) pthread_self(), id, ii, ff, (ff - ii));
  
    #pragma omp critical
    {
      for (i = ii; i < ff; i++) {
        h_c[i] = h_a[i] + h_b[i];
      }
    }

    printf("  Thread[%lu]: Terminando...\n", (long int) pthread_self());
  }

  printf("Thread[%lu]: Todas as threads terminaram...\n", (long int) pthread_self());
  
  printf("Thread[%lu]: Imprimindo o resultado.\n", (long int) pthread_self());
	
  printf("Thread[%lu]: Verificando o resultado.\n", (long int) pthread_self());
	check_result(num_elementos);

  printf("Thread[%lu]: Fui, Tchau!\n", (long int) pthread_self());
  
  return 0;
}
