/* Para compilar use:
 *  C compiler: gcc -lpthread exemplo-thread.c -o exemplo-thread
 *  C++ compiler: g++ -lpthread exemplo-thread.c -o exemplo-thread
 */
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <pthread.h>

void *print_message_function( void *ptr );

int main() {
     /* Declara duas threads */
     pthread_t thread1, thread2;
     char *message1 = "Olá eu sou a Thread 1";
     char *message2 = "Olá eu sou a Thread 2";
     int  iret1, iret2;

     void *status1, *status2;

     printf("Thread[%lu]: Principal. PID: %d, PPID: %d, Main TID: %ld, TID: %ld\n", (long int) pthread_self(), getpid(), getppid(), syscall(SYS_gettid), (long int) pthread_self());

     printf("Thread[%lu]: Criando as threads. PID: %d, PPID: %d, Main TID: %ld, TID: %ld\n", (long int) pthread_self(), getpid(), getppid(), syscall(SYS_gettid), (long int) pthread_self());

     /* Cria duas threads independentes, cada uma irá executar a função */
     iret1 = pthread_create( &thread1, NULL, print_message_function, (void*) message1);
     iret2 = pthread_create( &thread2, NULL, print_message_function, (void*) message2);

     printf("Thread[%lu]: Principal. Thread 1 retornou: %d da criação.\n", (long int) pthread_self(), iret1);
     printf("Thread[%lu]: Principal. Thread 2 retornou: %d da criação.\n", (long int) pthread_self(), iret2);

     /* Aguarda até que todas as threads completem antes de continuar. */
     /* Pode acontecer de executar algo que termine o processo/thread principal antes das threads terminarem */

     printf("Thread[%lu]: Principal. Aguardando o término das threads.\n", (long int) pthread_self());


     if((iret1 = pthread_join(thread1, &status1)) == 0){
          printf("Thread[%lu]: Principal. Sincronizado com Thread 1 no join. Status: %d.\n", (long int) pthread_self(), status1);
     }
     else{
          printf("Thread[%lu]: Principal. Erro de sincronização com Thread 1: %d do join.\n", (long int) pthread_self(), iret1);
     }

     if((iret2 = pthread_join(thread2, &status2)) == 0){
          printf("Thread[%lu]: Principal. Sincronizado com Thread 2 no join. Status: %d.\n", (long int) pthread_self(), status2);
     }
     else{
          printf("Thread[%lu]: Principal. Erro de sincronização com Thread 2: %d do join.\n", (long int) pthread_self(), iret2);
     }
     
     printf("Thread[%lu]: Principal. Finalizando. PID: %d, PPID: %d, Main TID: %ld, TID: %ld\n", (long int) pthread_self(), getpid(), getppid(), syscall(SYS_gettid), (long int) pthread_self());
     
     exit(0);
}

void *print_message_function(void *ptr) {
     char *message;
     message = (char *) ptr;

     printf("  Thread[%lu]: PID: %d, PPID: %d, Main TID: %ld, TID: %ld\n", (long int) pthread_self(), getpid(), getppid(), syscall(SYS_gettid), (long int) pthread_self());
     printf("  Thread[%lu]: Imprimindo a mensagem: %s\n", (long int) pthread_self(), message);

     pthread_exit(0);
}
