# PRED (Python)

**NOTE: Python version currently only supports class-vector datasets in 2-d or 3-d numpy array form.**

## Description
Python implementation of Pairwise Relative Distance (PRED) for Class-Vector datasets

## Dependencies
- numpy

## How to use
- Copy the pred file to your working directory.
- Add `import pred from pred` to the top of your file
- Use the `pred` function for class-vector type datasets using appropriate formatting

## Function Help
```
Description:
This function calculates Class-Vector Pairwise Relative Distance (PRED) from a 2-d or 3-d arrays of any size.

Arguments:
1. data: 2-d or 3-d numpy array of any size. For 3-d arrays, values along the 3rd dimension are used as
arrays for each Class and Vector combination. There must be at least 2 rows and 2 columns. Each column is
considered as a Class and each row is considered as a Vector.

Returns:
1. S: S is a column array of length n*(n-1)/2, where n = data.shape[0], corresponding to all Vector pairs.
Each value of S is averaged over all m*(m-1)/2 pairs of Classes, where m = data.shape[1]. NaNs are ignored
while calculating the mean.
```

## Acknowledgements
- Thanks to Arjit Kant Gupta for the 2D array implementation of PRED in python
