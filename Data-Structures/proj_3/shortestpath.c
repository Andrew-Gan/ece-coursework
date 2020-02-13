#include <stdio.h>
#include <stdbool.h>
#include <limits.h>
#include "node.h"
#include "helper.h"

srcNode* build_map(const char* filename, int* vertCount) {
    int i = 0; ///debug
    FILE* fp = fopen(filename, "r");
    int val[3] = {0};
    if(fp == NULL) {return NULL;}
    char line_buf[LINE_LEN + 5];

    // get number of vertices and edges from first line
    fgets(line_buf, LINE_LEN, fp);
    _split_string(line_buf, val);
    *vertCount = val[0];
    int edgeCount = val[1];
    srcNode* hash = malloc(sizeof(*hash) * (*vertCount));
    //add information to node objects
    for(int i = 0; i < *vertCount; i++) {
        fgets(line_buf, LINE_LEN, fp);
        _split_string(line_buf, val);
        hash[i].dist = INT_MAX;
        hash[i].id   = val[0];
        hash[i].x    = val[1];
        hash[i].y    = val[2];
        hash[i].prev = NULL;
        hash[i].next = NULL;
        hash[i].isVisited = 0;
    }
    // get edges information
    for(int j = 0; j < edgeCount; j++) {
        clear_buf(line_buf, LINE_LEN);
        fgets(line_buf, LINE_LEN, fp);
        _split_string(line_buf, val);
        Node* newNode = malloc(sizeof(*newNode));
        newNode->id = val[1];
        // look for first node in map hashtable
        int i = -1;
        // while(hash[++i].id != val[0]) {}
        i = val[0];
        newNode->next = hash[i].next;
        hash[i].next = newNode;
        // for the other one
        Node* newNode2 = malloc(sizeof(*newNode2));
        newNode2->id = val[0];
        // look for second node in map hashtable
        i = -1;
        i = val[1];
        // while(hash[++i].id != val[1]) {}
        newNode2->next = hash[i].next;
        hash[i].next = newNode2;
    }
    fclose(fp);

    return hash;
}

bool seek_path(srcNode* nodeMap, int vertCount, int src_id, int des_id) {
    int min_id = 0, relDist = INT_MAX;
    minNode *minList = NULL;
    srcNode* parentNode = &(nodeMap[src_id]);
    Node* childNode = NULL;
    parentNode->dist = 0;
    parentNode->isVisited = true;
    while(parentNode->id != des_id) {
        childNode = parentNode->next;
        // calculate distances of children with respect to parent
        // update distance and reverse pointer if calculated distance is greater than existing distance value
        while(childNode != NULL) {
            int newDist = nodeMap[parentNode->id].dist + calc_dist(nodeMap[childNode->id], nodeMap[parentNode->id]);
            if(nodeMap[childNode->id].dist > newDist && nodeMap[childNode->id].isVisited == 0) {
                nodeMap[childNode->id].dist = newDist;
                nodeMap[childNode->id].prev = parentNode;

                // add updated distance and id to minimum queue
                minNode* currNode = minList;
                minNode* newNode = malloc(sizeof(*newNode));
                newNode->dist = newDist;
                newNode->id = childNode->id;
                newNode->next = NULL;
                if(minList == NULL) {minList = newNode;}
                else {
                    while(currNode->next != NULL && currNode->next->dist < newDist) {currNode = currNode->next;}
                    newNode->next = currNode->next;
                    currNode->next = newNode;
                }
            }
            childNode = childNode->next;
        }

        // extract min from min queue
        int tmp = min_id;
        do{
            min_id = minList->id;
            minNode* nodeToBeFreed = minList;
            minList = minList->next;
            free(nodeToBeFreed);
        } while(minList != NULL && nodeMap[min_id].isVisited == 1);

        // if no connection between src and des
        // should not have been 'if(minList == NULL)'
        if(tmp == min_id) {
            return false;
        }
        relDist = INT_MAX;
        parentNode = &(nodeMap[min_id]);
        nodeMap[parentNode->id].isVisited = 1;
    }   
    minNode* tmp = NULL;
    while(minList != NULL) {
        tmp = minList;
        minList = minList->next;
        free(tmp);
    }
    return true;
}

void print_path(srcNode* nodeMap, int des_id) {
    srcNode* currNode = nodeMap;
    for(int i = 0; currNode->id != des_id; i++) {currNode = &(nodeMap[i]);}
    printf("%d\n", currNode->dist);
    int i = 0, stack[1000] = {0};
    while(currNode != NULL) {
        stack[i++] = currNode->id;
        currNode = currNode->prev;
    }
    for(int j = i - 1; j >= 0; j--) {
        printf("%d ", stack[j]);
    }
    printf("\n");
}

void refresh_map(srcNode* nodeMap, int vertCount) {
    for(int i = 0; i < vertCount; i++) {
        nodeMap[i].dist = INT_MAX;
        nodeMap[i].prev = NULL;
        nodeMap[i].isVisited = false;
    }
}

void free_map(int vertCount, srcNode* hash) {
    for(int i = 0; i < vertCount; i++) {
        Node* childNode = hash[i].next;
        while(childNode != NULL) {
            Node* nextNode = childNode->next;
            free(childNode);
            childNode = nextNode;
        }
    }
    free(hash);
}

bool lookForNodeInMap(srcNode* map, int vertCount, int src_id, int des_id) {
    bool srcFound = false, desFound = false;
    for(int i = 0; i < vertCount && (!srcFound || !desFound); i++) {
        if(map[i].id == src_id) {srcFound = true;}
        if(map[i].id == des_id) {desFound = true;}
    }
    return srcFound && desFound;
}

int main(int argc, char* argv[]) {
    if(argc != 3) {
        printf("Correct usage: ./main <map.txt> <query.txt>\n");
        return EXIT_FAILURE;
    }
    FILE* queryfp = fopen(argv[2], "r");
    char querybuf[LINE_LEN + 2] = {'\0'};
    clear_buf(querybuf, LINE_LEN + 2);
    fgets(querybuf, LINE_LEN, queryfp);
    int vertCount, queryNum = atoi(querybuf), val[2] = {0, 0};
    srcNode* nodeMap = build_map(argv[1], &vertCount);
    // print_hash(nodeMap, vertCount);
    for(int i = 0; i < queryNum; i++) {
        clear_buf(querybuf, LINE_LEN + 2);
        fgets(querybuf, LINE_LEN, queryfp);
        _split_string(querybuf, val);
        // check that src and des id exist and are both linked
        if(lookForNodeInMap(nodeMap, vertCount, val[0], val[1]) && seek_path(nodeMap, vertCount, val[0], val[1])) {
            print_path(nodeMap, val[1]);
        }
        else {
            printf("INF\n%d %d\n", val[0], val[1]);
        }
        refresh_map(nodeMap, vertCount);
    }
    free_map(vertCount, nodeMap);
    fclose(queryfp);
    return EXIT_SUCCESS;
}