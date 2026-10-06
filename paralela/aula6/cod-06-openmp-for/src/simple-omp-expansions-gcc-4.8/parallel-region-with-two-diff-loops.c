#include <omp.h>

int main (void) {
  int i, j, n, num_t;

  num_t = 8;

  #pragma omp parallel num_threads(num_t)
  {
	#pragma omp for schedule(runtime)
	for (i = 0; i < 1024; i++){
		// body_1;
	}

	#pragma omp for schedule(dynamic, 32)
	for (j = 0; j < n; j++){
		// body_2;
	}
  }
  return 0;
}
