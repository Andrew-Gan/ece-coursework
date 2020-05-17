#ifndef __SPAWN_H__
#define __SPAWN_H__

typedef struct CircularBuffer {
    char buff[10]; // use modular to access index
    int numElements;
    int start;
    int end;
} CircularBuffer;

#endif