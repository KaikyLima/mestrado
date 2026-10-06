#include <omp.h>

int main (void) {
  int i, j, n;

  #pragma omp parallel
  {
	#pragma omp for schedule(runtime)
	for (i = 0; i < n; i++){
		// body_1;
	}

	#pragma omp for schedule(runtime)
	for (j = 0; j < n; j++){
		// body_2;
	}
  }
  return 0;
}
