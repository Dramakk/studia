#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef struct {
    pthread_cond_t cond;
    pthread_mutex_t mtx;
    unsigned howMany;
    unsigned capacity;
} sem_t;

void sem_init(sem_t *sem, unsigned value){
    pthread_mutexattr_t attr;
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK);
    pthread_cond_init(&sem->cond, NULL);
    pthread_mutex_init(&sem->mtx, &attr);
    sem->howMany = value;
    sem->capacity = value;
}

void sem_wait(sem_t *sem){
    assert(pthread_mutex_lock(&sem->mtx) == 0);
    while(sem->howMany == 0) {
        pthread_cond_wait(&sem->cond, &sem->mtx);
    }
    --(sem->howMany);
    assert(pthread_mutex_unlock(&sem->mtx) == 0);
}

void sem_post(sem_t *sem){
    assert(pthread_mutex_lock(&sem->mtx) == 0);
    if(sem->howMany < sem->capacity){ //żeby zapobiec zwiększenia ilośći dostępnych blokad przez wywoływanie wielu post
        ++(sem->howMany);
    }
    assert(pthread_mutex_unlock(&sem->mtx) == 0);
    pthread_cond_signal(&sem->cond);
}

void sem_getvalue(sem_t *sem, int *sval){
    assert(pthread_mutex_lock(&sem->mtx) == 0);
    *sval = sem->howMany;
    assert(pthread_mutex_unlock(&sem->mtx) == 0);
}

int main(void) {
    sem_t sem;
    sem_init(&sem, 1);
    sem_wait(&sem);
    sem_post(&sem);
    return EXIT_SUCCESS;
}