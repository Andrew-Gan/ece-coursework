#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define LINE_LEN 30
#define clear_buf(buf, n) for(int i = 0; i < n; i++) {buf[i] = '\0';}

typedef struct Node Node;
struct Node{
    int id;
    Node* next;
};

// skip until space char
int _spaceop(char buff[], int* start) {
    int tmp = *start;
    while(buff[*start] != ' ' && buff[*start] != '\n' && buff[*start] != '\0') {(*start)++;}
    return *start - tmp;
}

// split string into multiple ints by space char
void _split_string(char* line, int val[]) {
    char buf[LINE_LEN/3];
    int index = -1, argc = 0;
    clear_buf(val, 3);
    do {
        clear_buf(buf, LINE_LEN/3);
        int tmp = ++index;
        memcpy(buf, &(line[tmp]), _spaceop(line, &index));
        val[argc++] = atoi(buf);
    } while(line[index] != '\n' && line[index] != '\0' && line[index] != EOF);
}

void print_adjacent(int vertCount, Node* hash) {
    for(int i = 0; i < vertCount; i++) {
        printf("%d: ", i);
        Node* currNode = hash[i].next;
        while(currNode != NULL) {
            printf("%d ", currNode->id);
            currNode = currNode->next;
        }
        printf("\n");
    }
}

void free_hash(int vertCount, Node* hash) {
    for(int i = 0; i < vertCount; i++) {
        Node* currNode = hash[i].next;
        while(currNode != NULL) {
            Node* nextNode = currNode->next;
            free(currNode);
            currNode = nextNode;
        }
    }
    free(hash);
}

void read_file(const char* filename) {
    FILE* fp = fopen(filename, "r");
    int val[3] = {0};
    if(fp == NULL) {return;}
    char line_buf[LINE_LEN + 5];

    // get number of vertices and edges from first line
    fgets(line_buf, LINE_LEN, fp);
    _split_string(line_buf, val);
    int vertCount = val[0], edgeCount = val[1];
    
    Node* hash = malloc(sizeof(*hash) * vertCount);
    for(int i = 0; i < vertCount; i++) {hash[i].next = NULL;}

    //skip to edges lines
    for(int i = 0; i < val[0]; i++) {fgets(line_buf, LINE_LEN, fp);}

    // get edges information
    for(int j = 0; j < edgeCount; j++) {
        clear_buf(line_buf, LINE_LEN);
        fgets(line_buf, LINE_LEN, fp);
        _split_string(line_buf, val);
        Node* newnode = malloc(sizeof(*newnode));
        newnode->id = val[1];
        newnode->next = NULL;
        Node* currNode = &(hash[val[0]]);
        while(currNode->next != NULL && currNode->next->id < newnode->id) {currNode = currNode->next;}
        newnode->next = currNode->next;
        currNode->next = newnode;
        // for the other one
        Node* newnode2 = malloc(sizeof(*newnode2));
        newnode2->id = val[0];
        newnode2->next = NULL;
        currNode = &(hash[val[1]]);
        while(currNode->next != NULL && currNode->next->id < newnode->id) {currNode = currNode->next;}
        newnode2->next = currNode->next;
        currNode->next = newnode2;
    }
    fclose(fp);
    print_adjacent(vertCount, hash);
    free_hash(vertCount, hash);
}

int main(int argc, char* argv[]) {
    if(argc != 2) {
        printf("Correct usage: ./adjacent <filename>\n");
        return EXIT_FAILURE;
    }
    read_file(argv[1]);
    return EXIT_SUCCESS;
}