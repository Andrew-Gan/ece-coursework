#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "json.h"

Node* _list_recursion(Node**, char**, bool);
void _free_node(Node*);

bool parse_int(int* a_value, char** a_pos)
{
	bool foundInt = isdigit(**a_pos) || (isdigit(*(*a_pos + 1)) && (**a_pos) == '-');
	bool isNgv = ((**a_pos) == '-');
	*a_value = 0;
	if(foundInt == true)
	{
		do
		{
			if(**a_pos != '-')
			{
				*a_value *= 10;
				*a_value += **a_pos - '0';
			}
			*a_pos += 1;
		}while(isdigit(**a_pos));
	}
	if(isNgv == true)
	{
		*a_value *= -1;
	}
	return(foundInt);
}

bool parse_string(char** a_string, char** a_pos)
{
	int i = 0;
	*a_string = malloc(sizeof(**a_string) + 5);
	bool foundStr = **a_pos == '"';
	if(foundStr == true)
	{
		do
		{
			if(**a_pos != '"' && **a_pos != '\n')
			{
				(*a_string)[i++] = **a_pos;
			}
			*a_pos += 1;
		}while(**a_pos != '\"' && **a_pos != '\0');
	}
	(*a_string)[i] = '\0';
	foundStr = foundStr && **a_pos == '"';
	*a_pos += 1;
	return(foundStr);
}

bool parse_list(Node** a_head, char** a_pos)
{
	bool foundList = **a_pos == '[';
	if(foundList == true)
	{
		_list_recursion(a_head, a_pos, false);
	}
	foundList = foundList && *(*a_pos - 1) == ']';
	return(foundList);
}

Node* _list_recursion(Node** headNode, char** a_pos, bool isSubList)
{
	bool isValidElement = true;
	Node* currNode = malloc(sizeof(*currNode));
	(*currNode).next = NULL;
	if(**a_pos == '[' && isSubList == false)
	{
		*headNode = currNode;
		*a_pos += 1;
	}
	if(**a_pos != '\0')
	{
		do
		{
			printf("current pos = %c\n", **a_pos); //debug
			while(isspace(**a_pos) == true)
			{
				*a_pos += 1;
			}
			if(isdigit(**a_pos) || (**a_pos) == '-')
			{
				(*currNode).element.type = ELEMENT_INT;
				isValidElement = parse_int(&((*currNode).element.value.as_int), a_pos);
			}
			else if(**a_pos == '"')
			{
				(*currNode).element.type = ELEMENT_STRING;
				isValidElement = parse_string(&((*currNode).element.value.as_string), a_pos);
			}
			else if(**a_pos == '[')
			{
				(*currNode).element.type = ELEMENT_LIST;
				isValidElement = parse_list(&((*currNode).element.value.as_list), a_pos);
			}
			else if(**a_pos == '\0')
			{
				(*currNode).element.type = ELEMENT_NULL;
				(*currNode).element.value.as_null = NULL;
				isValidElement = true;
			}
			else if(strcmp(*a_pos, "true") == 0)
			{
				(*currNode).element.type = ELEMENT_BOOL;
				(*currNode).element.value.as_bool = true;
				isValidElement = true;
			}
			else if(strcmp(*a_pos, "false") == 0)
			{
				(*currNode).element.type = ELEMENT_BOOL;
				(*currNode).element.value.as_bool = false;
				isValidElement = true;
			}
			else
			{
				*a_pos += 1;
			}

		}while(**a_pos != ',' && **a_pos != ']' && **a_pos != '\0' && isValidElement == true);
		*a_pos += 1;
		if(**a_pos == ',')
		{
			*a_pos += 1;
		}
		if(**a_pos != '\0' && isValidElement == true)
		{
			if(**a_pos == '[')
			{
				(*currNode).next = _list_recursion(&(*currNode).element.value.as_list, a_pos, true);
			}
			else
			{
				(*currNode).next = _list_recursion(&(*currNode).element.value.as_list, a_pos, false);
			}
		}
	}
	return(currNode);
}

bool parse_object(BSTNode** a_root, char** a_pos)
{
	
	return(false);	
}

bool parse_element(Element* a_element, char** a_pos)
{
	a_element = malloc(sizeof(*a_element));
	bool isValidElement = true;
	while(isspace(**a_pos) == true)
	{
		*a_pos += 1;
	}
	if(isdigit(**a_pos) || (**a_pos) == '-')
	{
		(*a_element).type = ELEMENT_INT;
		isValidElement = parse_int(&((*a_element).value.as_int), a_pos);
	}
	else if(**a_pos == '"')
	{
		(*a_element).type = ELEMENT_STRING;
		isValidElement = parse_string(&((*a_element).value.as_string), a_pos);
	}
	else if(**a_pos == '[')
	{
		(*a_element).type = ELEMENT_LIST;
		isValidElement = parse_list(&((*a_element).value.as_list), a_pos);
	}
	else if(**a_pos == '\0')
	{
		(*a_element).type = ELEMENT_NULL;
		(*a_element).value.as_null = NULL;
		isValidElement = true;
	}
	else if(strcmp(*a_pos, "true") == 0)
	{
		(*a_element).type = ELEMENT_BOOL;
		(*a_element).value.as_bool = true;
		isValidElement = true;
	}
	else if(strcmp(*a_pos, "false") == 0)
	{
		(*a_element).type = ELEMENT_BOOL;
		(*a_element).value.as_bool = false;
		isValidElement = true;
	}
	else
	{
		isValidElement = false;
	}
	if(isValidElement == true)
	{
		print_element(*a_element);
		free_element(*a_element);
	}
	free(a_element);
	return(isValidElement);
}

void print_element(Element element)
{
	if(element.type == ELEMENT_INT)
	{
		printf("%d", element.value.as_int);
	}
	else if(element.type == ELEMENT_STRING)
	{
		printf("\"%s\"", element.value.as_string); 
	}
	else if(element.type == ELEMENT_LIST)
	{
		Node* currNode = element.value.as_list;
		printf("[");
		do
		{
			print_element((*currNode).element);
			currNode = (*currNode).next;
			if(currNode != NULL)
			{
				printf(",");
			}
		}while(currNode != NULL);
		printf("]");
	}
	else if(element.type == ELEMENT_NULL)
	{
		printf("null");
	}
	else if(element.type == ELEMENT_BOOL)
	{
		if(element.value.as_bool == true)
		{
			printf("true");
		}
		else
		{
			printf("false");
		}
	}
	return;
}

void free_element(Element element)
{
	if(element.type == ELEMENT_STRING)
	{
		free(element.value.as_string);
	}
	else if(element.type == ELEMENT_LIST)
	{
		_free_node(element.value.as_list);
	}
	return;
}

void _free_node(Node* currNode)
{
	if(currNode != NULL)
	{
		_free_node((*currNode).next);
		if((*currNode).element.type == ELEMENT_STRING)
		{
			free((*currNode).element.value.as_string);
		}
		else if((*currNode).element.type == ELEMENT_LIST)
		{
			_free_node((*currNode).element.value.as_list);
		}
		free(currNode);
	}
	return;
}

/* vim: set tabstop=4 shiftwidth=4 fileencoding=utf-8 noexpandtab: */
