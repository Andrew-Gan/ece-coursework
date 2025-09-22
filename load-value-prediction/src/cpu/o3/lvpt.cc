#include <climits>
#include <iostream>
#include "lvpt.hh"
#include <unordered_map>
#include "base/types.hh"

namespace gem5 {

namespace o3 {

const int LVPT::NUM_ENTRIES[4] = { 1024, 1024, 4096, 8192 };

const int LVPT::HISTORY_DEPTHS[4] = { 1, 1, 16, 64 };

LVPT::LVPT(LVPconfig _config) {
    config = _config;
    historyDepth = HISTORY_DEPTHS[(int)config];
    table.resize(NUM_ENTRIES[(int)config]);
}

RegVal LVPT::getPredictedValue(Addr pc, bool isConstant) {
    std::deque<RegVal> &historyQueue = table.at(myHash(pc));
    if (historyQueue.size() == 0) {
        return 0;
    }
    if (isConstant) {
        return historyQueue.back();
    }
    // count freq of newly added value
    RegVal mostFreqVal = 0;
    int mostFreqValFreq = 0;
    std::unordered_map<RegVal, int> freqMap;
    for(RegVal v : historyQueue) {
        freqMap[v] += 1;
        int vFreq = freqMap.at(v);
        if (vFreq >= mostFreqValFreq) {
            mostFreqVal = v;
            mostFreqValFreq = vFreq;
        }
    }
    return mostFreqVal;
}

void LVPT::setPredictedValue(Addr pc, RegVal value) {
    int index = myHash(pc);
    // remove oldest value and add new value
    std::deque<RegVal> &historyQueue = table.at(index);
    if (historyQueue.size() >= historyDepth) {
        historyQueue.pop_front();
    }
    historyQueue.push_back(value);
}


}
}
