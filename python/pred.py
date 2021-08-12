"""
# Author: Aarush Mohit Mittal
# Contact: aarush (dot) mohit (at) gmail (dot) com
# Version: 0.1
"""

"""
Changelog:
v0.1 (2021-08-12):
    - Initial release with class-vector numpy support
"""
import numpy as np
from itertools import combinations


def pred(data):
    '''
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
    '''

    n_row = data.shape[0]
    n_col = data.shape[1]
    row_comb = list(combinations(np.arange(n_row), 2))
    col_comb = list(combinations(np.arange(n_col), 2))
    s = np.zeros((len(row_comb), 1))
    for i, row_pair in enumerate(row_comb):
        temp_s = []
        for col_pair in col_comb:
            temp_data = data[row_pair, :][:, col_pair][:]
            temp_s.append(computepred(temp_data))
        s[i] = np.nanmean(temp_s)
    return s


def computepred(data):
    d_2 = np.linalg.norm(data[0, 0] - data[1, 1]) ** 2 + np.linalg.norm(data[0, 1] - data[1, 0]) ** 2
    d_1 = np.linalg.norm(data[0, 0] - data[1, 0]) ** 2 + np.linalg.norm(data[0, 1] - data[1, 1]) ** 2
    return (d_2 - d_1) / (d_2 + d_1)
