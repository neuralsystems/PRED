function [s, labels] = pred(data, varargin)
%PRED Pairwise Relative Distance for Class-Vector or Class-Sample datasets
%   S = PRED(DATA) calculates PRED for Class-Vector datasets.
%   DATA can be in one of the following formats:
%       - 2-d cell matrix with scalar or row vector values
%       - 2-d or 3-d double matrix. For 3-d matrices, values along the 3rd
%         dimension are used as vector values for each Class and Vector
%         combination.
%       There must be at least 2 rows and 2 columns. Each column is
%       considered as a Class and each row is considered as a Vector.
%   S is a column vector of length n*(n-1)/2, where n = size(DATA, 1),
%   corresponding to all Vector pairs. Each value of S is averaged over all
%   m*(m-1)/2 pairs of Classes, where m = size(DATA, 2). NaNs are ignored
%   while calculating the mean.
%
%   S = PRED(DATA, CLASS_LABELS) calculates PRED for Class-Sample datasets.
%   DATA can be in one of the following formats:
%       - 1-d column cell vector with scalar or row vector values
%       - 1-D column or 2-D double matrix. For 2-d matrices, values along
%         the 2nd dimension are used as vector values for each Sample.
%       There must be at least 4 rows in data.
%   CLASS_LABELS specify the Class for each row in DATA and should be
%   either numeric or a cell of strings. There must be at least 2 Samples
%   per Class.
%   S is a row vector of length m(m-1)/2 corresponding to all Class pairs,
%   where m = number of Classes. For each pair of Classes i-j, S is
%   averaged over all n_i*(n_i-1)*n_j*(n_j-1)/2 pairs of Samples (Exhaustive
%   case) or all n*(n-1)/2 pairs of Samples (Fast case), where n_i, n_j =
%   number of Samples for Class i and j, respectively; n = max(n_i, n_j).
%   NaNs are ignored while calculating the mean.
%
%   S = PRED(DATA, {}) calculates PRED for Class-Vector datasets but
%   generates class_labels automatically as 1, 2, ... depending on the
%   column number. DATA can be specified in the same way as for
%   Class-Vector case. Each column is considered as a class and each row as
%   a Sample.
%
%   [S, LABELS] = PRED(...) also returns LABELS, which is a cell matrix
%   specifying the class or vector pair for each value in S. length(LABELS)
%   is equal to length(D).
%
%   [...] = PRED(..., 'PARAM1', VAL1, 'PARAM2', VAL2) specifies additional
%   parameters and their values. Valid parameters are the following:
%
%       Parameter     Value
%       'distance'    Specifies the distance function to be used for
%                     calculation of distances D1 and D2 in the PRED
%                     function. 'squaredeuclidean' is used by default.
%                     Other options are 'euclidean', 'seuclidean',
%                     'cityblock', 'chebychev' which have the same meaning
%                     as specified in the pdist function
%
%       Only for Class-Sample case:
%       'type'        Either 'exhaustive' (default) or 'fast'. 'exhaustive'
%                     mode considers all possible Sample pairs per Class
%                     for calculation and provides a more accurate
%                     description of data. 'fast' mode only considers a
%                     subset of the Sample pairs and should only be used if
%                     number of Samples is large.

%*************************************************************************%
% Author: Aarush Mohit Mittal
% Contact: aarush (dot) mohit (at) gmail (dot) com
% Version: 1.1
%*************************************************************************%

%*************************************************************************%
% Changelog:
% v1.1 (2021-07-10):
%   - Replaced nanmean with mean for future stability
%   - Fixed brackets for backwards compatibility
% v1.0 (2021-06-28):
%   - Initial release
%*************************************************************************%

assert(~isempty(data), 'PRED:EmptyData', 'Required non-empty data')
if iscell(data)
    assert(any(~cellfun(@isempty, data(:))), 'PRED:EmptyCellElements', 'Required non-empty cell data')
else
    assert(any(~isnan(data(:))), 'PRED:AllNANValues', 'Required non-nan data')
end

if nargin > 1 && ~verLessThan('matlab','9.2')
    [varargin{:}] = convertStringsToChars(varargin{:});
end
class_sample = false;
class_vector = false;

