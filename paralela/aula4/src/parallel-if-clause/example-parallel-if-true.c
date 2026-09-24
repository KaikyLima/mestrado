/* Compile:
 * gcc -fopenmp example-parallel-if-true.c -o example-parallel-if-true.exe
 * or 
 * make omp-parallel-if
 */
#include <stdio.h>
#include <stdlib.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs() (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

int main() {
	int n = 11;
  
  #pragma omp parallel if(n>10) num_threads(4)
  {
    int id_omp = omp_get_thread_num();
	long int id_sys = (long int) pthread_self();
	printf("Thread[%d, %lu]: Hello World!!!\n", id_omp, id_sys);
  }
  
  return 0;
}
