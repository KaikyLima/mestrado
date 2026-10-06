#include <omp.h>

int a[1024];

int main (void) {
  int i,n;

  n = 1024;

  #pragma omp parallel for schedule(guided)
  for (i = 0; i < n; i++){
    a[i]++;
  }
}