% Check for class-sample inputs
if ~isempty(varargin) && ~ischar(varargin{1})
    class_labels = varargin{1};
    if isempty(class_labels)
        if iscell(data)
            processed_data = process2dcelldata(data);
        else
            processed_data = processdoubledata(data);
        end
        class_labels_uq = arrayfun(@num2str, 1:size(data, 2), 'UniformOutput', false);
    else
        if iscell(data)
            assert(iscolumn(data), 'PRED:UnsupportedCellMatrixSize', 'Required data to be a cell column vector')
        else
            assert(ismatrix(data), 'PRED:UnsupportedDoubleMatrixSize', 'Required data to be a 2-D double matrix')
            data = num2cell(data, 2);
        end
        assert(size(data, 1) >= 4, 'PRED:LessThan4Rows', 'Required data to be a cell vector or double matrix with at least 4 rows')
        assert(iscolumn(class_labels), 'PRED:NonVectorClassLabels', 'Required class_labels as a column vector')
        assert(iscellstr(class_labels) || isnumeric(class_labels), 'PRED:UnsupportedClassLabelFormat', 'Required class_labels as cell of strings or double vector')
        assert(length(class_labels) == size(data, 1), 'PRED:UnequalDataClassLabelLength', 'Required equal number of rows in data and class_labels')
        [class_labels_uq, ~, class_labels_id] = unique(class_labels);
        n_class = length(class_labels_uq);
        assert(n_class >= 2, 'PRED:LessThan2Classes', 'Required at least 2 classes')
        n_samples = accumarray(class_labels_id, 1);
        assert(all(n_samples >= 2), 'PRED:LessThan2SamplesInClass', 'Required at least two samples for each class')
        processed_data = cell(max(n_samples), n_class);
        if iscellstr(class_labels_uq)
            for i_class = 1:n_class
                temp_data = data(strcmp(class_labels_uq{i_class}, class_labels));
                processed_data(1:length(temp_data), i_class) = temp_data;
            end
        else
            for i_class = 1:n_class
                temp_data = data(class_labels_uq(i_class) == class_labels);
                processed_data(1:length(temp_data), i_class) = temp_data;
            end
        end
    end
    class_sample = true;
else
    if iscell(data)
        processed_data = process2dcelldata(data);
    else
        processed_data = processdoubledata(data);
    end
    class_vector = true;
end

% parameter handling
p = inputParser();
addParameter(p, 'distance', 'squaredeuclidean', @(x) any(validatestring(x, {'euclidean', 'squaredeuclidean', 'seuclidean', 'cityblock', 'chebychev'})));

if class_sample
    addParameter(p, 'type', 'exhaustive', @(x) any(validatestring(x, {'fast', 'exhaustive'})));
    parse(p, varargin{2:end});
    type = p.Results.type;
    distance = p.Results.distance;
    if strcmp(type, 'exhaustive')
        [s, temp_labels] = exhaustivepred(processed_data, distance);
    else
        [s, temp_labels] = fastpred(processed_data, false, distance);
    end
    labels = cellfun(@(x) class_labels_uq(x), temp_labels, 'UniformOutput', false);
end

if class_vector
    parse(p, varargin{1:end});
    distance = p.Results.distance;
    [s, labels] = fastpred(processed_data, true, distance);
end
end

function [s, labels] = fastpred(data, type_vector, distance)

[n_row, n_col] = size(data);
% find all row pairs
pair_row = nchoosek(1:n_row, 2);
n_pair_row = size(pair_row, 1);
% find all column pairs
pair_col = nchoosek(1:n_col, 2);
n_pair_col = size(pair_col, 1);

s = nan(n_pair_row, n_pair_col);
for i_pair_row = 1:n_pair_row
    for i_pair_col = 1:n_pair_col
        temp_data = [data(pair_row(i_pair_row, 1), pair_col(i_pair_col, :)); data(pair_row(i_pair_row, 2), pair_col(i_pair_col, :))];
        if ~any(cellfun(@isempty, temp_data(:)))
            s(i_pair_row, i_pair_col) = computepred(temp_data, distance);
        end % check for empty cells
    end
end
if type_vector
    s = mean(s, 2, 'omitnan');
    labels = num2cell(pair_row, 2);
else
    s = mean(s, 1, 'omitnan');
    labels = num2cell(pair_col, 2).';
end
end

function [s, labels] = exhaustivepred(data, distance)

