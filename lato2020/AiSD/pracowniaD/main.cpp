#include <vector>
#include <stdio.h>
#include <algorithm>
#include <utility>
#include <math.h>
using namespace std;
int find_median(int *numbers, int start, int end){
    sort(numbers+start, numbers+end);
    return numbers[start+(end-start)/2];
}

pair<int, int> partition(int *numbers, int start, int end, int pivot_index, int k){
    int pivot = numbers[pivot_index];
    int index = start;
    swap(numbers[pivot_index], numbers[end-1]);
    for(int i = start; i<end-1; i++){
        if(numbers[i] < pivot){
            swap(numbers[index], numbers[i]);
            index++;
        }
    }
    int old_index = index;
    for(int i = index; i<end-1; i++){
        if(numbers[i] == pivot){
            swap(numbers[old_index], numbers[i]);
            old_index++;
        }
    }
    swap(numbers[end-1], numbers[old_index]);
    return make_pair(index-start, old_index-start);
}
int magic_five(int *numbers, int start, int end, int k) {
    int ab = abs(end - start);
    if(ab <= 10){
        sort(numbers+start, numbers+end);
        return numbers[start+k-1];
    }
    else{
        int no_of_elements = end-start;
        int how_many_fives = (no_of_elements+4)/5;
        int *medians;
        medians = (int *)malloc(how_many_fives*sizeof(int));
        int i;
        for(i = 0; i<no_of_elements/5; i++){
            medians[i] = find_median(numbers, start+(i*5), start+(i+1)*5);
        }
        if (i*5 < no_of_elements)
        {
            medians[i] = find_median(numbers, start+i*5, start+i*5+no_of_elements%5);
            i++;
        }
        int m;
        if(how_many_fives == 1){
            m = medians[0];
        }
        else m = magic_five(medians, 0, how_many_fives, ceil(((double)how_many_fives+1.0)/2.0));
        int pivot_index = find(numbers+start, numbers+end, m) - numbers;
        pair<int, int> lengths = partition(numbers, start, end, pivot_index, k);
        int lessLength = lengths.first;
        int eqLength = lengths.second - lessLength + 1;
        int greaterLength = end-lessLength-eqLength;
        if(k <= lessLength){
            return magic_five(numbers, start, start+lessLength, k);
        }
        else if(k <= lessLength+eqLength) {
            return m;
        }
        else {
            return magic_five(numbers, start+lessLength+eqLength, end, k-lessLength-eqLength);
        }
    }
}
int main(){
    int n, k;
    scanf("%d %d", &n, &k);
    int *numbers;
    numbers = (int *)malloc(sizeof(int)*n);
    for(int i = 0; i<n; i++){
        scanf("%d", numbers+i);
    }
    printf("%d", magic_five(numbers, 0, n, k));
}
