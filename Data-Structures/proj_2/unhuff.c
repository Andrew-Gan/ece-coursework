#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define CHUNK_SIZE 80
#define ASCII_COUNT 128
#define TREE_HEIGHT ASCII_COUNT / 2

typedef struct {
    int count;
    unsigned char* charArr;
    int* binArr;  
} HuffTable;

typedef struct {
    int data[TREE_HEIGHT];
    int index;
} Stack;

/*******************************************************************
 * void init_stack(Stack* stack)
 * 
 * input:
 * Stack* stack - stack memory to be initialized
 * 
 * function:
 * Initialize stack with '-1' values and set pointer to 0
*******************************************************************/
void init_stack(Stack* stack) {
    for(int i = 0; i < TREE_HEIGHT; i++) {
        stack->data[i] = -1;
    }
    stack->index = 0;
}

/*******************************************************************
 * void push_stack(Stack* stack, int item)
 * 
 * input:
 * Stack* stack - stack to receive item
 * 
 * function:
 * Push value of item onto stack and increment index by one
*******************************************************************/
void push_stack(Stack* stack, int item) {
    if(stack->index >= TREE_HEIGHT - 1) {return;}
    stack->data[stack->index] = item;
    stack->index++;
}

/*******************************************************************
 * int pop_stack(Stack* stack)
 * 
 * input:
 * Stack* stack - stack to remove item
 * 
 * output:
 * int - Value removed from stack
 * 
 * function:
 * Pop highest item from stack and decrement index by one
*******************************************************************/
int pop_stack(Stack* stack) {
    if(stack->index < 1) {return 0;}
    stack->index--;
    int tmp = stack->data[stack->index];
    stack->data[stack->index] = -1;
    return tmp;
}

/*******************************************************************
 * void load_stack(Stack* stack, int* arr, int offs)
 * 
 * input:
 * Stack* stack - stack from which to unload item
 * int* arr - array to receive items from stack
 * int offs - starting point in array to start receiving item
 * 
 * function:
 * Unload all items in stack into starting point within array
*******************************************************************/
void load_stack(Stack* stack, int* arr, int offs) {
    for(int i = 0; i < TREE_HEIGHT && stack->data[i] != -1; i++) {
        arr[offs + i] = stack->data[i];
    }
}

/*******************************************************************
 * size_t read_file(FILE* fp, char* buffer)
 * 
 * input:
 * FILE* fp - pointer to file
 * char* buffer - location to store read bytes, malloc'ed
 * 
 * output:
 * size_t - size of bytes successfully read from file
*******************************************************************/
size_t read_file(FILE* fp, unsigned char* buffer) {
    return fread(buffer, 1, CHUNK_SIZE, fp);
}

HuffTable* build_table(FILE* fp) {
    int j, header_size = fgetc(fp);
    HuffTable* huff = malloc(sizeof(*huff));
    huff->charArr = malloc(header_size - 1);
    huff->binArr = malloc(100 * TREE_HEIGHT * header_size);
    for(int i = 0; i < TREE_HEIGHT * header_size; i++) {huff->binArr[i] = -1;}
    huff->count = 0;
    for(int i = 0; i < header_size - 1; i++) {
        huff->charArr[i] = fgetc(fp);
        huff->count += 1;
        for(j = 0; j < i / 2; j++) {
            huff->binArr[i * TREE_HEIGHT + j] = 1;
        }
        if(header_size >= 4 && (header_size % 2 == 0 && i > header_size - 3 || header_size % 2 == 1 && i >= header_size - 3)) {j--;}
        if(header_size >= 4) {huff->binArr[i * TREE_HEIGHT + j++] = (header_size % 2 == 0 && i > header_size - 3) || (header_size % 2 == 1 && i >= header_size - 3) ? 1 : 0;}
        huff->binArr[i * TREE_HEIGHT + j] = i % 2;
    }
    return huff;
}

bool _get_smallest(int count[], int *index, int *value) {
    bool obtainedValue = false;
    int i = 0;
    do {
        *value = count[i++];
        if(*value != 0) {
            obtainedValue = true;
        }
    } while(*value == 0 && i < ASCII_COUNT + 1);
    *index = i - 1;

    for(int j = i; j < ASCII_COUNT + 1; j++) {
        if(count[j] > 0 && *value > count[j]) {
            *value = count[j];
            *index = j;
        }
    }

    count[*index] = 0;
    return(obtainedValue);
}

int _find_combination(Stack stack, HuffTable* huff, int* bit_len) {
    bool isSame = false;
    int i, j;
    for(i = 0; i < huff->count && !isSame; i++) {
        for(j = 0, isSame = true; j < TREE_HEIGHT && (huff->binArr[i * TREE_HEIGHT + j] != -1) && isSame; j++) {
            isSame = stack.data[j] == huff->binArr[i * TREE_HEIGHT + j];
        }
    }
    *bit_len = j;
    if(!isSame) {return -1;} else {return --i;} 
}

void char_to_bit(unsigned char src, Stack* stack) {
    for(int i = 0; i < 8; i++) {
        stack->data[i + stack->index] = src;
        for(int j = 0; j < 7 - i; j++) {
            stack->data[i + stack->index] /= 2;
        }
        stack->data[i + stack->index] %= 2;
    }
    stack->index += 8;
    return;
}

void decode_file(FILE* fp, unsigned char* buffer, size_t size_read, HuffTable* huff, Stack* stack, int pseudo_EOF_index) {
    int huffIndex = 0, bit_len, rem_bits = CHUNK_SIZE * 8;
    int bin[TREE_HEIGHT];
    char readChar, output_8_bit = 0;
    int charFound;
    for(int bufferIndex = 0; bufferIndex < size_read; bufferIndex++) {
        char_to_bit(buffer[bufferIndex], stack);
        charFound = 0;
        while(stack->index != 0 && charFound != -1) {
            charFound = _find_combination(*stack, huff, &bit_len);
            if(charFound != -1) {
                if(huff->charArr[charFound] == ASCII_COUNT) {return;}
                fprintf(fp, "%c", huff->charArr[charFound]);
                for(int i = 0; i + bit_len < TREE_HEIGHT; i++) {
                    stack->data[i] = stack->data[i + bit_len];
                }
                stack->index -= bit_len;
            }
        }
    }
}

void free_all(HuffTable* huff, char* buffer, Stack* stack) {
    if(huff != NULL) {free(huff->binArr);free(huff->charArr); free(huff);}
    if(buffer != NULL) {free(buffer);}
    if(stack != NULL) {free(stack);} 
    return;
}

int main(int argc, char* argv[]) {
    char *input = argc >= 2 ? argv[1] : NULL;
    unsigned char *output = malloc(strlen(input) + 8);
    strcpy(output, input);
    strcat(output, ".unhuff");

    FILE* fp1 = fopen(input, "rb");
    FILE* fp2 = fopen(output, "wb");
    if(fp1 == NULL || fp2 == NULL) {return EXIT_FAILURE;}
    unsigned char* buffer = malloc(CHUNK_SIZE);
    HuffTable* huff = build_table(fp1);

    int pseudo_index = -1;
    size_t size_read;
    while(huff->charArr[++pseudo_index] != ASCII_COUNT) {}
    Stack* stack = calloc(1, sizeof(*stack));
    init_stack(stack);
    do { 
        size_read = read_file(fp1, buffer);
        decode_file(fp2, buffer, size_read, huff, stack, pseudo_index);
    } while(size_read == CHUNK_SIZE);
    free(output);
    fclose(fp1);
    fclose(fp2);
    free_all(huff, buffer, stack);
    return EXIT_SUCCESS;
}