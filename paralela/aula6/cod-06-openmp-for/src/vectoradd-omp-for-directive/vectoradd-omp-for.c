#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <inttypes.h>
#include <stdbool.h>
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
#ifndef SCHED
  #define SCHED schedule(dynamic, partition)
#endif

void init_array(int n) {
  fprintf(stdout, "Thread[%lu]: Initializing the arrays.\n", (long int) pthread_self());
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
    fprintf(stdout, "Thread[%lu]: h_c[%07d]: %f.\n", (long int) pthread_self(), i, h_c[i]);
  }
}

void check_result(int n){
  int i;
  double sum = 0;      
  fprintf(stdout, "Thread[%lu]: Checking.\n", (long int) pthread_self());
  
  for (i = 0; i < n; i++) {
	  sum += h_c[i];
	}
	
  fprintf(stdout, "Thread[%lu]: Final Result: (%f, %f).\n", (long int) pthread_self(), sum, (double)(sum / (double)n));
}

int main(int argc, char *argv[]) {
  int i, num_elements, num_threads = 0;
  long id;

  if(argc < 4){
    fprintf(stderr, "Uso: %s <num_elements> <num_threads> <partition_size>\n", argv[0]);
    exit(0);
  }

  num_elements = atoi(argv[1]);
  num_threads = atoi(argv[2]);
  partition = atoi(argv[3]);

  fprintf(stdout, "Thread[%lu]: num_elements: %d num_threads: %d.\n", (long int) pthread_self(), num_elements, num_threads);

  fprintf(stdout, "Thread[%lu]: Allocating the arrays.\n", (long int) pthread_self());
  h_a = (float *) malloc(num_elements * sizeof(float));
  h_b = (float *) malloc(num_elements * sizeof(float));
  h_c = (float *) malloc(num_elements * sizeof(float));

  init_array(num_elements);

  fprintf(stdout, "Thread[%lu]: Before parallel region.\n", (long int) pthread_self());

  double t_ini = omp_get_wtime();

  #pragma omp parallel num_threads(num_threads) default(none) private(i) shared(num_elements, partition, h_a, h_b, h_c)
  {
    #pragma omp for SCHED
    for (i = 0; i < num_elements; i++) {
      h_c[i] = h_a[i] + h_b[i];
    }
  }

  double t_fim = omp_get_wtime();
  fprintf(stdout, "TEMPO: %f\n", t_fim - t_ini);

  fprintf(stdout, "Thread[%lu]: All threads were finished.\n", (long int) pthread_self());
  
  fprintf(stdout, "Thread[%lu]: Printing the result.\n", (long int) pthread_self());
	
  fprintf(stdout, "Thread[%lu]: Checking the result.\n", (long int) pthread_self());
	check_result(num_elements);

  fprintf(stdout, "Thread[%lu]: Fui, Tchau!\n", (long int) pthread_self());
  
  return 0;
}
