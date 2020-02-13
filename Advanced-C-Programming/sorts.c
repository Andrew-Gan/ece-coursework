#include <stdbool.h>
#include <stdlib.h>
#include "sorts.h"

#include <stdio.h> //debug

int _num_compare(const void*, const void*);
void _list_to_array(ListNode*, int*, int, int);
ListNode* _concatenate_list(List*, const int*, int);
void _concatenate_bst(BSTNode**, int);
void _empty_bst_node(BSTNode*);
int _bst_traversal(BSTNode*, int*, int);
void _merge_break(List*);
void _empty_node(ListNode*);

/* functions below this line are public */

void merge_sort_array(int* array, size_t size)
{
	List list = create_list(array, size);
	merge_sort_list(&list);
	_list_to_array(list.head, array, size, 0);
	empty_list(&list);
	return;
}

void tree_sort_array(int* array, size_t size)
{
	BST bst = create_bst(array, size);
	_bst_traversal(bst.root, array, 0);
	empty_bst(&bst);
	return;
}

void quick_sort_array(int* array, size_t size)
{
	qsort(array, size, sizeof(*array), _num_compare);
	return;
}

/* functions below this line are not public */

void _list_to_array(ListNode* currNode, int* array, int size, int index)
{
	if(index < size)
	{
		array[index] = (*currNode).value;
		index++;
		_list_to_array((*currNode).next, array, size, index);
	}
	return;
}

int _bst_traversal(BSTNode* bstnode, int* array, int index)
{
	if(bstnode != NULL)
	{
		index = _bst_traversal((*bstnode).left, array, index);
		array[index] = (*bstnode).value;
		index++;
		index = _bst_traversal((*bstnode).right, array, index); 
	}
	return(index);
}

int _num_compare(const void* x, const void* y)
{
	int diff = *(int*)x - *(int*)y; 							// 0 if equal, <0 if x<y, >0 if x>y
	return(diff); 
}

List create_list(const int* array, int size)
{
	List list;
	list.head = NULL;
	list.tail = NULL;
	list.size = size;
	
	if(size == 0)
	{
		array = NULL;
	}
	else
	{
		_concatenate_list(&list, array, 0);
	}

	return(list);
}

ListNode* _concatenate_list(List* list, const int* array, int index)
{
	ListNode* node = malloc(sizeof(*node));
	(*node).next = NULL;
	if(index < (*list).size)
	{
		if(index == 0)
		{
			(*list).head = node;								// first node is designated head
		}
		(*list).tail = node;									// new node is designated tail
		(*node).value = array[index];							// assign value to new node
		index++;
		(*node).next = _concatenate_list(list, array, index);
	}
	return(node);
}

void merge_sort_list(List* a_list)
{
	_merge_break(a_list);

	return;
}

void _merge_break(List* a_list)
{
	if((*a_list).head != (*a_list).tail)
	{
		List* list_1 = malloc(sizeof(*list_1));					// create left list
		(*list_1).head = (*a_list).head; 						// head of left list is head of original list
		(*list_1).tail = (*a_list).head; 						// initialize tail of left list as head of original list
		(*list_1).size = (*a_list).size / 2; 					// left list size is half or one less tha  half of original list
		for(int i = 0; i < (*a_list).size / 2 - 1; i++)
		{
			(*list_1).tail = (*(*list_1).tail).next; 			// tail of left list is middle node of original list
		}
		List* list_2 = malloc(sizeof(*list_2));					// create right list
		(*list_2).head = (*(*list_1).tail).next; 				// head of right list as node after middle node of original list
		(*list_2).tail = (*a_list).tail; 						// tail of right list is tail of original list
		(*list_2).size = (*a_list).size - (*list_1).size; 		// right list size is difference between original list size and left list size

		merge_sort_list(list_1); 								// recursion calls to break up list to shorter lists
		merge_sort_list(list_2);

		ListNode* currNode = (*a_list).head; 					// start at head of original list
		int arr1[100] = {0};
		_list_to_array((*list_1).head, arr1, (*list_1).size, 0);
		int arr2[100] = {0};
		_list_to_array((*list_2).head, arr2, (*list_2).size, 0);

		int left_counter = 0;
		int right_counter = 0;
		for(int i = 0; i < (*a_list).size; i++)
		{
			if(right_counter >= (*list_2).size || (left_counter < (*list_1).size && arr1[left_counter] <= arr2[right_counter]))
			{
				(*currNode).value = arr1[left_counter]; 		// if other array reached end and arr1 element is less than arr2 element, append arr1 element to original list
				left_counter += 1;
			}
			else if(left_counter >= (*list_1).size || (right_counter < (*list_2).size && arr1[left_counter] > arr2[right_counter]))
			{
				(*currNode).value = arr2[right_counter]; 		// if other array reached end and arr1 element is greater than arr2 element, append arr2 element to original list
				right_counter += 1;
			}
			if((*currNode).next != NULL)
			{
				currNode = (*currNode).next; 					// current node move to next node
			}
		}
		free(list_1);
		free(list_2);
	}
}

void empty_list(List* a_list)
{
	_empty_node((*a_list).head);
	return;
}

void _empty_node(ListNode* node)
{
	if(node != NULL)
	{
		_empty_node((*node).next);
		free(node);
	}
	return;
}

BST create_bst(const int* array, int size)
{
	BST bst;
	bst.root = NULL;
	for(int i = 0; i < size; i++)
	{
		_concatenate_bst(&(bst).root, array[i]);
	}
	return(bst);
}

void _concatenate_bst(BSTNode** bstnode_root, int currElement)
{
	if(*bstnode_root == NULL)									// if root is NULL, create new node as root
	{
		BSTNode* bstnode = malloc(sizeof(*bstnode));
		(*bstnode).left  = NULL;								// left of new bst node is null
		(*bstnode).right = NULL; 								// right of new bst node is null
		(*bstnode).value = currElement; 						// value of new bst node is the current array element
		*bstnode_root = bstnode; 								// the new bst node is root of binary search tree
	}
	else if(currElement <= (**bstnode_root).value) 				// if value is less than root value, add to left
	{
		_concatenate_bst(&(*bstnode_root) -> left, currElement);
	}
	else if(currElement > (**bstnode_root).value) 				// if value is more than root value, add to right
	{
		_concatenate_bst(&(*bstnode_root) -> right, currElement);
	}
	return;
}

void empty_bst(BST* bst)
{
	_empty_bst_node((*bst).root);
	(*bst).root = NULL;
	return;
}

void _empty_bst_node(BSTNode* bstnode)
{
	if(bstnode != NULL)
	{
		_empty_bst_node((*bstnode).left); 						// check for node in left
		_empty_bst_node((*bstnode).right);  					// check for node in right
		free(bstnode);
	}
	return;
}
/* vim: set tabstop=4 shiftwidth=4 fileencoding=utf-8 noexpandtab: */

