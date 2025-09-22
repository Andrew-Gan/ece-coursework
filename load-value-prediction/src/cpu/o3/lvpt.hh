#ifndef __LVPT_H__
#define __LVPT_H__

#include <vector>
#include <deque>
#include "base/types.hh"

namespace gem5 {

namespace o3 {

typedef enum { MOST_RECENT, MOST_FREQUENT } GetPredictedMode;

class LVPT {
  public:
    LVPT(LVPconfig _config);
    RegVal getPredictedValue(Addr pc, bool isConstant);
    void setPredictedValue(Addr pc, RegVal value);
    inline int myHash(int value) {return value % table.size();};

  private:
    static const int NUM_ENTRIES[4];
    static const int HISTORY_DEPTHS[4];
    LVPconfig config = Simple;
    int historyDepth = 0;
    std::vector<std::deque<RegVal>> table;
};

}
}

#endif
