#ifndef __NODE_H__
#define __NODE_H__

typedef struct srcNode srcNode;
typedef struct Node Node;

struct srcNode {
    int id, dist, x, y; // identifier, distance value (default=inf), x and y positions
    srcNode* prev;         // points to node that updated dist
    Node* next;         // points to next linked node
    int isVisited;      // true if visited, false if not
};

struct Node {
    int id; // identifier, distance value (default=inf), x and y positions
    Node* next;         // points to next linked node
};

typedef struct minNode minNode;
struct minNode {
    int id, dist;
    minNode* next;
};

#endif