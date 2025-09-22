#ifndef __LCT_H__
#define __LCT_H__

#include <vector>
#include "base/types.hh"

namespace gem5 {

namespace o3 {

typedef enum { Unpredictable, Predictable, ConstantPred } LoadType;

class LCT {
  public:
    LCT(LVPconfig _config);
    virtual ~LCT();
    LoadType getLoadType(Addr pc);
    void updateLoadType(Addr pc, bool correct);

  private:
    static const int NUM_ENTRIES[4];
    static const int BIT_PER_ENTRY[4];
    static const int MIN_PREDICTABLE[4];
    static const int MIN_CONSTANT[4];
    LVPconfig config = Simple;
    int bit_per_entry = 0;
    int max_value = 0;
    int min_predictable = -1;
    int min_constant = -1;
    std::vector<int> table;
    size_t numCorrectPred = 0, numTotalPred = 0;

    inline int myHash(int value);
};

}
}

#endif
