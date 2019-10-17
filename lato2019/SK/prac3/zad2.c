#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <ucontext.h>
#include <unistd.h>
#define HOW_MANY_PHILOSOPHERS 100
pthread_t philosophers[HOW_MANY_PHILOSOPHERS];

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

sem_t forks[HOW_MANY_PHILOSOPHERS]; //widelce dla filozofów

void think()
{
    usleep(1+(rand()%1000000));
}

void eat()
{
    usleep(1+(rand()%1000000));
}

void *philosopher(void *params)
{
    int i = *((int *)params);
    think();
    sem_wait(&forks[(i+1) % HOW_MANY_PHILOSOPHERS]);
    sem_wait(&forks[i % HOW_MANY_PHILOSOPHERS]);
    eat();
    sem_post(&forks[(i+1) % HOW_MANY_PHILOSOPHERS]);
    sem_post(&forks[i % HOW_MANY_PHILOSOPHERS]);
    pthread_exit(NULL);
}

void handler(int sig, siginfo_t *info, void *ucontext)
{
    for(int i = 0; i<HOW_MANY_PHILOSOPHERS; i++){
        assert(pthread_cancel(philosophers[i]) == 0);
    }
    exit(EXIT_FAILURE);
}

int main(void) {
    struct sigaction signalHandler;
    signalHandler.sa_handler = (__sighandler_t) handler;
    signalHandler.sa_flags = SA_SIGINFO;
    sigemptyset(&signalHandler.sa_mask);
    sigaction(SIGINT, &signalHandler, 0);
    srand(time(NULL));
    int numbers[HOW_MANY_PHILOSOPHERS];
    for(int i=0; i<HOW_MANY_PHILOSOPHERS; i++)
        numbers[i] = i;
    for(int i=0; i<HOW_MANY_PHILOSOPHERS; i++)
        sem_init(&forks[i], 1);
    for(int i=0; i<HOW_MANY_PHILOSOPHERS; i++) {
        pthread_create(&philosophers[i], NULL, philosopher, (void*)&numbers[i]);
    }
    for(int i=0; i<HOW_MANY_PHILOSOPHERS; i++)
        pthread_join(philosophers[i],NULL);
    printf("Wszyscy się najedli!\n");
    return EXIT_SUCCESS;
}