#ifndef __SET_A__
#define __SET_A__

#include<iostream>

using namespace std;

class Set {
    int* data;
public:
    int len;
    int copyCount = 0;
    Set(int size);
    Set(const Set&);
    virtual ~Set() {};
    int* getData() const;
    int getCopyCount() {return copyCount;}
    Set operator+(const int);
    Set operator-(const int);
    Set operator&(const Set&);
    Set operator/(const Set&);
    Set operator~();
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

int* Set::getData() const {
    return(data);
} 

Set Set::operator+(const int right) {
    Set newSet = Set(*this);
    newSet.data[right] = 1;
    return(newSet);
}

Set Set::operator-(const int right) {
    Set newSet = Set(*this);
    newSet.data[right] = 0;
    return(newSet);
}

Set Set::operator&(const Set& right) {
    Set newSet = Set(right);
    for(int i = 0; i < len; i++) {
        newSet.data[i] = (data[i] + right.data[i]) / 2;
    }
    return(newSet);
}

Set Set::operator/(const Set& right) {
    Set newSet = Set(right);
    for(int i = 0; i < len; i++) {
        newSet.data[i] = data[i] == 1 && right.data[i] == 0 ? 1 : 0;
    }
    return(newSet);
}

Set Set::operator~() {
    Set newSet = *this;
    for(int i = 0; i < len; i++) {
        newSet.data[i] = newSet.data[i] == 0 ? 1 : 0;
    }
    return(newSet);
}

std::ostream& operator<<(std::ostream& out, const Set& set) {
    int* data = set.getData();
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