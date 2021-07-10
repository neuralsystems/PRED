# PRED (MATLAB)

## Description
MATLAB implementation of Pairwise Relative Distance (PRED) for Class-Vector or Class-Sample datasets

## Dependencies

- MATLAB (Tested on R2016a and above)
- Statistics and Machine Learning Toolbox (MATLAB)

## Function Help
```
S = PRED(DATA) calculates PRED for Class-Vector datasets.
DATA can be in one of the following formats:
    - 2-d cell matrix with scalar or row vector values
    - 2-d or 3-d double matrix. For 3-d matrices, values along the 3rd
    dimension are used as vector values for each Class and Vector
    combination.
    There must be at least 2 rows and 2 columns. Each column is
    considered as a Class and each row is considered as a Vector.
S is a column vector of length n*(n-1)/2, where n = size(DATA, 1),
corresponding to all Vector pairs. Each value of S is averaged over all
m*(m-1)/2 pairs of Classes, where m = size(DATA, 2). NaNs are ignored
while calculating the mean.

S = PRED(DATA, CLASS_LABELS) calculates PRED for Class-Sample datasets.
DATA can be in one of the following formats:
    - 1-d column cell vector with scalar or row vector values
    - 1-D column or 2-D double matrix. For 2-d matrices, values along
    the 2nd dimension are used as vector values for each Sample.
    There must be at least 4 rows in data.
CLASS_LABELS specify the Class for each row in DATA and should be
either numeric or a cell of strings. There must be atleast 2 Samples
per Class.
S is a row vector of length m(m-1)/2 corresponding to all Class pairs,
where m = number of Classes. For each pair of Classes i-j, S is
averaged over all n_i*(n_i-1)*n_j*(n_j-1)/2 pairs of Samples (Exhaustive
case) or all n*(n-1)/2 pairs of Samples (Fast case), where n_i, n_j =
number of Samples for Class i and j, respectively; n = max(n_i, n_j).
NaNs are ignored while calculating the mean.

S = PRED(DATA, {}) calculates PRED for Class-Vector datasets but
generates class_labels automatically as 1, 2, ... depending on the
column number. DATA can be specified in the same way as for
Class-Vector case. Each column is considered as a class and each row as
a Sample.

[S, LABELS] = PRED(...) also returns LABELS, which is a cell matrix
specifying the class or vector pair for each value in S. length(LABELS)
is equal to length(D).

[...] = PRED(..., 'PARAM1', VAL1, 'PARAM2', VAL2) specifies additional
parameters and their values. Valid parameters are the following:

    Parameter     Value
    'distance'    Specifies the distance function to be used for
                calculation of distances D1 and D2 in the PRED
                function. 'squaredeuclidean' is used by default.
                Other options are 'euclidean', 'seuclidean',
                'cityblock', 'chebychev' which have the same meaning
                as specified in the pdist function

    Only for Class-Sample case:
    'type'        Either 'exhaustive' (default) or 'fast'. 'exhaustive'
                mode considers all possible Sample pairs per Class
                for calculation and provides a more accurate
                description of data. 'fast' mode only considers a
                subset of the Sample pairs and should only be used if
                number of Samples is large.
```
