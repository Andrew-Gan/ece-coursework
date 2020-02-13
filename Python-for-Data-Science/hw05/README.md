# Homework 5: Sampling, Hypothesis Testing, and Confidence Intervals

This homework will give you practice in hypothesis testing and confidence intervals with Python. It is the first homework that has a significant writeup component.

# Goals

In this homework you will:

1. Formulate hypotheses and carry out appropriate statistical tests
2. Compute confidence intervals based on appropriate assumptions
3. Work with a real dataset (student behavioral data)

# Background

Before attempting the homework, please review the notes on [sampling](https://engineering.purdue.edu/~milind/ece20875/2019fall/notes/lecture-08.pdf) and [hypothesis tests / confidence intervals](https://engineering.purdue.edu/~milind/ece20875/2019fall/notes/lecture-09.pdf). Feel free to copy and modify any of the code we have provided for you here.

## Python Functions

### Reading .txt files
There are several different file formats for data, including .csv and .json which we will cover later. One of the simplest is storing in text (.txt) files, which is how the data is provided to you in this homework. To get each line of a text file `sample.txt` stored as a separate element in a list `data`, you can write:

```
myFile = open('sample.txt')
data = myFile.readlines()
myFile.close()
```

Each element of `data` will be a string. To convert them to floats, we can use a list comprehension:

```
data = [float(x) for x in data]
```

### Mean and Standard Deviation
While they are relatively easy to write manually, the `numpy` library in Python has built-in functions for finding the mean and standard deviation of a list. To import it, we can write:

```
import numpy as np
```

The mean of `data` is found as

```
avg = np.mean(data)
```

To find the standard deviation, type

```
sd = np.std(data, ddof=x)
```
where `x` is the differential from the number of samples `N` to determine the degrees of freedom. Typically, we want `ddof=1` (which divides by `N-1` instead of `N`) unless we know the population mean (in which case `ddof=0`).

### Standard Normal and Student's t Distributions
The two distributions you will rely on heavily in this homework are the `standard normal (z)` and the `student's t` distributions.

To import the standard normal distribution, type

```
from scipy.stats import norm
```

Then, to find the probability that a value lies below a particular point `z_c`, type

```
p = norm.cdf(z_c)
```

Inversely, to find the point `z_c` below which the probability is `p`, type

```
z_c = norm.ppf(p)
```

To import the Student's t distribution, type

```
from scipy.stats import t
```

Then, to find the probability that a value lies below a particular point `t_c`, type

```
p = t.cdf(t_c, df)
```
where `df` is the degrees of freedom for the t distribution.

Inversely, to find the point `t_c` below which the probability is `p`, type

```
t_c = t.ppf(p)
```


## Educational Data Mining
There is a branch of research concerned with analyzing data collected about students to design machine learning-based recommendation systems or personalization engines aimed at improving learning outcomes. Several academic conferences, such as the [Educational Data Mining](http://educationaldatamining.org/) conference, and companies in industry, such as [Zoomi Inc.](https://zoomi.ai/), have been created to pioneer this mission statement.

A popular thrust of this research is investigating relationships between how a student interacts with the learning content in a course (their *behavioral* data) and the knowledge that they gain from the course (their *performance* data); intuitively, higher levels of interaction should translate to more knowledge transfer. For online learning courses (on platforms such as [Coursera](www.coursera.org)), one recently proposed measure of interaction is *engagement*, which translates factors like time spent, length of content, number of clicks, length of annotations, and other application usage information into a single measure between 0 (no engagement) and 1 (maximum engagement). More information on the definition of engagement can be found in [this](http://www.cbrinton.net/edosc_journal.pdf) journal paper.

In this homework, you will work with the engagement data of about 3,000 students who took an online course. We divide them into two groups: those who demonstrated sufficient knowledge of the material after the course (about 1,000), and those who did not (about 2,000). This determination is made based on their performance on the final test in the course, with 75% serving as the passing grade (a 2/3 failing rate is not a good sign!). Viewing "knowledgeable" and "unknowledgeable" students as two different populations, your task in Problem 1 will be to formulate and test different hypotheses about their engagement levels.


# Instructions

## 0) Set up your repository

Click the link on Piazza to set up your repository for HW 5, then clone it.

The repository should contain two files aside from this readme, both of which you will use in Problem 1:

1. `eng0.txt`, a text file containing the engagement scores of students who did not demonstrate knowledge of the course material.
2. `eng1.txt`, a text file containing the engagement scores of students who demonstrated knowledge of the course material.

## 1) Problem 1: Hypothesis Testing

This problem concerns the datasets of student engagement in `eng0.txt` and `eng1.txt`:

1. Suppose the instructor of the course is convinced that the mean engagement of students who become knowledgeable in the material (i.e., the `eng1` population) is 0.75. Formulate null and alternative hypotheses for a statistical test that seeks to challenge this belief. What type of test can be used?

2. Carry out this statistical test using the `eng1` sample. Report the sample size, the sample mean, the standard error, the standard score, and the p-value. Are the results significant at a level of 0.1? How about 0.05? How about 0.01? What (if anything) can we conclude?

3. Determine the largest standard of error for which the test will be significant at a level of 0.05. What is the corresponding minimum sample size? (You may assume that the population variance and approximation does not change.)

4. Suppose the instructor is also convinced that the mean engagement is different between students who become knowledgeable (the `eng1` population) and those who do not (the `eng0` population). Formulate null and alternative hypotheses that seek to validate this belief. What type of test can be used?

5. Carry out this statistical test using the `eng0` and `eng1` samples. Report the sample sizes, the sample means, the standard error, the z-score, and the p-value. Are the results significant? What (if anything) can we conclude?


## 2) Problem 2: Confidence Intervals

In this problem, consider the following dataset of the number of points by which a sports team won in its last 11 games:

`[3, -3, 3, 12, 15, -16, 17, 19, 23, -24, 32]`

In other words, a `3` means the team won by `3` points, and a `-3` means the team lost by `3` points.

1. Use the sample to construct a 95% confidence interval for the number of points by which the team wins on average. Report the sample mean, the standard error, the standard statistic, and the interval.

2. Repeat part 1 for a 90% confidence interval. Compare your results.

3. Repeat part 1 if you are told that the population standard deviation is `16.836`. Compare your results.

4. With what level of confidence can we say that the team is expected to win on average? (Hint: The interval must be strictly positive.)


# What to Submit

For each problem, you must show your work, including the Python code and written explanations of your answers. You can either submit Python files with a separate writeup, or a single jupyter notebook containing both the code and the writeup.

# Submitting your code

Please tag the version of the code that you want to submit with `submission`, as you did in the previous HW.

Don't forget to commit the code that you want to submit *before* tagging your submission. You have to do this in two steps.