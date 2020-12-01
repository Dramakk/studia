#include <utility>
#include <vector>
#include <cstdlib>
#include <iostream>
#include <algorithm>
#include <bits/stdc++.h>
using namespace std;

bool sort_asc_pair(const pair<int,int> &a, const pair<int,int> &b){
    return (a.second < b.second);
}

float min(float x, float y){
    return (x < y)? x : y;
}

typedef struct triangle{
    pair<int, int> p1;
    pair<int, int> p2;
    pair<int, int> p3;
    float circut;
} triangle;

float dist(pair<int, int> x, pair<int, int> y){
    double x1 = x.first;
    double x2 = y.first;
    double y1 = x.second;
    double y2 = y.second;
    return sqrt( (x1-x2)*(x1 - x2) +
                 (y1 - y2)*(y1 - y2));
}

triangle stripClosest(const vector<pair<int, int>> &strip, triangle answear){
    float min = answear.circut;
    float min_answ = answear.circut;
    for (auto i = strip.begin(); i!=strip.end(); ++i) {
        for (auto j = i + 1; j != strip.end() && (j->second - i->second) <= min; ++j) {
            for (auto k = j + 1; k != strip.end() && (k->second - i->second) <= min; ++k) {
                float a = dist(*i, *j);
                float b = dist(*i, *k);
                float c = dist(*j, *k);
                if (a + b + c < min_answ) {
                    answear.p1 = *i;
                    answear.p2 = *j;
                    answear.p3 = *k;
                    answear.circut = a + b + c;
                    min_answ = a+b+c;
                }
            }
        }
    }

    return answear;
}

triangle find_smallest_circut(const vector<pair<int, int>> &X, const vector<pair<int, int>> &Y, int start, int end){
    if(abs(end-start) < 10){
        float min = FLT_MAX;
        triangle answear;
        for(auto i=Y.begin(); i!=Y.end(); ++i){
            for(auto j=i+1; j!=Y.end(); ++j){
                for(auto k=j+1; k!=Y.end(); ++k){
                    float a = dist(*i, *j);
                    float b = dist(*i, *k);
                    float c = dist(*j, *k);
                    if(a+b+c < min){
                        answear.p1 = *i;
                        answear.p2 = *j;
                        answear.p3 = *k;
                        answear.circut = a+b+c;
                        min = a+b+c;
                    }
                }
            }
        }
        return answear;
    }
    else{
        int mid = (end+start)/2;
        pair<int, int> X_split = X[mid];
        vector<pair<int, int>> YL, YP;
        for(auto i=Y.begin(); i!=Y.end(); ++i){
            if(i->first < X_split.first){
                YL.emplace_back(*i);
            }
            else if(i->first > X_split.first){
                YP.emplace_back(*i);
            }
            else if(i->first == X_split.first){
                if(i->second >= X_split.second/2) YP.emplace_back(*i);
                if(i->second < X_split.second/2) YL.emplace_back(*i);
            }
        }
        triangle answL = find_smallest_circut(X, YL, start, mid);
        triangle answP = find_smallest_circut(X, YP, mid+1, end);
        float d = min(answL.circut, answP.circut);
        vector<pair<int, int>> strip;
        auto const predicate = [X_split, d](pair<int, int> const value) { return abs(value.first - X_split.first) <= d; };
        std::copy_if(Y.begin(), Y.end(), back_inserter(strip), predicate);
        if(d == answP.circut) return stripClosest(strip, answP);
        else return stripClosest(strip, answL);
    }
}

int main() {
    int n;
    vector<pair<int, int>> pointsX;
    vector<pair<int, int>> pointsY;
    scanf("%d", &n);
    for(int i = 0; i<n; i++){
        int x, y;
        scanf("%d %d", &x, &y);
        pair<int, int> point = make_pair(x, y);
        pointsX.push_back(point);
    }
    pointsY = pointsX;
    sort(pointsX.begin(), pointsX.end());
    sort(pointsY.begin(), pointsY.end(), sort_asc_pair);
    triangle answ = find_smallest_circut(pointsX, pointsY, 0, n);
    cout << answ.p1.first << " " << answ.p1.second << endl;
    cout << answ.p2.first << " " << answ.p2.second << endl;
    cout << answ.p3.first << " " << answ.p3.second << endl;
    return 0;
}
