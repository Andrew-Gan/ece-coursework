#include <iostream>
#include <vector>
// #include <stdint.h>

#include "base/types.hh"

#include "cvu.hh"

// typedef uint64_t Addr;

namespace gem5 {

namespace o3 {

    CVU::CVU(){
    CVU_table = std::vector<std::pair<Addr,int>>(); 
    }

    void CVU::clearCVU(){
        CVU_table.clear();
    }

    void CVU::addBlock(Addr DataAddr, int index){
    //Add to the end of the vector. Memory management will sort itself out. It adds to it's size.
    //Check if the vector is full
    if(CVU_table.size() == MAX_Size){
        CVU_table.erase(CVU_table.begin());
        std::pair<Addr, int> addVector = std::make_pair(DataAddr, index);
        CVU_table.push_back(addVector);
    }
    else if (CVU_table.size() < MAX_Size){
        
        std::pair<Addr, int> addVector = std::make_pair(DataAddr, index);
        CVU_table.push_back(addVector);
        // return 1;
    }        
    }



    // int CVU::removeBlock(Addr DataAddr){ //O, on storage, I remove the block. yes. We get the PC on storage?

    //     int count=0; //Keep a counter variable
    //     int num=0;
    //     while (count < CVU_table.size()){
    //             if (CVU_table[count].first == DataAddr){
    //                 CVU_table.erase(CVU_table.begin() + count);
    //                 num++;
    //             }
    //             count++;
    //         }
    //     return num; //Will return num = 0, if it doesn't remove anything
    // }

   int CVU::removeBlock(Addr DataAddr){
        int num = 0;
        std::vector<std::pair<Addr,int>>::iterator it;
        
        for(it = CVU_table.begin(); it < CVU_table.end(); it++){
            if(it->first== DataAddr){
                CVU_table.erase(it);
                num++;
            }
        }

        return num;
    }
    // int CVU::removeBlockByIndex(int index){
        
    //     int count=0; //Keep a counter variable
    //     int num=0;
    //     while (count < CVU_table.size()){
    //             if (CVU_table[count].second == index){
    //                 CVU_table.erase(CVU_table.begin() + count);
    //                 num += 1;
    //             }
    //             count++;
    //         }


    //     return num;
    // }


    int CVU::removeBlockByIndex(int index){
        int num = 0;
        std::vector<std::pair<Addr,int>>::iterator it;
        
        for(it = CVU_table.begin(); it < CVU_table.end(); it++){
            if(it->second == index){
                CVU_table.erase(it);
                num++;
            }
        }

        return num;
    }

    int CVU::CheckCVUStore(Addr DataAddr){ //Pass on the value to the relevant stage when the value it is present.
        for (std::pair<Addr, int> vectRow : CVU_table){ //Iterate
            if (vectRow.first == DataAddr){ 
                return 1; 
            }
        }
        return 0; //Can check for errors. Default return 0. EOF
    }

    bool CVU::CheckCVULoad(Addr DataAddr, int index){ 
    for (std::pair<Addr, int> vectRow : CVU_table){ 
        if (vectRow.first == DataAddr && vectRow.second == index){ 
            return true;
        }
    }
    return false; //Can check for errors. Default return 0. EOF
    }

    void CVU::printBlock(){
        // std::cout << "Vector Size" << CVU_table.size() << std::endl;
        // for (std::pair<Addr, int> vectRow : CVU_table){
        //     printf("Elements: DataAddr=%d, Index = %d \n", vectRow.first, vectRow.second);
        // }
        // printf("End of print!\n");
    if(CVU_table.size() > 0){

        for( int i = 0; i <= CVU_table.size(); i++){
            printf("Elements: DataAddr=%lu, Index = %d \n", CVU_table[i].first, CVU_table[i].second);
            }
        }
    }


    

}
}