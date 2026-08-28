#include <unistd.h>
#include <stdio.h>

int main() {
   printf("Antes do exec\n");
   execl("/bin/ls", "/bin/ls", "-r", "-t", "-l", (char *) 0);
   printf("Depois do exec\n");

   return(0);
}
