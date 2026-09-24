/* Compile:
 * gcc -fopenmp helloworld-omp-03.c -o helloworld-omp-03.exe
 * or 
 * make omp-03
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs() (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

int main() {
	
#pragma omp parallel
{
	int id_omp = omp_get_thread_num();
	long int id_sys = (long int) pthread_self();
	int num_threads = omp_get_num_threads();
	int num_procs = omp_get_num_procs();
	printf("Thread[%2d, %lu]: #Threads: %d, #procs: %d. Hello World!!!\n", id_omp, id_sys, num_threads, num_procs);
}
	
	return 0;
}
