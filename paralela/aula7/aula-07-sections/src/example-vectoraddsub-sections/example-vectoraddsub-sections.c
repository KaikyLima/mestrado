#include <stdio.h>
#include <stdlib.h>

// Size of vectors.
#ifndef N
#define N 10
#endif
// Entrada e saída.
float h_a[N];
float h_b[N];
float h_c[N];
float h_d[N];

void init_array() {
  fprintf(stdout, "   Thread[%lu,%lu]: Initializing the arrays...\n", omp_get_thread_num(), (long int) pthread_self());
  int i;
  #pragma omp parallel for
  for (i = 0; i < N; i++) {
  	fprintf(stdout, "       Thread[%lu,%lu]: (init_array) Executing loop iteration %d.\n", omp_get_thread_num(), (long int) pthread_self(), i);
    h_a[i] = 0.5;
    h_b[i] = 0.5;
  }
}

void print_array(float *v) {
  int i;
  fprintf(stdout, "   Thread[%lu,%lu]: Printing the vector result...\n", omp_get_thread_num(), (long int) pthread_self());
  #pragma omp parallel for
  for (i = 0; i < N; i++) {
      fprintf(stdout, "       Thread[%lu,%lu]: (print_array) Executing loop iteration %d: v[%d]: %f.\n", omp_get_thread_num(), (long int) pthread_self(), i, i, v[i]);
  }
}

void check_result(){
  int i;
  float sum = 0;

  fprintf(stdout, "   Thread[%lu,%lu]: Checking result...\n", omp_get_thread_num(), (long int) pthread_self());
  #pragma omp parallel for
  for (i = 0; i < N; i++) {
  	fprintf(stdout, "       Thread[%lu,%lu]: (check_result) Executing loop iteration %d.\n", omp_get_thread_num(), (long int) pthread_self(), i);
    sum += h_c[i];
  }
  fprintf(stdout, "Resultado Final: (%f, %f)\n", sum, (float)(sum / (float)N));
}

void addvector(float *a, float *b, float *c){
  int i = 0;
  #pragma omp parallel
  {
    #pragma omp for
    /* Cálculo. */
    for (i = 0; i < N; i++) {
      fprintf(stdout, "       Thread[%lu,%lu]: (addvector) Executing loop iteration %d.\n", omp_get_thread_num(), (long int) pthread_self(), i);
      c[i] = a[i] + b[i];
    }
  }
}

void subvector(float *a, float *b, float *c){
  int i = 0;
  for (i = 0; i < N; i++){
  	fprintf(stdout, "       Thread[%lu,%lu]: (subvector) Executing loop iteration %d.\n", omp_get_thread_num(), (long int) pthread_self(), i);
    c[i] = a[i] - b[i];
  }
}

int main(int argc, char *argv[]) {
  int i, id;
  /* Inicialização  dos vetores. */
  init_array();

  /* Para permitir a criação de threads em regiões aninhadas. */
  omp_set_nested(1);

  fprintf(stdout, "Thread[%lu]: Before parallel region.\n", (long int) pthread_self());
  
  #pragma omp parallel num_threads(8)
  {
  	id = omp_get_thread_num();
    #pragma omp sections
    {
      #pragma omp section
      {
        fprintf(stdout, "   Thread[%lu,%lu]: Working on section 1.1.\n", id, (long int) pthread_self());
        addvector(h_a, h_b, h_c);
      }
      
      #pragma omp section
      {
        fprintf(stdout, "   Thread[%lu,%lu]: Working on section 1.2.\n", id, (long int) pthread_self());
        subvector(h_a, h_b, h_d);	
      }
    }
    
    #pragma omp barrier
    
    #pragma omp sections
    {
      #pragma omp section
      {
        fprintf(stdout, "   Thread[%lu,%lu]: Working on section 2.1.\n", id, (long int) pthread_self());
        print_array(h_c);	
      }
      
      #pragma omp section
      {
        fprintf(stdout, "   Thread[%lu,%lu]: Working on section 2.1.\n", id, (long int) pthread_self());
        print_array(h_d);	
      }
    }
  }

  fprintf(stdout, "Thread[%lu]: After parallel region.\n", (long int) pthread_self());
  /* Resultados. */
  
  check_result();
  
  return 0;
}
