#include <iostream>
#include <fstream>
#include <cstring>
#include "interpreter.h"

using namespace std;

// global variables
vector<MemObj> mem;
vector<RStackObj> rstack;
int sp = -1, fpsp = -1, pc = 0;
vector<int> fpstack;
ofstream fp;

vector<MemObj> read_bin(const char* filename) {
    ifstream fp (filename, ios::binary);
    char c;
    vector<MemObj> mem;
    MemObj memObj;
    do {
        c = fp.get();
        if(c != EOF) {
            memObj.value = c;
            mem.push_back(memObj);
        }
    } while(c != EOF);
    fp.close();
    return mem;
}

void control_flow(unsigned char memVal) {
    switch(memVal) {
        case 36 : pc = rstack.at(sp--).getInt();
            rstack.pop_back();
            break;
        case 40 : pc = rstack.at(sp-1).getInt() ? rstack.at(sp).getInt() : pc + 1;
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            break;
        case 44 : fpstack.push_back(sp - rstack.at(sp).getInt() - 1);
            fpsp++;
            sp--;
            pc = rstack.at(sp--).getInt();
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            break;
        case 48 : sp = fpstack.at(fpsp--);
            fpstack.pop_back();
            pc = rstack.at(sp--).getInt();
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
    }
}

void stack_manip(unsigned char memVal) {
    Value_U val;
    switch (memVal) {
        case 68 : {
            val.c = mem.at(pc+1).value;
            RStackObj rObj(char_t, val);
            rstack.push_back(rObj);
            sp++;
            pc += 2;
        }
            break;
        case 69 : {
            val.s = short(mem.at(pc+2).value<<8) + short(mem.at(pc+1).value<<0);
            RStackObj rObj(short_t, val);
            rstack.push_back(rObj);
            sp++;
            pc += 3;
        }
            break;
        case 70 : {
            val.i = int(mem.at(pc+4).value<<24) + int(mem.at(pc+3).value<<16) + int(mem.at(pc+2).value<<8) + int(mem.at(pc+1).value<<0);
            RStackObj rObj(int_t, val);
            rstack.push_back(rObj);
            sp++;
            pc += 5;
        }
            break;
        case 71 : {
            unsigned char b[4] = {mem.at(pc+1).value, mem.at(pc+2).value, mem.at(pc+3).value, mem.at(pc+4).value};
            memcpy(&val.f, &b, sizeof(val.f));
            RStackObj rObj(float_t, val);
            rstack.push_back(rObj);
            sp++;
            pc += 5;
        }
            break;
        case 72 : rstack.at(sp).type = char_t;
            rstack.at(sp).val.c = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getChar();
            pc++;
            break;
        case 73 : rstack.at(sp).type = short_t;
            rstack.at(sp).val.s = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getShort();
            pc++;
            break;
        case 74 : rstack.at(sp).type = int_t;
            rstack.at(sp).val.i = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getInt();
            pc++;
            break;
        case 75 : rstack.at(sp).type = float_t;
            rstack.at(sp).val.f = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getFloat();
            pc++;
            break;
        case 76 : sp -= rstack.at(sp).getInt() + 1;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 77 : for(int i = 0; i < rstack.at(sp).getInt(); i++) {rstack.at(fpstack.at(fpsp)+i+1) = rstack.at(sp - rstack.at(sp).getInt() + i);}
            sp = fpstack.at(fpsp) + rstack.at(sp).getInt();
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 80 : rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1) = rstack.at(sp-1);
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 84 : rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).val.c = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getChar();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 85 : rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).val.s = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getShort();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 86 : rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).val.i = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getInt();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 87 : rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).val.f = rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).getFloat();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 88 : rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).val.c = rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).getChar();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 89 : rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).val.s = rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).getShort();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 90 : rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).val.i = rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).getInt();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break;
        case 91 : rstack.at(fpstack.at(fpsp) + rstack.at(sp).getInt() + 1).val.f = rstack.at(fpstack.at(fpsp) + rstack.at(sp-1).getInt() + 1).getFloat();
            sp -= 2;
            rstack.erase(rstack.begin() + sp + 1, rstack.end());
            pc++;
            break; 
        case 94 : {
            RStackObj tmp = rstack.at(sp-1);
            rstack.at(sp - 1) = rstack.at(sp);
            rstack.at(sp) = tmp;
            pc++;
        }
    }
}

void arithmetic(unsigned char memVal) {
    switch(memVal) {
        case 100 : rstack.at(sp - 1) = rstack.at(sp - 1) + rstack.at(sp);
            break;
        case 104 : rstack.at(sp - 1) = rstack.at(sp - 1) - rstack.at(sp);
            break;
        case 108 : rstack.at(sp - 1) = rstack.at(sp - 1) * rstack.at(sp);
            break;
        case 112 : rstack.at(sp - 1) = rstack.at(sp - 1) / rstack.at(sp);
    }
    pc++;
    sp--;
    rstack.pop_back();
}

void comparison(unsigned char memVal) {
    switch(memVal) {
        case 132: rstack.at(sp-1).val.i = rstack.at(sp-1) == rstack.at(sp);
            break;
        case 136: rstack.at(sp-1).val.i = rstack.at(sp-1) < rstack.at(sp);
            break;
        case 140: rstack.at(sp-1).val.i = rstack.at(sp-1) > rstack.at(sp);
    }
    rstack.at(sp-1).type = int_t;
    sp--;
    pc++;
    rstack.pop_back();
}

void spec_op(unsigned char memVal) {
    switch(memVal) {
        case 144 : fp << int(rstack.at(sp--).getChar()) << endl;
            break;
        case 145 : fp << int(rstack.at(sp--).getShort()) << endl;
            break;
        case 146 : fp << int(rstack.at(sp--).getInt()) << endl;
            break;
        case 147 : fp << float(rstack.at(sp--).getFloat()) << endl;
            break;
    }
    pc++;
    rstack.pop_back();
}

void halt() {
    fp << endl << "Compile values:" << endl;
    fp << "PC: " << pc << endl;
    fp << "sp: " << sp << endl;
    fp << "rstack: ";
    if(sp == -1) {fp << "empty" << endl;}
    else {
        for(int i = 0; i <= sp; i++) {fp << rstack.at(i).getInt() << " ";}
        fp << endl;
    }
    fp << "fpsp: " << fpsp << endl;
    fp << "fpstack: ";
    if(fpsp == -1) {fp << "empty";}
    else {
        for(int j = 0; j <= fpsp; j++) {fp << fpstack.at(j) << " ";}
    }
}

int main(int argc, char* argv[]) {
    int fsize;
    if(argc != 3) {cout << "Correct usage: ./interpreter <input filename> <output filename>" << endl; return 1;}
    mem = read_bin(argv[1]);
    fp.open(argv[2]);
    while(pc >= 0) {
        switch(mem.at(pc).value) {
            // control flow bytecodes
            case 36 ... 48      :   control_flow(mem.at(pc).value);
                break;
            // stack manipulation byte codes
            case 68 ... 94      :   stack_manip(mem.at(pc).value);
                break;
            // arithmetic byte codes
            case 100 ... 112    :   arithmetic(mem.at(pc).value);
                break;
            // comparison bytecodes
            case 132 ... 140    :   comparison(mem.at(pc).value);
                break;
            // special operations codes
            case 144 ... 147    :   spec_op(mem.at(pc).value);
                break;
            case 0              :   halt(); return 0;
                break;
            default             :   fp << "Scheisse! Dies ist ein ungültiger Befehl!" << endl;
                return 1;
        }
    }
    fp.close();
    return 0;
}