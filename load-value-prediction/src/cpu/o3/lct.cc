#include <climits>
#include <cmath>
#include "lct.hh"
#include "base/trace.hh"
#include "debug/LVP.hh"

namespace gem5 {

namespace o3 {

const int LCT::NUM_ENTRIES[4] = { 256, 256, 1024, 2048 };

const int LCT::BIT_PER_ENTRY[4] = { 2, 1, 2, 4 };    // Not sure for prefect config

const int LCT::MIN_PREDICTABLE[4] = { 2, -1, 2, 8 };   // Not sure for prefect config

const int LCT::MIN_CONSTANT[4] = { 3, 1, 3, 14 }; // set all to non constant for now

LCT::LCT(LVPconfig _config) {
    config = _config;
    bit_per_entry = BIT_PER_ENTRY[(int)config];
    max_value = pow(2, bit_per_entry)-1;
    min_predictable = MIN_PREDICTABLE[(int)config];
    min_constant = MIN_CONSTANT[(int)config];
    table = std::vector<int>(NUM_ENTRIES[(int)config]);
}

LCT::~LCT() {
    DPRINTF(LVP, "LVP accuracy: %d\n", 100 * numCorrectPred / numTotalPred);
}

LoadType LCT::getLoadType(Addr pc) {
    int value = table[myHash(pc)];
    int load_type = value & max_value;
    if ((load_type >= min_constant) && (min_constant != -1)) {
        return ConstantPred;
    } else if (load_type >= min_predictable && (min_predictable != -1)) {
        return Predictable;
    } else {
        return Unpredictable;
    }
}

void LCT::updateLoadType(Addr pc, bool correct) {
    int index = myHash(pc);
    int value = table[index];
    if (correct) {
        if (value != max_value) {
            value += 1;
            table[index] = value;
        }
    } else {
        if (value != 0) {
            value -= 1;
            table[index] = value;
        }
    }
    numCorrectPred += correct;
    numTotalPred++;
}

inline int LCT::myHash(int value) {
    return value % table.size();
}

}
}
