#ifndef __SET_B__
#define __SET_B__

#include<iostream>

using namespace std;

class Set {
public:
    int* data;
    int len;
    int copyCount = 0;
    Set(int size);
    Set(const Set&);
    virtual ~Set() {};
    int getCopyCount() {return copyCount;}
};

Set::Set(int size) {
    data = new int [size];
    for(int i = 0; i < size; i++) {
        data[i] = 0;
    } 
    len = size;
}

Set::Set(const Set& src) {
    data = new int [src.len];
    for(int i = 0; i < src.len; i++) {
        data[i] = src.data[i];
    }
    len = src.len;
    copyCount = src.copyCount + 1;
}

Set operator+(const Set left, const int right) {
    Set newSet = Set(left);
    newSet.data[right] = 1;
    return(newSet);
}

Set operator-(const Set left, const int right) {
    Set newSet = Set(left);
    newSet.data[right] = 0;
    return(newSet);
}

Set operator&(const Set left, const Set& right) {
    Set newSet = Set(left);
    for(int i = 0; i < left.len; i++) {
        newSet.data[i] = (left.data[i] + right.data[i]) / 2;
    }
    return(newSet);
}

Set operator/(const Set& left, const Set& right) {
    Set newSet = Set(left);
    for(int i = 0; i < left.len; i++) {
        newSet.data[i] = left.data[i] == 1 && right.data[i] == 0 ? 1 : 0;
    }
    return(newSet);
}

Set operator~(const Set& right) {
    Set newSet = Set(right);
    for(int i = 0; i < right.len; i++) {
        newSet.data[i] = newSet.data[i] == 0 ? 1 : 0;
    }
    return(newSet);
}

std::ostream& operator<<(std::ostream& out, const Set& set) {
    int* data = set.data;
    for(int i = 0; i < set.len; i++) {
        if(data[i] == 1) {
            out << i;
            if(i != set.len-1) {
                out << ", ";
            }  
        }
    }
    return out;
}

#endif