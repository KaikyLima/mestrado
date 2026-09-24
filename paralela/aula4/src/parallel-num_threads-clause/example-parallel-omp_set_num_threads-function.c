/* Compile:
 * gcc -fopenmp example-parallel-omp_set_num_threads-function.c -o example-parallel-omp_set_num_threads-function.exe
 * or 
 * make omp-parallel-omp_set_num_threads-function
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
	
	omp_set_num_threads(7);
	#pragma omp parallel
	{
		int id_omp = omp_get_thread_num();
	    long int id_sys = (long int) pthread_self();
	    printf("Thread[%d, %lu]: Hello World!!!\n", id_omp, id_sys);
	}
	
	return 0;
}
