#ifndef __INTERPRETER_H__
#define __INTERPRETER_H__

#include <iostream>
#include <vector>

using namespace std;

enum Type_E {char_t, short_t, int_t, float_t, err_t};
union Value_U {
    char c;
    short s;
    int i;
    float f;
};

class MemObj {
    public:
        MemObj() {};
        virtual ~MemObj() {};
        unsigned char value;
};

class RStackObj {
    public:
        Type_E type;
        Value_U val;
        RStackObj() {};
        RStackObj(Type_E input_type, Value_U input_val) {type = input_type; val = input_val;}
        virtual ~RStackObj() {};
        char getChar()      {return val.c;}
        short getShort()    {return val.s;}
        int getInt()        {return val.i;}
        float getFloat()    {return val.f;}
        int operator==(RStackObj right) {return val.i == right.getInt();}
        int operator<(RStackObj right)  {return val.i < right.getInt();}
        int operator>(RStackObj right)  {return val.i > right.getInt();}
        RStackObj operator+(RStackObj right);
        RStackObj operator-(RStackObj right);
        RStackObj operator*(RStackObj right);
        RStackObj operator/(RStackObj right);
};

RStackObj RStackObj::operator+(RStackObj right) {
    RStackObj retObj;
    retObj.type = type;
    switch (type) {
        case char_t : retObj.val.c = val.c + right.val.c;
            break;
        case short_t : retObj.val.s = val.s + right.val.s;
            break;
        case int_t : retObj.val.i = val.i + right.val.i;
            break;
        case float_t : retObj.val.f = val.f + right.val.f;
    }
    return retObj;
}

RStackObj RStackObj::operator-(RStackObj right) {
    RStackObj retObj;
    retObj.type = type;
    switch (type) {
        case char_t : retObj.val.c = val.c - right.val.c;
            break;
        case short_t : retObj.val.s = val.s - right.val.s;
            break;
        case int_t : retObj.val.i = val.i - right.val.i;
            break;
        case float_t : retObj.val.f = val.f - right.val.f;
    }
    return retObj;
}

RStackObj RStackObj::operator*(RStackObj right) {
    RStackObj retObj;
    retObj.type = type;
    switch (type) {
        case char_t : retObj.val.c = val.c * right.val.c;
            break;
        case short_t : retObj.val.s = val.s * right.val.s;
            break;
        case int_t : retObj.val.i = val.i * right.val.i;
            break;
        case float_t : retObj.val.f = val.f * right.val.f;
    }
    return retObj;
}

RStackObj RStackObj::operator/(RStackObj right) {
    RStackObj retObj;
    retObj.type = type;
    switch (type) {
        case char_t : retObj.val.c = val.c / right.val.c;
            break;
        case short_t : retObj.val.s = val.s / right.val.s;
            break;
        case int_t : retObj.val.i = val.i / right.val.i;
            break;
        case float_t : retObj.val.f = val.f / right.val.f;
    }
    return retObj;
}

class ByteCode : public MemObj {
    public:
        ByteCode();
        virtual ~ByteCode();
        void getChar()  {cout << "Invalid getChar()" << endl;}
        void getShort() {cout << "Invalid getShort()" << endl;}
        void getInt()   {cout << "Invalid getInt()" << endl;}
        void getFloat() {cout << "Invalid getFloat()" << endl;}
};

class ValueT : public MemObj, public RStackObj {
    protected:
        Type_E type;
        Value_U val;
    public:
        ValueT() {}
        virtual ~ValueT();
        void execute() {cout << "Invalid execute()" << endl;}
        char getChar();
        short getShort();
        int getInt();
        float getFloat();
        ValueT operator<<(const ByteCode right) {};
};

char ValueT::getChar() {
    if(type == char_t) {
        return val.c;
    }
    else{
        cout << "Error invalid Value::getChar()\n" << endl;
        return '\0';
    }
}

short ValueT::getShort() {
    if(type == short_t) {
        return val.s;
    }
    else{
        cout << "Error invalid Value::getShort()\n" << endl;
        return '\0';
    }
}

int ValueT::getInt() {
    if(type == int_t) {
        return val.i;
    }
    else{
        cout << "Error invalid Value::getInt()\n" << endl;
        return '\0';
    }
}

float ValueT::getFloat() {
    if(type == float_t) {
        return val.f;
    }
    else{
        cout << "Error invalid Value::getFloat()\n" << endl;
        return '\0';
    }
}

class Halt : public ByteCode {
    public:
        Halt();
        virtual ~Halt();
        void execute();
};

class Pushc : public ByteCode {
    public:
        Pushc();
        virtual ~Pushc();
        void execute();
};

class Printf : public ByteCode {
    public:
        Printf();
        virtual ~Printf();
        void execute();
};

#endif