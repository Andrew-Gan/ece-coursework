# Homework 3: Histograms and Distributions

This homework asks you to write and use the cross-validation function we discussed in the lecture on histograms to find the "optimal" number of bins for a data set. We then ask you to explore some data to identify its distribution.

# Goals

In this homework you will:

1. Learn how to install new Python modules
2. Build up a complex analysis code by building smaller functions first
3. Perform some basic data exploration

# Background

## Python modules

Python has a lot of built-in functionality right out of the box: basic data structures like lists, sets, and dictionaries, functions that help use those data structures (like `len`), etc. But there are a vast number of Python modules that provide additional functionality. This functionality is not built in -- not everyone needs it -- but Python comes with tools to make it easy to use those modules.

### Installing a module

To install a module, you can use Python's built-in package manager, `pip`. We will provide instructions for installing modules from the command line -- these instructions will work with Python3 installations on Scholar, ECE Grid, most Linux distributions, and Mac OS. There are a number of different ways to get Python3 on Windows, so you will have to look at the documentation for your version to determine how to install a new module.

Modules can be installed globally (so everyone on a machine has access to them) or locally (so only you have access to them). Installing modules globally requires root access to the machine (or other specially-set permissions), so we will provide instructions for installing modules locally.

To install a module named `foo`, you can use the following command:

`python3 -mpip install --user foo`

If `foo` is already installed on your system but you want to upgrade to a new version of it, you can use the command:

`python3 -mpip install --user --upgrade foo`

To complete this homework, you will need to install the following modules:

1. `numpy` : this is a module that provides array and matrix classes, and many mathematical operations on those classes. It is the foundation of many of the modules that are used in data science.
2. `scipy` : this module provides many useful functions for data analysis, including functions for dealing with probability distributions
3. `matplotlib` : a basic plotting/visualization library.

### Using a module

The functions in a module are in that module's *namespace*. To make sure that the function names do not collide with functions in other modules (or Python's built-in functions), the functions need to be accessed through a prefix. To load a module, you have to tell Python (a) which module to load; and (b) what prefix to use when accessing the functions of that module. For example, the following code:

`import numpy as np`

Tells Python you want to use the module `numpy`, and that you want to access the functions of `numpy` using the prefix `np`. Hence, the following code will read in a list of numbers stored in a text file and give you back a list with those numbers in it:

`data = np.loadtxt('inp.txt')`

You can also use the `import` keyword to bring in functions from other files (think of these like `#include` directives in C). The following command will import the `histogram` function you wrote in homework 2 (if it is in a file called `homework2.py`):

`from homework2 import histogram`

You can also import all of the functions from another file:

`from helper import *`

## Incremental Development

In this homeowrk, we will ask you to write a fairly complex piece of code: finding the number of bins that results in the lowest cross-validation error for a given data set. When you need to write complex code like this, your goal should be to break the problem down into smaller pieces. Write functions that solve each of the smaller pieces, then figure out how to connect those functions together (some of them might call other functions you write) to solve the overall problem.

This approach makes it much easier to write complex code. Both because you do not have to solve the problem all in one go, but also because it makes it easier to *test* your code: you can test each of your smaller pieces individually to make sure that they work properly.

In this homework, we will walk you through one particular way you can break down the problem (and, in fact, we want you to solve the problem in this way -- we will test the individual pieces for partial credit).

# Instructions

## 0) Set up your repository for this homework

Click the link on Piazza to set up your repository for HW 3, then clone it.

The repository should contain 7 files:

1. This README
2. 4 input data files: `inp.txt`, which you will use in problem1, and `distA.csv`, `distB.csv`, and `distC.csv`, which you will use in problem 2
3. A helper file, `helper.py` that contains some useful helper functions for use when writing/testing your code
4. `problem1.py`, a skeleton script for Problem 1

## 1) Problem 1: Cross Validation

