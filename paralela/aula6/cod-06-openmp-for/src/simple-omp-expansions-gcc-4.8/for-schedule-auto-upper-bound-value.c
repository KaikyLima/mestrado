#include <omp.h>

int a[1024];

int main (void) {
  int i;

  #pragma omp parallel for schedule(auto)
  for (i = 0; i < 1024; i++){
    a[i]++;
  }
}
