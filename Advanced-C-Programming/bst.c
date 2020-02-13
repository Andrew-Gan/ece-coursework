#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef struct _Node {
	int value;
	struct _Node* left;
	struct _Node* right;
} Node;

Node* _create_node(int value) {
	Node* node = malloc(sizeof(*node));
	node->value = value;
	node->left = NULL;
	node->right = NULL;
	return node;
}

void insert(Node** a_root, int value) {
	if(*a_root == NULL)								// if root is NULL, current bstnode is root node
	{
		Node* node = malloc(sizeof(*node));
		(*node).left  = NULL;
		(*node).right = NULL;
		(*node).value = value;
		*a_root = node;
	}
	else if(value <= (**a_root).value) 				// if value is less than root value, move to left
	{
		insert(&(*a_root) -> left, value);
	}
	else if(value > (**a_root).value) 			// if value is more than root value, move to right
	{
		insert(&(*a_root) -> right, value);
	}

	return;
}

void destroy(Node** a_root)
{
	
}

void print_bst(Node* root) {
	if(root != NULL) {
		print_bst(root -> left);
		printf("%d\n", root -> value);
		print_bst(root -> right);
	}
}

int main(int argc, char* argv[])
{
	Node* root = NULL;
	int array[7] = {1, 6, 9, 3, 6, 2, 0};

	for(int i = 0; i < 7; i++)
	{
		insert(&root, array[i]);
	}
	print_bst(root);
	return EXIT_SUCCESS;
}
