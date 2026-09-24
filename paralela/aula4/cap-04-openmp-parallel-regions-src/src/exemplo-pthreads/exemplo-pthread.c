/* Para compilar use:
 *  C compiler: gcc -lpthread exemplo-pthread.c -o exemplo-pthread.exe
 *  C++ compiler: g++ -lpthread exemplo-pthread.c -o exemplo-pthread.exe
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

/* Assinatura da função que a thread irá executar. */
void *print_message_function(void *ptr);

int main(int argc, char *argv[]) {
  /* Declara duas threads */
  pthread_t thread1, thread2;

  /* Declara as mensagens que as threads irão imprimir. */
  char *message1 = "Olá! Eu sou a Thread 1.";
  char *message2 = "Olá! Eu sou a Thread 2.";

  /* Variáveis para armazenar o retorno. */
  int iret1, iret2;

  printf("Thread[%lu]: Criando as threads...\n", (long int) pthread_self());
  /* Cria duas threads independentes, cada uma irá executar a função */
  iret1 = pthread_create(&thread1, NULL, print_message_function, (void *)message1);
  
  /* Se conseguiu criar a thread pthread_create retorna 0. */
  printf("Thread[%lu]: Criação da Thread 1 [%s]\n", (long int) pthread_self(), ((iret1 == 0)? "OK" : "Erro"));
      
  iret2 = pthread_create(&thread2, NULL, print_message_function, (void *)message2);

  /* Se conseguiu criar a thread pthread_create retorna 0. */
  printf("Thread[%lu]: Criação da Thread 2 [%s]\n", (long int) pthread_self(), ((iret2 == 0)? "OK" : "Erro"));

  /* Aguarda até que todas as threads completem antes de continuar. */
  /* Pode acontecer de executar algo que termine o processo/thread
   principal antes das threads terminarem */
  printf("Thread[%lu]: Aguardando o término das threads...\n", (long int) pthread_self());
  pthread_join(thread1, NULL);
  pthread_join(thread2, NULL);

  printf("Thread[%lu]: Todas as threads terminaram...\n", (long int) pthread_self());
  printf("Thread[%lu]: Fui, Tchau!\n", (long int) pthread_self());

  return 0;
}

/* Função que as threads irão executar. */
void *print_message_function(void *ptr) {
  char *message;
  message = (char *)ptr;
  printf("  Thread[%lu]: Executando...\n", (long int) pthread_self());
  printf("  Thread[%lu]: %s\n", (long int) pthread_self(), message);
  printf("  Thread[%lu]: Terminando...\n", (long int) pthread_self());
  pthread_exit(0);
}
