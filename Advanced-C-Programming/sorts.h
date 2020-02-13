#ifndef __sorts_h__
#define __sorts_h__

typedef struct _List {
	struct _ListNode* head;
	struct _ListNode* tail;
	int size;
} List;

typedef struct _ListNode {
	int value;
	struct _ListNode* next;
} ListNode;

typedef struct _BST {
	struct _BSTNode* root;
	int size;
} BST;

typedef struct _BSTNode {
	int value;
	struct _BSTNode* left;
	struct _BSTNode* right;
} BSTNode;

void merge_sort_array(int*, size_t);

void tree_sort_array(int*, size_t);

void quick_sort_array(int*, size_t);

List create_list(const int*, int);

void merge_sort_list(List*);

void empty_list(List*);

BST create_bst(const int*, int);

void empty_bst(BST*);

#endif
