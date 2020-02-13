# Homework 1

### Due Friday, August 30th

Welcome to ECE 20875, Python for Data Science! In this class, you will learn the basics of various topics in data science, and, along the way, learn how to write code in Python.

## Goals

This homework has several objectives:

1. Get familiar with git and GitHub: cloning, committing, tagging, etc.
2. Get familiar with the GitHub Classroom submission system
3. Write some simple bash scripts that use environment variables and input/output redirection.

## Background

### Version Control

This class uses git for version control. Git is a distributed version
control system. That means there are two repositories: local and
remote. When you commit changes, only the local repository is
changed. This makes commits fast and independent of network
connections, but if your computer is damaged, you lose the local
repository. 

To change the remote repository, you need to push the changes.  If
your computer is damaged, you can retrieve the code from the remote
repository.

Please read the guide at github about how to use version control: https://guides.github.com/.

Push your code to GitHub often. Not only does that prevent you from
losing any code if you accidentally delete anything, it helps us help you
debug, by giving us access to your latest code.

The key commands you will need to use in this assignment (and at other times) are:

1. `git clone`: This sets up a new repository on your local machine by "cloning" (copying) a remote repository; in this case, a repository set up on GitHub.
2. `git add`: When you have changed a file, you can "stage" it for the next version (i.e., tell git that you want the changes in this file to appear in the next version) using this command.
3. `git commit`: Creates a new version of your code. This new version is, essentially, all the files you called `git add` on, plus all the _other_ files in the previous version (that you have not `add`ed). This new version only exists in your local repository.
4. `git push`: Updates the remote repository (on GitHub) with all the changes that you have `commit`ted to your local repository. Note that uncommitted changes will not appear on GitHub.
5. `git pull`: Updates your local repository with any changes that are on GitHub and have not yet been reflected in your local repository. Note that there may be some conflcits between what GitHub knows about a file and what your local repository knows, and this command will notify you if that happens (fixing those conflicts requires more work). You should always run `git pull` and resolve any conflicts before running `git push`.
6. `git status`: This shows you the status of any files in your local repository. In particular, it shows you any files that you have modifed, but not yet `add`ed, and any files that you have `add`ed but not yet `commit`ted.
7. `git tag`: This adds a tag to the _currently checked out version_ of your code (i.e., it will not include any modified files that have not yet been `commit`ted). We will use tags to determine which version of your code to grade.

### Bash

Bash is a _shell_ that you can use to manage your Unix environment, run commands, and run scripts. In this homework, we will focus on a few key aspects of bash:

* **Writing a script.** Putting several bash commands into a script gives us a mechanism to perform multiple actions by invoking a single command.
* **Setting and reading environment variables.** Unix programs use environment variables for any number of things. One key feature of these variables is that they can be set _outside_ the scope of a running program or script and can be used _inside_ the program or script. This provides an easy way for users to modify the behavior of a program.
* **Redirecting output.** Commands like `>`, `<`, etc., will redirect the "standard" input and output of a program. Rather than accepting input from the keyboard, `<` will accept input from a specified file. Rather than printing output to the screen, `>` will redirect the output to a specified file. You can redirect "normal" output using `1>`, "error" output using `2>`, and *both* kinds of output using `&>`.
* **Piping output.** Sometimes, you will want to redirect the output of one program to another program. You can do this using the pipe operator `cmd1 | cmd2` which directs the output of `cmd1` to the input of `cmd2`.

A comprehensive reference for bash can be found here: https://tiswww.case.edu/php/chet/bash/bashref.html.

## Starter Code

Clone your HW1 repository by clicking on the GitHub classroom link distributed through Piazza. This will create a repository on GitHub with your user name. Use `git clone` to clone that repository locally.

There should be six files in your repository when you begin:

1. This README file
2. `test.in`, a sample input file you can use for testing purposes
3. `cmd1`, a python file that is one of the programs we ask you to run
4. `cmd2`, a python file that is one of the programs we ask you to run
5. `cmd3`, a python file that is one of the programs we ask you to run
6. `problem1.sh`, a starter file you can use to help get started with problem 1

**In this assignment, you should not modify either `cmd1` or `cmd2`**.

## Instructions

In this homework, you will write two bash scripts that do two *slightly* different things.

> We will use environment variables called `INFILE` (which will contain a filename that we will read input from) and `OUTFILE` (which will contain a filename that we will redirect output to). When grading the homework, we will specify these variables ourselves (so you won't know what they are ahead of time!) but we suggest you set them to `test.in` and `test` for testing purposes.

### Problem 1

Modify `problem1.sh` to run `cmd1`, getting the input from the file specified in the environment variable `INFILE` and pipe the output to `cmd2`. When running with `INFILE` set to `test.in`, the output you see should be:

```
> ./problem1.sh
1 ENIL SI SIHT
2 ENIL SI SIHT
!GNIOG SPEEK TI
ENIL TSAL EHT SI SIHT ,GNIDDIK TSUJ
```

### Problem 2

Create a new script, `problem2.sh` that does the following:

1. Creates a new variable (it does not have to be an environment variable) that is `OUTFILE` *concatenated* with ".out"
2. Prints out the value of this new variable
3. Creates a new variable that is `OUTFILE` *concatenated* with ".err"
4. Runs `cmd1` getting the input from `INFILE`
5. Pipes the output to `cmd3`, which redirects stdout (but not stderr!) to the filename you created in step 1, and stderr (but not stdout!) to the filename you created in step 3.

When running with `INFILE` set to `test.in` and `OUTFILE` set to `test`, you should see the following:

```
> ./problem2.sh
test.out
test.err
> cat test.out
1 ENIL SI SIHT
2 ENIL SI SIHT
ENIL TSAL EHT SI SIHT ,GNIDDIK TSUJ
> cat test.err
I do not like exclamation points
```

## What to Submit

The only files you need to modify (or create) for this homework are `problem1.sh` and `problem2.sh`, which you should submit.

Once you have a version of your code (that you have `commit`ted using `git commit` and `push`ed using `git push`) that you are happy with, tag it with the tag `submission`:

`> git tag -a submission -m "Submission for HW1"`

And then push the tag to GitHub:

`> git push --tags`

This will create a tag named "submission" and push it to the remote server.
The grading system will check out *only* the version you have tagged
"submission".

> You can check if your submission went through successfully by going to your repository on GitHub and clicking the "releases" link. If you successfully tagged your code, you should see a release called `submission`. You can download this to double-check that the code looks the way you want.

If you want to update your submission (and tell the grading system to
ignore any previous submissions) type:

```
> git tag -a -f submission -m "Submission for hw0"
> git push -f --tags
```

This will overwrite any other tag named submission with one for the current
commit.