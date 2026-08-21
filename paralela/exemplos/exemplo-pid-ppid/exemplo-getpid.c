#include <sys/types.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <stdbool.h>

// return current thread id
static pid_t gettid() {
    return syscall(SYS_gettid);
}

static bool is_lock_held(pthread_mutex_t * lock) __attribute__((__unused__));
static bool is_lock_held(pthread_mutex_t * lock) {
    return lock->__data.__owner == gettid();
}

int
main()
{
    printf("%d %d\n", getpid(), gettid());
}
