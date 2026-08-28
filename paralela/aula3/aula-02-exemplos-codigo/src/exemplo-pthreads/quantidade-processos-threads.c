/* Para compilar use:
 *  C compiler: gcc -lpthread exemplo-thread.c -o exemplo-thread
 *  C++ compiler: g++ -lpthread exemplo-thread.c -o exemplo-thread
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> // getpid()
#include <sys/wait.h> // wait()
#include <pthread.h>

void *print_message_function(void *ptr) {
    char *message;
    message = (char *) ptr;

    printf("%s: Pai: %lu, Filho: %lu, Thread: %lu\n", message, getppid(), getpid(), (long int) pthread_self());

    pthread_exit(NULL);
}


int main( ){
     pid_t pid;
     pid_t my_pid; // pid_t is the type for process IDs

     pid = fork();
     printf("FORK1: Pai: %lu, Filho: %lu, Thread: %lu\n", getppid(), getpid(), (long int) pthread_self());

     if (pid != 0){
          pthread_t thread1;
          char *message = malloc (5*sizeof(char));
          sprintf(message, "PTHR%d", 1);
	     pthread_create(&thread1, NULL, print_message_function, (void*) message);
          pthread_join(thread1, NULL);

          for(int i = 0; i<5;i++){
               pthread_t thread2;
               char *message2 = malloc (5*sizeof(char));
               sprintf(message2, "PTHR%d", 2);
               pthread_create(&thread2, NULL, print_message_function, (void*) message2);
               pthread_join(thread2, NULL);
               fork();
               printf("FORK2: Pai: %lu, Filho: %lu, Thread: %lu\n", getppid(), getpid(), (long int) pthread_self());
          }
          wait(NULL); // Wait for child to finish
     }
     else {
          pid = fork();
          printf("FORK3: Pai: %lu, Filho: %lu, Thread: %lu\n", getppid(), getpid(), (long int) pthread_self());
          if(pid == 0){
               pthread_t thread3;
               char *message3 = malloc (5*sizeof(char));
               sprintf(message3, "PTHR%d", 3);
               pthread_create(&thread3, NULL, print_message_function, (void*) message3);
               pthread_join(thread3, NULL);
          }
     }
   
     fork();
     printf("FORK4: Pai: %lu, Filho: %lu, Thread: %lu\n", getppid(), getpid(), (long int) pthread_self());

   return(0);
   
}
