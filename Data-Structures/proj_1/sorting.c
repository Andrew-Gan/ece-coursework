#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "sorting.h"

#define SEQ1_FILE "seq1.txt"
#define SEQ2_FILE "seq2.txt"

int _cmp(const void*, const void*);
void _swap_element(long*, int, int, bool);

long *Load_File(char *Filename, int *Size)
{
    FILE *fp = fopen(Filename, "r");
    char *size_buffer = malloc(sizeof(*size_buffer) * (*Size));
    size_t buffer_size = sizeof(*size_buffer);
    getline(&size_buffer, &buffer_size, fp);
    *Size = atoi(size_buffer);
    printf("char = %c\n", *size_buffer);
    char *buffer = malloc(sizeof(buffer) * (*Size));
    char *base_buffer = buffer;
    long *list = malloc(sizeof(*list) * (*Size));
    for (int i = 0; i < *Size; i++, buffer++)
    {
        getline(&buffer, &buffer_size, fp);
        list[i] = atoi(buffer);
    }
    free(size_buffer);
    free(base_buffer);
    fclose(fp);
    return (list);
}

int Save_File(char *Filename, long *Array, int Size)
{
    FILE *fp = fopen(Filename, "w");
    char *buffer = malloc(sizeof(*Array) * Size);
    int count = 0;
    itoa(Size, buffer, 10);
    strcat(buffer, "\n");
    fprintf(fp, buffer);
    for (int i = 0; i < Size; i++)
    {
        itoa(Array[i], buffer, 10);
        if (i != Size - 1)
        {
            strcat(buffer, "\n");
        }
        count += fprintf(fp, buffer) > 0 ? 1 : 0;
    }
    free(buffer);
    fclose(fp);
    return (count);
}

void Shell_Insertion_Sort(long *Array, int Size, double *NComp, double *NMove)
{
    int seqLen = 5, valueHolder, innerIndex;
    *NComp = 0;
    *NMove = 0;
    Save_Seq1(SEQ1_FILE, Size);
    long* gapArray = Load_File(SEQ1_FILE, &seqLen);
    for(int gap = gapArray[--seqLen]; seqLen > 0; gap = gapArray[--seqLen]) {
        for(int shellIndex = gap; shellIndex < Size; shellIndex++) {
            valueHolder = Array[shellIndex];
            for(innerIndex = shellIndex; (innerIndex - gap >= 0) && (Array[innerIndex - gap] > valueHolder); innerIndex -= gap, *NComp += 1) {
                    _swap_element(Array, innerIndex - gap, innerIndex, true);
                    *NMove += 1;
            }
            Array[innerIndex] = valueHolder;
        }
    }
}

void Improved_Bubble_Sort(long *Array, int Size, double *NComp, double *NMove)
{
    int seqLen;
    *NComp = 0;
    *NMove = 0;
    Save_Seq2(SEQ2_FILE, Size);
    long *gapArray = Load_File(SEQ2_FILE, &seqLen);
    for (int gapIndex = 0; gapIndex < seqLen; gapIndex++)
    {
        for (int i = 0; i < Size - gapArray[gapIndex]; i++)
        {
            *NComp += 1;
            if (Array[i] > Array[i + gapArray[gapIndex]])
            {
                _swap_element(Array, i, i + gapArray[gapIndex], false);
                *NMove += 3;
            }
        }
    }
}

void Save_Seq1(char *Filename, int N)
{
    FILE *fp = fopen(Filename, "w");
    int currVal = 0, seqLen = 0;
    char *currChar = malloc(sizeof(*currChar) * N);
    char *newChar = malloc(sizeof(*newChar) * N);
	for (int i = 1; i < N; i *= 2)
	{
		for (int j = 1; j < N && currVal < N; j *= 3)
		{
			currVal = i * j;
			if (currVal < N)
            {
                itoa(currVal, newChar, 10);
                strcat(newChar, "\n");
                strcat(currChar, newChar);
                seqLen += 1;
            }
		}
	}
    // print to file
    itoa(seqLen, newChar, 10);
    strcat(newChar, "\n");
    fprintf(fp, newChar);
    fprintf(fp, currChar);
    free(newChar);
    free(currChar);
    fclose(fp);
    // sort sequence
    long *seq = Load_File(Filename, &seqLen);
    qsort(seq, seqLen, sizeof(*seq), _cmp);
    Save_File(Filename, seq, seqLen);
}

int _cmp(const void *a, const void *b)
{
    return (*(int *)a - *(int *)b);
}

void Save_Seq2(char *Filename, int N)
{
    int currVal = N, count = 0;
    char *currStr = malloc(sizeof(*currStr) * N);
    *currStr = '\0';
    char *newStr = malloc(sizeof(*newStr) * N);
    FILE *fp = fopen(Filename, "w");
    do
    {
        currVal /= 1.3;
        if (currVal == 9 || currVal == 10)
        {
            currVal = 11;
        }
        itoa(currVal, newStr, 10);
        strcat(newStr, "\n");
        strcat(currStr, newStr);
        count += 1;
    } while (currVal > 1);
    itoa(count, newStr, 10);
    strcat(newStr, "\n");
    fprintf(fp, newStr);
    fprintf(fp, currStr);
    free(newStr);
    free(currStr);
    fclose(fp);
}

void _swap_element(long *Array, int src, int des, bool shiftMode)
{
    int temp;
    temp = Array[des];
    Array[des] = Array[src];
    Array[src] = shiftMode ? 0 : temp;
}
