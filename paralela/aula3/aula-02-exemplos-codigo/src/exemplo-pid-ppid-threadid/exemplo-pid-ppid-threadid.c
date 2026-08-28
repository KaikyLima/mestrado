#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <pthread.h>

void* thread_func(void* arg) {
    printf("Thread[%lu]:    Thread. PID: %d, PPID: %d, Kernel TID: %ld, Pthread TID: %ld\n", (long int) pthread_self(), getpid(), getppid(), syscall(SYS_gettid), (long int) pthread_self());
    return NULL;
}

int main() {
    pthread_t tid;
    printf("Thread[%lu]: Principal. PID: %d, PPID: %d, Kernel TID: %ld, Pthread TID: %ld\n", (long int) pthread_self(), getpid(), getppid(), syscall(SYS_gettid), (long int) pthread_self());

    pthread_create(&tid, NULL, thread_func, NULL);
    pthread_join(tid, NULL);

    return 0;
}
