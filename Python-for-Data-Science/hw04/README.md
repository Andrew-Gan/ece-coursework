# Homework 4: Higher-order Functions

This homework gives you practice in defining and using higher-order functions. 
We'll also teach you a bit of elementary signal processing :-)

# Goals

In this homework you will:

1. Write higher order functions that accept one or more functions as an input
2. Write higher order functions that return a function as output
3. Develop a basic signal processing algorithm (cross-correlation)

# Background

## Higher Order Functions

This homework will get you familiar with several ways to build and use higher
order functions. Before attempting it, please look at the [notes on higher order
functions](https://engineering.purdue.edu/~milind/ece20875/2019fall/notes/lectur
e-07.pdf). You can also look at some [code for higher order
functions](https://engineering.purdue.edu/~milind/ece20875/2019fall/notes/lectur
e-07-code.pdf) that you can use to get inspiration for this homework. Feel free 
to copy and modify any of the code we have already provided for you.

## Stencils and auto-correlation

In Problem 2, we will ask you to write two functions. The first is a generic
*stencil* function, and the second is a function that generates *box filters*
that, when combined, will let you perform
[cross-correlation](https://en.wikipedia.org/wiki/Cross-correlation).

### Stencils

A stencil (in the most general sense) is a way of computing a value for a given
data point by using the values of neighboring data points. Suppose we have a
*stencil function*, `f`. `f` is a function that accepts a list of some fixed
length (for our purposes, let's say 3) and outputs a single value that is some
combination of the values in that list. Here is one example:

```
def f(l) :
	return l[0] * l[1] + l[2]
```

Applying a stencil function means treating the stencil function like a "window"
and "sliding" it across a list, computing the result of the stencil function at
each point. So if I start with the following list:

```
[a, b, c, d, e, f, g]
```

Applying the stencil function produces the following output list:

```
[f([a, b, c]), f([b, c, d]), f([c, d, e]), f([d, e, f]), f([e, f, g])]
```

> Note two things:
> 1. The length of the output list is smaller than the length of the input list. If the input list is length `k`, the output list will be length `k - width + 1`, where `width` is the width of the stencil that `f` applies.
> 2. You can think of a stencil as a generalization of map that uses neighboring elements to compute the output instead of just the element itself. If `f` has a window of width 1, the output is basically like using map.

We will ask you to write a function for applying stencils that takes in an input list, a stencil function, and a third parameter that tells you how wide the stencil function is.

### Box filters and cross correlation

A specific kind of stencil function is called a *box filter*. This is a filter of length `k` that specifies a list of `k` numbers (for a 1-D box filter) and computes its result by multiplying the first element of the filter by the first element of the input, the second element of the filter by the second element of the input, and so on, and then adding all the results together.

So if you have a box filter with elements `b[0], b[1], b[2]` and you applied it to the list `[a, b, c, d, e, f, g]`, you would get:

```
[b[0] * a + b[1] * b + b[2] * c,
 b[0] * b + b[1] * c + b[2] * d,
 b[0] * c + b[1] * d + b[2] * e,
 b[0] * d + b[1] * e + b[2] * f,
 b[0] * e + b[1] * f + b[2] * g]
```

In one dimension, applying a box filter in this way computes the (discrete) 
cross-correlation of the signal in the input list with the signal in the 
filter. This is a measure of similarity between the two signals.

> In two dimensions, box filters can be used to perform image-processing tasks 
> like blurring and edge detection. These types of box filters are also one of 
> the key steps in deep neural networks that operate on images (they form the 
> core of the "convolution" layers).

In the second part of Problem 2, we will ask you to write a function that, when
given a list of box filter elements, *creates a stencil function* from those
elements.

# Instructions

## 0) Set up your repository

Click the link on Piazza to set up your repository for HW 4, then clone it.

The repository should contain two files:

1. `problem1.py`, the file in which you will fill in the functions for problem 1. This file also contains test code you can use to test your solutions.
2. `problem2.py`, the file in which you will fill in the functions for problem 2. This file also contains test code you can use to test your solutions.

## 1) Problem 1: Higher-order functions

In this problem, we ask you to fill in the code for a number of missing functions in `problem1.py`:

1. `composeMap`: This is a variant of `map` that takes a list and *two* functions as its arguments. The output list consists of applying `fun1` then `fun2` to each element of the input list. **Note that you must apply the functions in that order: call `fun1` first, then `fun2` on the output of `fun1`**.

2. `doubleMap`: This is a variant of `map` that applies a single function twice to each element of the input list. You may find it useful to implement `doubleMap` using `composeMap`.

3. `compose`: This is a function that takes in two functions and returns a new function. The new function takes in a single argument, then calls `fun1` followed by `fun2` on that argument, returning the result. Note again that the order matters. Hint: If you have a working `compose` function, you can implement `composeMap` using `compose` and Python's built-in `map` function.

4. `repeater`: This is a tricky one. This function takes in a function, `fun` and an integer, `num_repeats` and returns a new function. The new function takes in an input `x` and calls `fun` on it `num_repeats` times (in other words, you call `fun` on the output of calling `fun` on the output of calling `fun` ... on the input, repeated as many times as `num_repeats`).

### Testing

If your code works, and you run the test code provided in `problem1.py`, you should get the following output:

```
[1, 7, -23, -17, -17, -9, -5, 15, 13, -15]
[-2, 4, -26, -20, -20, -12, -8, 12, 10, -18]
[8, 20, -40, -28, -28, -12, -4, 36, 32, -24]
5
[1, 7, -23, -17, -17, -9, -5, 15, 13, -15]
2
[-2, 4, -26, -20, -20, -12, -8, 12, 10, -18]
repeat 0 times: 5
repeat 1 time: 10
repeat 2 times: 20
repeat 3 times: 40
```

## 2) Problem 2: Stencils

In this problem, we ask you to fill in the two functons in `problem2.py`:

1. `stencil(data, f, width)`: This function applies the stencil function `f`, that looks at `width` elements of an input, to the list `data`, as described in the Background section.
2. `createBox(box)`: This function accepts a list, `box`, and returns a new function and a width. The width is the width of the box (the number of elements that the filter looks at), and the new function is a stencil function that operates on `len(box)` items from an input list and applies a box filter to them as described in the Background section.

### Testing

If your code works, and you run the test code provided in `problem2.py`, you should get the following output:

```
[-1.0, -4.0, -8.0, -5.666666666666667, -3.6666666666666665, 1.6666666666666667, 5.333333333333333, 3.6666666666666665]
[227, 232, 208, 189, 204, 191]
[-1.0, -3.9999999999999996, -7.999999999999999, -5.666666666666666, -3.6666666666666665, 1.6666666666666667, 5.333333333333333, 3.666666666666666]
[-4.5, -6.0, 3.5, 3.0, 8.0, 5.5, -2.5]
```

(The floating point numbers may be rounded a little bit differently, depending on exactly how you implement your box filter.)

# What to Submit

For Problem 1, please submit `problem1.py` with all the appropriate functions filled in.

For Problem 2, please submit `problem2.py` with all the appropriate functions filled in.

# Submitting your code

Please tag the version of the code that you want to submit with `submission`, as you did in the previous HW.

Don't forget to commit the code that you want to submit *before* tagging your submission. You have to do this in two steps.
