/* Compilar:
 * gcc vetquad-omp-03.c -o vetquad-omp-03 -fopenmp
 * ou 
 * make omp-03
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
  int A[SIZE];
  unsigned long i;

  printf("Thread[%d][%lu]: Before parallel for...\n", omp_get_thread_num(), (long int)pthread_self());

  #pragma omp parallel for 
  // #pragma omp parallel for schedule(static, 2) 
  // #pragma omp parallel for schedule(static, 2) num_threads(4) 
  // #pragma omp parallel for schedule(static, 2) num_threads(4) ordered
  for(i = 0; i < SIZE; i++){ 
    A[i] = i * i;  
    // printf("Th[%d]: %02d = %03d\n", omp_get_thread_num(), i, A[i]);
    printf("Thread[%d][%lu]: Working in %lu loop iteration %d * %d = %d.\n", omp_get_thread_num(),
             (long int)pthread_self(), i, i, i, A[i]);
  }

  printf("Thread[%d][%lu]: After parallel for...\n", omp_get_thread_num(),
         (long int)pthread_self());
  
  return 0;
}
