#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct ArrayQueue {
    int *t;
    size_t size; // Liczba elementów w kolejsce
    size_t first; // Indeks pierwszego elementu w kolejce
    size_t capacity; // Wielkość tablicy
};

struct ArrayQueue make_queue(size_t initial_capacity){
    struct ArrayQueue q;
    q.t = malloc(sizeof(int) * initial_capacity);
    q.size = 0;
    q.capacity = initial_capacity;
    q.first = 0;
    return q;
};
int pop_first(struct ArrayQueue *q){
    int index;
    index = q->t[q->first];
    q->first++;
    q->size--;
    if(q->first == q->capacity) q->first=0;
    return index;
}
void push_last(struct ArrayQueue *q, int value){
    if(q->size == q->capacity){
        q->t = realloc(q->t, sizeof(int) * 2*q->capacity);
        for(int i = 0; i<q->capacity; i++){
            q->t[i+q->capacity] = q->t[i];
        }
        q->capacity = q->capacity*2;
    }
    q->t[(q->first+q->size)%q->capacity] = value;
    q->size++;
};


int main()
{
    int n;
    scanf("%d", &n);
    char slowa[n][32];
    for(int i = 0; i<n; i++){
            scanf("%s", slowa[i]);
    }
    for(int i = 0; i<n; i++){
        printf("%s ", slowa[i]);
    }
}
