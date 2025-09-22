#ifndef __CVU_H__
#define __CVU_H__


#include <iostream>
#include <vector>
// #include <stdint.h>

// typedef uint64_t Addr;
#include "base/types.hh"


namespace gem5 {

namespace o3 {

    //enum cvu_config {Simple, Constant, Limit, Perfect}; //The type?
    //enum Prediction {predictable, constant}; //Doesn't rly matter tbh. We're only going to use CVU when it's constant, right? 

    class CVU {
        public: 
            CVU();
            //Add to the CVU
            void addBlock(Addr DataAddr, int index);

            int CheckCVUStore(Addr DataAddr);
            bool CheckCVULoad(Addr DataAddr, int index);
            int removeBlock(Addr DataAddr);
            int removeBlockByIndex(int index);
            void printBlock();
            void clearCVU();

            
        private: 
        std::vector<std::pair<Addr, int>> CVU_table;

        // inline int myHash(Addr inst_addr);

        // std::map<Addr, int> CVU_table;
        // std::list<Addr> CVU_List;
        int MAX_Size = 128; //Max number of rows

    };


}
}

#endif
