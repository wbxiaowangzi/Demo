//
//  LintCode.cpp
//  Demo
//
//  Created by WangBo on 2019/9/6.
//  Copyright © 2019 wangbo. All rights reserved.
//

#include "LintCode.h"
#include <string>

using namespace std;

int digitCounts(int k, int n) {
    string str = string();
    for (int i = 0; i <= n; i++) {
        str += to_string(i);
    }
    int result = 0;
    string kstr = to_string(k);
    for (int i = 0;i<str.length(); i++) {
        string istr = str.substr(i,1);
        if (istr == kstr){
            result++;
        }
    }
    return result;
}

int digitCounts2(int k, int n) {
    string str = string();
    for (int i = 0; i <= n; i++) {
        str += to_string(i);
    }
    int result = 0;
    string kstr = to_string(k);
    for (int i = 0;i<str.length(); i++) {
        string istr = str.substr(i,1);
        if (istr == kstr){
            result++;
        }
    }
    return result;
}
