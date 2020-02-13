This homework asks you to do basic textual analysis to study the
n-gramdistribution of different languages, and examine a "mystery" text to
determine what language it is in.

You will then perform a TF-IDF analysis
# Goals

In this assignment you will:
* Write functions to perform a basic n-gram analysis of texts
* Visualize the n-gram distribution of different texts
* Use this information to analyze a new text.
* Compute TF-IDF scores for a set of documents, then find the most distinctive words.

# Background

## N-grams

In this week's lecture we discussed n-grams: a way of breaking up text into smaller
chunks to analyze their distribution. n-grams are defined over either words in
a sentence (so the 3-grams in "words in a sentence" are "words in a" and "in a
sentence") or over the characters in a sentence (so the 3-grams in "sentence"
are "sen" "ent" "nte" "ten" "enc" "nce"). In this homework, we will use
characters.

It is common to "pad" strings with dummy characters (e.g., `_`) to produce more
useful n-grams (to correctly capture, for example, that 's' is the most common
letter to start words through the 3-gram `__s`). The easiest way to do this is
to alter the sentence that you're building n-grams over by adding `_`s to the
beginning and end.

The interesting feature about n-grams is that different languages have different _distributions_ of n-grams. (In the simple case, the most common letter in English is `e`, but the most common letter in Spanish is `a`. The "1-grams" for English and Spanish have different distributions). This homework will build _3-gram_ distributions for texts in different languages, and you will then use this information to make inferences about a "mystery" text.

## TF-IDF

We also discussed TF-IDF as a metric to find the "most distinctive" words in documents. In this homework, we will compute TF-IDF scores for a set of documents and use that to determine the most distinctive word in each document. You can refer to the [class notes](https://engineering.purdue.edu/~milind/ece20875/2019fall/notes/lecture-13.pdf]) for help with this part of the homework.

## NLTK

NLTK is the Natural Language Toolkit, a set of common text-processing tools for Python. You can install NLTK using:

```
> python3 -mpip install --user nltk
```

> Note: if you are using Jupyter Notebook on Scholar to do your assignments, you are going to want to run this command from a terminal window on Scholar (by SSHing to scholar, or opening a terminal window through Thinlinc). Some students have been having trouble trying to install modules using Jupyter Notebook's built-in terminal.

You may find it helpful to reference the code in [this notebook](https://engineering.purdue.edu/~milind/ece20875/2019fall/notes/lecture-13.ipynb) for examples of using NLTK

We will use NLTK to clean and *lemmatize* the documents before processing the documents. To clean the documents, we will:

1) Remove *stop words* from each document:
2) Remove punctuation from the document (you may use the `remove_punc` helper method in `helper.py` to help with this)
2) Make the words lower case
4) Lemmatize the words

There are examples of steps 1 and 3 in the notebook linked above.

# Instructions

## 0) Set up your repository for this homework.

Use the link on Piazza to set up Homework 8.

The repository should contain several files:

1. This README
2. Two starter files with some function stubs called `hw8-1.py` and `hw8-4.py`
3. A helper file called `helper.py` (this contains code to plot histograms, and to remove punctuation from a string)
4. 6 translations of the UN Declaration on Human Rights in different languages, in the subdirectory `ngrams/`: `english.txt`, `spanish.txt`, `italian.txt`, `french.txt`, `german.txt`, `portuguese.txt`
5. A "mystery" file, `mystery.txt` where you are supposed to detect the language it is in, in the subdirectory `ngrams/`
6. A directory, `lecs/` that contains 14 text files. These are the documents you will process for Problem 4

## 1) Homework Problem 1: Creating n-grams

For problem 1, please fill in the functions `getText`, `getNgrams`, and `getDict` as described in `hw8-1.py` to read an input file into a list of its lines, then process those lines to construct a _dictionary_ of n-grams. (A dictionary is a built-in Python type that creates a mapping from a key -- in this case, an n-gram -- to a value -- in this case, the number of times that n-gram appears). Pay careful attention to the processing we want you to do on each line (pad it out with `_`s, make all the text lowercase) and _how_ we want you to do the processing (using `map` when called for.)

Create a new file called `problem1.py` with code to build a dictionary for a file specified on the command line, then _process_ that dictionary to print the 10 most common n-grams in the file. (You may find the following StackOverflow post helpful: https://stackoverflow.com/questions/613183/how-do-i-sort-a-dictionary-by-value). You should use the functions that you defined in `hw8.py`.

```
> python3 problem1.py ngrams/english.txt
> [('the', 149), (' th', 142), (' an', 129), ('he ', 121), ('nd ', 113), ('and', 111), ('ion', 102), (' of', 93), ('of ', 89), ('tio', 88)]
```

Submit `problem1.py` and the filled-in version of `hw8-1.py`

## 2) Homework Problem 2: Visualizing n-grams

For problem 2, create a new file called `problem2.py` with code to:

1. Build a list of all the ngrams in _all 6_ language files (i.e., build dictionaries for all 6 files and create a set of all the n-grams in those files). You may find it helpful to use the python `set` data structure.
2. Create a sorted list (alphabetical order) of all the n-grams across all 6 files.
3. Plot frequency histograms for each of the 6 language files. Do this by creating a list with one entry for each n-gram (according to the order of n-grams from step 2) and putting the frequency of that n-gram in the entry (0 if the n-gram doesn't appear in a language at all). You can use `plotHisto` from `helper.py` for this step. Store the resulting histograms in corresponding PNGs (i.e., `english.txt`'s histogram will be `english.png`).

Submit the frequency histograms you generate.

## 3) Homework Problem 3: Identifying a language

Use the code from steps 1 and 2 to help you identify the language that `mystery.txt` is in. Print the 10 most common n-grams and compare it to the results from step 1, and plot the n-gram histogram (using the same order of n-grams you built in step 2) and compare it to the histograms in step 2. Write a paragraph explaining your guess for the language of `mystery.txt` -- include any relevant information from your investigation (including a plot of the histogram).

Please put your writeup in either a pdf called `problem3.pdf` or a Word doc called `problem3.docx`.

Submit your writeup.

## 4) Homework Problem 4: TF-IDF

For this problem, we will compute the tf-idf scores for all the terms in each document in the `lecs/` folder.

Fill in the missing functions in `hw8-4.py`, according to their specifications. You may find the lecture notes linked above helpful for thinking about the format of the doc-word matrix, and the notebook linked above helpful for thinking about how to construct a doc-word matrix.

> Over the course of the next week, we will post example outputs for each of these functions

Submit your filled in version of `hw8-4.py`

# What you need to submit

Each of the homework problems specify what file(s) to generate and submit for
that problem.

# Submitting your code

Please tag the version of the code that you want to submit with `submission`, as you did in HW0.

Don't forget to commit the code that you want to submit *before* tagging your submission. You have to do this in two steps.