#ifndef __PATHFINDER_H__
#define __PATHFINDER_H__

#include <stdlib.h>
#include <string.h>
#include <math.h>

#define LINE_LEN 30
#define clear_buf(buf, n) for(int i = 0; i < n && buf[i] != '\0'; i++) {buf[i] = '\0';}
#define calc_dist(start, end) sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))

// similar to adjacent.c, for debugging purposes
void print_hash(Node* nodeMap, int vertCount) {
    Node* childNode = NULL;
    for(int i = 0; i < vertCount; i++) {
        printf("%d: ", nodeMap[i].id);
        childNode = nodeMap[i].next;
        while(childNode != NULL) {
            printf("%d ", childNode->id);
            childNode = childNode->next;
        }
        printf("\n");
    }
}

// skip until space char
int _spaceop(char buff[], int* start) {
    int tmp = *start;
    while(buff[*start] != ' ' && buff[*start] != '\n' && buff[*start] != '\0') {(*start)++;}
    return *start - tmp;
}

// split string into multiple ints by space char
void _split_string(char* line, int val[]) {
    char buf[LINE_LEN/3] = {'\0'};
    int index = -1, argc = 0;
    clear_buf(val, 2);
    do {
        clear_buf(buf, LINE_LEN/3);
        int tmp = ++index;
        if(line[index] != ' ') {
            memcpy(buf, &(line[tmp]), _spaceop(line, &index));
            val[argc++] = atoi(buf);
        }
    } while(line[index] != '\n' && line[index] != '\0' && line[index] != EOF);
}

#endif