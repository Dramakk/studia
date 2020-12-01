#include <iostream>
#include <algorithm>
#include <cstdlib>
#include <utility>
#include <vector>

using namespace std;

// (value, waga)
int main(){
    int weight, how_many;
    scanf("%d", &weight);
    scanf("%d", &how_many);
    vector<pair<int, int>> coins;
    for(int i = 0; i<how_many; i++){
        int we, val;
        scanf("%d %d", &val, &we);
        coins.emplace_back(make_pair(val, we));
    }
    pair<int, int> *max_weight;
    pair<int, int> *result;
    weight = weight+1;
    max_weight = (pair<int, int>*)malloc(weight * sizeof(pair<int, int>));
    result = (pair<int, int>*)malloc(weight * sizeof(pair<int, int>));
    int *to_print_max;
    int *to_print_min;
    to_print_max = (int*)malloc(how_many * sizeof(int));
    to_print_min = (int*)malloc(how_many * sizeof(int));
    int max, min;
    for(int j=0; j<weight; j++){
        max_weight[j] = make_pair(0, 0);
    }
    for(int j=0; j<how_many; j++){
        to_print_max[j] = 0;
        to_print_min[j] = 0;
    }
    int index = 0;
    for(auto i=coins.begin(); i!=coins.end(); ++i){
        for(int j=0; j<weight; j++) {
            if (j - i->second >= 0) {
                if (max_weight[j].first <= max_weight[j - i->second].first + i->first && max_weight[j - i->second].second + i->second == j) {
                    max_weight[j].first = max_weight[j - i->second].first + i->first;
                    max_weight[j].second = max_weight[j - i->second].second + i->second;
                    result[j] = make_pair(index, i->second);
                }
            }
        }
        index++;
    }
    if(max_weight[weight-1].first == 0){
        printf("NIE");
        return 0;
    }
    else{
        printf("TAK\n");
        int i = weight-1;
        while(i > 0){
            to_print_max[result[i].first]++;
            i = i-result[i].second;
        }
        max = max_weight[weight-1].first;
    }
    index = 0;
    for(auto i=coins.begin(); i!=coins.end(); ++i){
        for(int j=0; j<weight; j++) {
            if (j - i->second >= 0) {
                if (max_weight[j].first >= max_weight[j - i->second].first + i->first && max_weight[j - i->second].second + i->second == j) {
                    max_weight[j].first = max_weight[j - i->second].first + i->first;
                    max_weight[j].second = max_weight[j - i->second].second + i->second;
                    result[j] = make_pair(index, i->second);
                }
            }
        }
        index++;
    }
    int i = weight-1;
    while(i > 0){
        to_print_min[result[i].first]++;
        i = i-result[i].second;
    }
    min = max_weight[weight-1].first;
    printf("%d\n", min);
    for(int j=0; j<how_many; j++){
        printf("%d ", to_print_min[j]);
    }
    printf("\n");
    printf("%d\n", max);
    for(int j=0; j<how_many; j++){
        printf("%d ", to_print_max[j]);
    }
    printf("\n");
    return 0;
}

