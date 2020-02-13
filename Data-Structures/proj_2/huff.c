#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define CHUNK_SIZE 80
#define ASCII_COUNT 128
#define TREE_HEIGHT ASCII_COUNT / 2

typedef struct BTNode {
    int value;
    struct BTNode* left;
    struct BTNode* right;
} BTNode;

typedef struct {
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
    if(stack->index <= 0) {return 0;}
    stack->index -= 1;
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

void count_char(FILE* fp, int count[]) {
    int size = 0;
    char readChar;
    fseek(fp, 0, SEEK_SET);
    do {
        readChar = fgetc(fp);
        count[readChar] += 1;
        size++;
    } while(readChar != EOF);
    count[ASCII_COUNT] = 1;
    fseek(fp, 0, SEEK_SET);
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
size_t read_file(FILE* fp, char* buffer) {
    return fread(buffer, 1, CHUNK_SIZE, fp);
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

/*******************************************************************
 * BTNode* create_node(int value, BTNode *left, BTNode *right)
 * 
 * input:
 * int value - value of node to be created
 * BTNode* left - pointer of left child of node
 * BTNode* right - pointer of right child of node
 * 
 * output:
 * BTNode* - pointer to created node
*******************************************************************/
BTNode* create_node(int value, BTNode *left, BTNode *right) {
    BTNode *newNode = malloc(sizeof(*newNode));
    newNode->value = value;
    newNode->left = left;
    newNode->right = right;
    return newNode;
}

/*******************************************************************
 * BTNode* create_node(int count[])
 * 
 * input:
 * int count[] - frequency of characters in input file
 * 
 * output:
 * BTNode* - pointer to root of binary tree
*******************************************************************/
BTNode* build_tree(int count[], int num_leaves) {
    int index_1, index_2, value_1, value_2;
    BTNode *leftNode, *rightNode, *prevTopNode = NULL, *currTopNode;
    bool isDone, extraNode = false; //extra node placed if unique char count is odd
    do {
        isDone = true;
        if(_get_smallest(count, &index_1, &value_1)) {
            leftNode = create_node(index_1, NULL, NULL);
            isDone = false;
        }
        else {
            leftNode = NULL;
            index_1 = 0, value_1 = 0;
        }
        if(num_leaves % 2 == 1 && !extraNode) {
            value_2 = 999;
            rightNode = create_node(129, NULL, NULL);
            isDone = false;
            extraNode = true;
        }
        else if(_get_smallest(count, &index_2, &value_2)) {
            rightNode = create_node(index_2, NULL, NULL);
            isDone = false;
        }
        else {
            rightNode = NULL;
            index_2 = 0; value_2 = 0;
        }
        if(leftNode != NULL || rightNode != NULL) {
            currTopNode = create_node(value_1 + value_2, leftNode, rightNode);
            if(prevTopNode != NULL) {
                if(prevTopNode->value <= currTopNode->value) {
                    currTopNode = create_node(prevTopNode->value + currTopNode->value, prevTopNode, currTopNode);
                }
                else {
                    currTopNode = create_node(prevTopNode->value + currTopNode->value, currTopNode, prevTopNode);
                }
            }
            prevTopNode = currTopNode;
        }
    } while(!isDone);
    return currTopNode;
}

int _bst_traversal(BTNode* root, HuffTable* huff, Stack* stack, int charIndex) {
	if(root != NULL)
	{
        push_stack(stack, 0);
		charIndex = _bst_traversal(root->left, huff, stack, charIndex);
        push_stack(stack, 1);
		charIndex = _bst_traversal(root->right, huff, stack, charIndex);
        if(root->left == NULL && root->right == NULL && root->value <= ASCII_COUNT) {
            huff->charArr[charIndex] = root->value;
            load_stack(stack, huff->binArr, charIndex++ * TREE_HEIGHT);
        }
	}
    pop_stack(stack);
	return(charIndex);
}

/*******************************************************************
 * HuffTable* build_table(BTNode *root, int num_leaves)
 * 
 * input:
 * BTNode* root - pointer to root of binary tree
 * int num_leaves - number of leaf nodes in binary tree
 * 
 * output:
 * HuffTable* - struct type containing char and Huffman code
*******************************************************************/
HuffTable* build_table(BTNode* root, int num_leaves) {
    Stack* stack = malloc(sizeof(*stack));
    init_stack(stack);
    HuffTable* huff = malloc(sizeof(*huff));
    huff->charArr = malloc(num_leaves * sizeof(*(huff->charArr)));
    huff->binArr = malloc(num_leaves * TREE_HEIGHT * sizeof(*(huff->binArr)));
    for(int i = 0; i < num_leaves; i++) {huff->charArr[i] = -1; for(int j = 0; j < TREE_HEIGHT; j++) {huff->binArr[i * TREE_HEIGHT + j] = -1;}}
    _bst_traversal(root, huff, stack, 0);
    free(stack);
    return(huff);
}

/*******************************************************************
 * void write_header(FILE* fp, HuffTable huff, int num_leaves)
 * 
 * input:
 * FILE* fp - pointer to beginning of file to write header
 * HuffTable huff - Huffman table to be written as header
 * int num_leaves - number of leaf nodes (characters) in file
 *
 * header format: each '[]' represents a byte
 * [header size][char a][frequency of a][char b][frequency of b]...
*******************************************************************/
void write_header(FILE* fp, HuffTable huff, int num_leaves) {
    fprintf(fp, "%c", num_leaves + 1);
    for(int i = 0; i < num_leaves; i++) {
        fprintf(fp, "%c", huff.charArr[i]);
    }
}

/*******************************************************************
 * void encode_file(const char* filename, char* buffer, int buffer_size, HuffTable huff)
 * 
 * input:
 * FILE* fp - pointer to file position after header
 * char* buffer - pointer to file content
 * int buffer_size - size of buffer
 * HuffTable huff - struct type returned from build_table()
*******************************************************************/
unsigned char encode_file(FILE* fp, char* buffer, int buffer_size, HuffTable huff, int* j, unsigned char output_8_bit) {
    int huffIndex, i, k;
    char readChar;

    for(int buffIndex = 0; buffIndex < buffer_size; buffIndex++) {
        // read character from original input
        readChar = buffer[buffIndex];
        // search for character in Huffman table
        for(huffIndex = 0; huff.charArr[huffIndex] != readChar; huffIndex++) {}
        // print encoded character into buffer
        i = 0;
        while (huff.binArr[huffIndex * TREE_HEIGHT + i] != -1) {
            output_8_bit *= 2;
            output_8_bit += huff.binArr[huffIndex * TREE_HEIGHT + i++];
            if(++(*j) % 8 == 0) {
                fprintf(fp, "%c", output_8_bit);
                output_8_bit = 0;
            }
        }
        if(buffer_size != CHUNK_SIZE && buffIndex == buffer_size - 1) {
                for(huffIndex = 0; huff.charArr[huffIndex] != ASCII_COUNT; huffIndex++) {}
                for(k = 0; (buffIndex == buffer_size - 1) && k < (8 - *j % 8); k++) {
                    output_8_bit *= 2;
                    if(huff.binArr[huffIndex * TREE_HEIGHT + k] != -1) {
                        output_8_bit += huff.binArr[huffIndex * TREE_HEIGHT + k];
                    }
                }
                fprintf(fp, "%c", output_8_bit);
                output_8_bit = 0;
                if(huff.binArr[huffIndex * TREE_HEIGHT + 8 - *j % 8] != -1) {return 0;}
                for(k = 8 - *j % 8; k < 16 - *j % 8; k++) {
                    output_8_bit *= 2;
                    if(huff.binArr[huffIndex * TREE_HEIGHT + k] != -1) {
                        output_8_bit += huff.binArr[huffIndex * TREE_HEIGHT + k];
                    }
                }
        }
    }
    return output_8_bit;
}

void _clear_bst(BTNode* btnode) {
    if(btnode != NULL)
	{
        _clear_bst(btnode->left);
        _clear_bst(btnode->right);
        free(btnode);
    }
    return;
}

/*******************************************************************
 * void free_all(HuffTable* huff, BTNode* root, char* buffer)
 * 
 * input:
 * HuffTable* huff - pointer to HuffTable
 * BTNode* root - pointer to root node of binary tree
 * char* buffer - pointer to buffer containing file content
*******************************************************************/
void free_all(HuffTable* huff, BTNode* root, char* buffer) {
    free(huff->binArr);
    free(huff->charArr);
    free(huff);
    _clear_bst(root);
    free(buffer);
    return;
}

int main(int argc, char* argv[]) {
    int buffer_size, count[ASCII_COUNT + 1], num_leaves = 0;
    for(int i = 0; i < ASCII_COUNT + 1; i++) {count[i] = 0;}
    unsigned char *buffer = malloc(CHUNK_SIZE), *input = argc >= 2 ? argv[1] : NULL;
    unsigned char *output = malloc(strlen(input) + 6);
    strcpy(output, input);
    strcat(output, ".huff");

    FILE* fp1 = fopen(input, "rb");
    FILE* fp2 = fopen(output, "wb");
    if(fp1 == NULL || fp2 == NULL) {return EXIT_FAILURE;}
    count_char(fp1, count);
    for(int i = 0; i < ASCII_COUNT + 1; i++) {
        if(count[i] > 0) {
            num_leaves++;
        }
    }

    BTNode* headNode = build_tree(count, num_leaves);
    HuffTable* huff = build_table(headNode, num_leaves);
    write_header(fp2, *huff, num_leaves);

    unsigned char output_8_bit;
    int k = 0;
    do {
        buffer_size = read_file(fp1, buffer);
        output_8_bit = encode_file(fp2, buffer, buffer_size, *huff, &k, output_8_bit);
    } while(buffer_size == CHUNK_SIZE);

    free_all(huff, headNode, buffer);
    free(output);
    fclose(fp1);
    fclose(fp2);
    return EXIT_SUCCESS;
}