/* Compile:
 * gcc -fopenmp example-for-schedule-static-clause.c -o
 * example-for-schedule-static-clause.exe
 * or
 * make for-schedule-static-clause
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs()                                                    \
  (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

#define SIZE 16

int main() {
  int A[SIZE], B[SIZE], C[SIZE], i;
  int id, dot = 0;
  
  for(i = 0; i < SIZE; i++){ 
       A[i] = i;
       B[i] = i;
       C[i] = 0;
  }

  printf("Thread[%d][%lu]: Before parallel region...\n", omp_get_thread_num(), (long int)pthread_self());
  
  #pragma omp parallel private(id) num_threads(4)
  {
    id = omp_get_thread_num();
    printf("Thread[%d][%lu]: Threading starting...\n", id, (long int)pthread_self());
    
    #pragma omp for schedule(static,2)
    for(i = 0; i < SIZE; i++){ 
       C[i] = A[i] * B[i]; 
       printf("Thread[%d][%lu]: Working in %lu loop iteration %d * %d = %d.\n", id,
             (long int)pthread_self(), i, A[i], B[i], C[i]);
    }
  }

  printf("Thread[%d][%lu]: After parallel region...\n", omp_get_thread_num(),
         (long int)pthread_self());
  
  return 0;
}
