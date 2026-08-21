#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <pthread.h>

int main() {
    printf("Main PID: %d, PPID: %d, Main TID: %ld, TID: %ld\n",
           getpid(), getppid(), syscall(SYS_gettid), pthread_self());

    return 0;
}