In this problem, you will implement the cross-validation procedure for finding the optimal bin width for a histogram built from a data set. This problem builds on the histogram function that you built in homework 2. **You should make one modification**: you should ensure that if the data point you are adding to the histogram is equal to the lower bound that the data point goes into the first bucket in the histogram, and if the data point you are adding to the histogram is equal to the upper bound that the data point goes into the last bucket in the histogram.

> Note: After the submission window for HW2 closes, we will post working histogram code on Piazza -- that way you can do this homework even if you do not have a working histogram method from homework 2.

We have broken the problem down into smaller pieces for you. `problem1.py` has four functions for you to fill in. **Keep the signatures of these functions the same as you are filling them in; we will use these to assign partial credit**.

1. `norm_histogram` takes a histogram of counts and creates a histogram of probabilities.
2. `crossValid` computes the cross validation score for a given histogram and bin width (note that this function can, and should, use the `norm_histogram` function in its implementation)
3. `sweepCross` computes the cross validation score for each of a range of *numbers of buckets* and returns a list of the associated cross validation scores. This function should use `crossValid` in its implementation (note that `sweepCross` cares about the number of buckets while `crossValid` cares about the width of the buckets -- make sure to do the conversion!)
4. `findMin` is a generic function that takes a list of numbers and returns a tuple containing the smallest number in that list and the index of that smallest number.

Over the course of the week, we will post some sample inputs and outputs for each of these functions. You can use `inp.txt`, provided in the repository, as test data.

If your functions all work, and you run the test code that is included in `problem1.py`, you should produce the following output: `(-0.02806172739040306, 15)`

> The `if __name__ == '__main__'` line in `problem1.py` is a useful way to write tests for your code: this is code that will *only* run if you run this file as the main script; if this file is included from another script, this test code will not run.

## Problem 2: Distributions

For problem 2, put your code in a file called `problem2.py` and your writeup in a file called `problem2.doc` or `problem2.pdf`. If you are using Jupyter Notebook, put your code and writeup in `problem2.ipynb`

Problem 2 of the homework asks you to compute quantile-quantile (QQ) plots for three input data sets: `distA.csv`, `distB.csv`, `distC.csv`. 

Each of these data sets was generated using one of 8 possible distributions:

* Gaussian (`norm`)
* Cauchy (`cauchy`)
* Cosine (`cosine`)
* Exponential (`expon`)
* Uniform (`uniform`)
* Laplace (`laplace`)
* Wald (`wald`)
* Rayleigh (`rayleigh`)

For each data set, tell us which distribution was used to generate the data (you may find it helpful to plot histograms of the data sets). Use QQ plots as part of your answer. You may find the `scipy` function `probplot` useful for this. For example, the following code will create a QQ plot comparing an input data set to a Gaussian distribution:

```
import scipy.stats as stats
import matplotlib.pyplot as plt
import numpy as np

data = getData(`distA.csv`)

stats.probplot(data, dist = 'norm', plot=plt)
plt.show() # modify this to write the plot to a file instead
```

(To compare to the other distributions, use the names in parentheses from the above list)

To write plots to a file, use [`matplotlib.pyplot.savefig`](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.savefig.html#matplotlib.pyplot.savefig)

For each data set, save the QQ plot to a file called `[dataset]-[dist].png` (or keep the figure inline if you are using Jupyter Notebook), where [dataset] is the name of the data set (e.g., `distA`) and [dist] is the name of the distribution. In your writeup, tell us, for each data set, *which distribution you think matches that data set*.

# What to Submit

For Problem 1, please submit `problem1.py` with all the appropriate functions filled in.

For Problem 2, please submit the QQ plots you generate (you should have at least one QQ plot per distribution, but in your exploration you may have created more) as well as a writeup telling us which distribution each data set matches.

# Submitting your code

Please tag the version of the code that you want to submit with `submission`, as you did in HW1.

Don't forget to commit the code that you want to submit *before* tagging your submission. You have to do this in two steps.