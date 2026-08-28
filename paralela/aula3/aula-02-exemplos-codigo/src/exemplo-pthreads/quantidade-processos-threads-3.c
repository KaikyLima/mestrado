/* Para compilar use:
 *  C compiler: gcc -lpthread exemplo-thread.c -o exemplo-thread
 *  C++ compiler: g++ -lpthread exemplo-thread.c -o exemplo-thread
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> // getpid()
#include <sys/wait.h> // wait()
#include <pthread.h>

int main( ){
     pid_t pid;

     for(int i = 0; i<2;i++){
        pid = fork();
        printf("Pai: %lu, Filho: %lu, Thread: %lu\n", getppid(), getpid(), (long int) pthread_self());

        if (pid != 0){
          execl("/bin/ls", "/bin/ls", "-r", "-t", "-l", (char *) 0);
          wait(NULL); // Wait for child to finish
        }
    }
    return(0);
}