[n_row, n_col] = size(data);
% find all row pairs
pair_row = nchoosek(1:n_row, 2);
n_pair_row = size(pair_row, 1);

% find all column pairs
pair_col = nchoosek(1:n_col, 2);
n_pair_col = size(pair_col, 1);

s = nan(1, n_pair_col);
for i_pair_col = 1:n_pair_col
    temp_measure = nan(n_pair_row, n_pair_row, 2);
    for i_pair_row_1 = 1:n_pair_row
        for i_pair_row_2 = 1:n_pair_row
            temp_data = [data(pair_row(i_pair_row_1, :), pair_col(i_pair_col, 1)), data(pair_row(i_pair_row_2, :), pair_col(i_pair_col, 2))];
            if ~any(cellfun(@isempty, temp_data(:)))
                temp_measure(i_pair_row_1, i_pair_row_2, 1) = computepred(temp_data, distance);
                % calculate PRED with one column flipped
                temp_data = [temp_data(:, 1), flipud(temp_data(:, 2))];
                temp_measure(i_pair_row_1, i_pair_row_2, 2) = computepred(temp_data, distance);
            end % check for empty cells
        end
    end
    s(1, i_pair_col) = mean(temp_measure(:), 'omitnan');
end
labels = num2cell(pair_col, 2).';
end

function s = computepred(data, distance)
row_1 = data(1, :);
row_2 = data(2, :);
pred_fn = @(d1, d2) (d2 - d1) ./ (d2 + d1);
d_1 = arrayfun(@(x) pdist([row_2{x}; row_1{x}], distance), 1:2);
d_2 = arrayfun(@(x) pdist([row_2{end - x + 1}; row_1{x}], distance), 1:2);
s = pred_fn(mean(d_1), mean(d_2));
end

function processed_data = process2dcelldata(data)
data = removeallemptydims(data);
assert(ismatrix(data), 'PRED:UnsupportedCellMatrixSize', 'Required data to be 2-D cell matrix')
assert(size(data, 1) >= 2 && size(data, 2) >= 2, 'PRED:CellMatrixSizeLessThan2x2', 'Required data to be a cell of size at least 2x2')
assert(all(reshape(cellfun(@(x) isrow(x) || isempty(x), data), 1, [])), 'PRED:NonRowCellElements', 'Required each element of cell to be a scalar or a row vector')
sample_len_uq = setdiff(unique(cellfun(@length, data)), 0);
assert(length(sample_len_uq) == 1, 'PRED:UnequalLengthCellElements', 'Required each element in cell to be of same length')
processed_data = data;
end

function processed_data = processdoubledata(data)
data = removeallnandims(data);
assert(size(data, 1) >= 2 && size(data, 2) >= 2, 'PRED:DoubleMatrixSizeLessThan2x2', 'Required data to be a matrix of size at least 2x2')
assert(ndims(data) <= 3, 'PRED:UnsupportedDoubleMatrixSize', 'Required data to be 2-D or 3-D double matrix')
if ismatrix(data)
    processed_data = num2cell(data);
else
    processed_data = cellfun(@(x) reshape(x, 1, []), num2cell(data, 3), 'UniformOutput', false);
end
end

function data = removeallemptydims(data)
n_dims = ndims(data);
    function all_empty_dims = findalldim(data, dims)
        if isempty(dims)
            all_empty_dims = data;
        else
            all_empty_dims = findalldim(all(data, dims(1)), dims(2:end));
        end
    end
for i_dim = 1:n_dims
    subs_data = repelem({':'}, 1, n_dims);
    subs_data{i_dim} = ~findalldim(cellfun(@isempty, data), setdiff(1:n_dims, i_dim));
    data = subsref(data, substruct('()', subs_data));
end
end

function data = removeallnandims(data)
n_dims = ndims(data);
    function all_nan_dims = findalldim(data, dims)
        if isempty(dims)
            all_nan_dims = data;
        else
            all_nan_dims = findalldim(all(data, dims(1)), dims(2:end));
        end
    end
for i_dim = 1:n_dims
    subs_data = repelem({':'}, 1, n_dims);
    subs_data{i_dim} = ~findalldim(isnan(data), setdiff(1:n_dims, i_dim));
    data = subsref(data, substruct('()', subs_data));
end
end
