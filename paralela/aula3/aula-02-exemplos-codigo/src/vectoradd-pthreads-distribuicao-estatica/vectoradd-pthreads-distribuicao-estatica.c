#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

// Entrada e sa�da.
float *h_a;
float *h_b;
float *h_c;

int partition = 0;
int n = 0;

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
  // Soma dos elementos do array C e divide por N, o valor deve ser igual a 1.
  int i;
  float sum = 0;
  fprintf(stdout, "Thread[%lu]: Checking.\n", (long int) pthread_self());
  
  for (i = 0; i < n; i++) {
    sum += h_c[i];
  }

  fprintf(stdout, "Thread[%lu]: Final Result: (%f, %f).\n", (long int) pthread_self(), sum, (float)(sum / (float)n));
}

void *vecadd(void *ptr) {
  int *id;
  int i, ii, ff;

  id = (int *) ptr;

  ii = (*id) * partition;
  ff = ii + partition; // ff = (ii + 1) * partition;

  fprintf(stdout, "   Thread[%lu,%lu]: Got the partition [%lu, %lu]: %lu.\n", *id, (long int) pthread_self(), ii, ff,  (ff - ii));

  /* A sobra n - ff sempre ser� maior que uma particao at� a pen�ltima thread. Na �ltima thread se sobrar algumas itera��es
  no final, a �ltima thread assume estendendo seu ff para n. */ 
  if((n - ff) < partition){
    ff = n;
  }

  fprintf(stdout, "   Thread[%lu,%lu]: Working on partition [%lu..%lu]: %lu.\n", *id, (long int) pthread_self(), ii, ff, (ff - ii));
  
  for (i = ii; i < ff; i++) {
    h_c[i] = h_a[i] + h_b[i];
  }

  fprintf(stdout, "   Thread[%lu,%lu]: Exiting.\n", *id, (long int) pthread_self());
  pthread_exit(0);
}

int main(int argc, char *argv[]) {
  int i, num_elements, num_threads = 0;

  if(argc < 3){
    printf("Uso: %s <size> <num_threads>\n", argv[0]);
    exit(0);
  }

  num_elements = atoi(argv[1]);
  num_threads = atoi(argv[2]);

  partition = num_elements / num_threads;
  n = num_elements;

  fprintf(stdout, "Thread[%lu]: num_elements: %d num_threads: %d.\n", (long int) pthread_self(), num_elements, num_threads);

  fprintf(stdout, "Thread[%lu]: Allocating the arrays.\n", (long int) pthread_self());
  h_a = (float *) malloc(num_elements * sizeof(float));
  h_b = (float *) malloc(num_elements * sizeof(float));
  h_c = (float *) malloc(num_elements * sizeof(float));

  init_array(num_elements);

  pthread_t *threads;

  threads = (pthread_t *) malloc(num_threads * sizeof(pthread_t));

  int *irets;
  irets = (int *) malloc (num_threads * sizeof(int));

  long *ids;
  ids = (long *) malloc (num_threads * sizeof(long));

  fprintf(stdout, "Thread[%lu]: Creating the Threads.\n", (long int) pthread_self());

  for(i=0; i<num_threads; i++){
    ids[i] = i;
    irets[i] = pthread_create(&threads[i], NULL, vecadd, (void *)&ids[i]);
    fprintf(stdout, "Thread[%lu]: Create Thread[%d] with id: %lu [%s]\n", (long int) pthread_self(), i, threads[i], ((irets[i] == 0)? "OK" : "Error"));
  }
  
  for(i=0; i<num_threads; i++){
    fprintf(stdout, "Thread[%lu]: Waiting for ending of execution Thread[%d].\n", (long int) pthread_self(),i);
    pthread_join(threads[i], NULL);
  }

  fprintf(stdout, "Thread[%lu]: All Threads were finished.\n", (long int) pthread_self());
  
  fprintf(stdout, "Thread[%lu]: Printing the Result.\n", (long int) pthread_self());
  //print_array(num_elements);
	
  fprintf(stdout, "Thread[%lu]: Checking the Result.\n", (long int) pthread_self());
  check_result(num_elements);

  fprintf(stdout, "Thread[%lu]: Releasing Allocated Memory.\n", (long int) pthread_self());
  free(h_a);
  free(h_b);
  free(h_c);

  printf("Thread[%lu]: Fui, Tchau!\n", (long int) pthread_self());

  return 0;
}
