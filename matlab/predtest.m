function predtest()
%PREDTEST Runs unit tests to check validity of the PRED function

%*************************************************************************%
% Author: Aarush Mohit Mittal
% Contact: aarush (dot) mohit (at) gmail (dot) com
% Version: 1.0
%*************************************************************************%

fprintf('<strong>Tests with empty data:</strong> PASS - function rejected the empty datasets and returned the correct error code | FAIL - function ran faultily or returned wrong error code\n')

formattest('Empty data', 'PRED:EmptyData', [])
formattest('Cell matrix with all empty elements', 'PRED:EmptyCellElements', {[], []; [], []})
formattest('Double matrix with all nan elements', 'PRED:AllNANValues', nan(2))

fprintf('\n<strong>Tests with wrongly formatted or unsupported data:</strong> PASS - function rejected the faulty datasets and returned the correct error code | FAIL - function ran faultily or returned wrong error code\n')

formattest('Class-Vector: 3-D Cell Matrix', 'PRED:UnsupportedCellMatrixSize', num2cell(rand(3, 3, 3)))
formattest('Class-Vector: Cell matrix with size less than 2x2', 'PRED:CellMatrixSizeLessThan2x2', num2cell(rand(2, 1)))
formattest('Class-Vector: Cell matrix with one entry as a column vector', 'PRED:NonRowCellElements', {[1, 1], [1, 2]; [1; 2], [1, 2]})
formattest('Class-Vector: Cell matrix with elements (non-empty) of unequal length', 'PRED:UnequalLengthCellElements', {[1, 1], [1, 2]; [1], [1, 2]})
formattest('Class-Vector: Double matrix with size less than 2x2', 'PRED:DoubleMatrixSizeLessThan2x2', rand(2, 1))
formattest('Class-Vector: 4-D Double matrix', 'PRED:UnsupportedDoubleMatrixSize', rand(3, 3, 3, 3))

formattest('Class-Sample: (Empty Class Labels) 3-D Cell Matrix', 'PRED:UnsupportedCellMatrixSize', num2cell(rand(3, 3, 3)), {})
formattest('Class-Sample: (Empty Class Labels) Cell matrix with size less than 2x2', 'PRED:CellMatrixSizeLessThan2x2', num2cell(rand(2, 1)), {})
formattest('Class-Sample: (Empty Class Labels) Cell matrix with one entry as a column vector', 'PRED:NonRowCellElements', {[1, 1], [1, 2]; [1; 2], [1, 2]}, {})
formattest('Class-Sample: (Empty Class Labels) Cell matrix with elements (non-empty) of unequal length', 'PRED:UnequalLengthCellElements', {[1, 1], [1, 2]; [1], [1, 2]}, {})
formattest('Class-Sample: (Empty Class Labels) Double matrix with size less than 2x2', 'PRED:DoubleMatrixSizeLessThan2x2', rand(2, 1), {})
formattest('Class-Sample: (Empty Class Labels) 4-D Double matrix', 'PRED:UnsupportedDoubleMatrixSize', rand(3, 3, 3, 3), {})

formattest('Class-Sample: (With Class Labels) 1-D Cell row vector', 'PRED:UnsupportedCellMatrixSize', num2cell(rand(1, 2)), [1, 2].')
formattest('Class-Sample: (With Class Labels) 2-D Cell matrix', 'PRED:UnsupportedCellMatrixSize', num2cell(rand(2, 2)), [1, 2, 1, 2].')
formattest('Class-Sample: (With Class Labels) 3-D Double matrix', 'PRED:UnsupportedDoubleMatrixSize', rand(3, 3, 3), [1, 1, 1, 2, 2, 2].')
formattest('Class-Sample: (With Class Labels) 1-D Cell vector with 3 rows', 'PRED:LessThan4Rows', num2cell(rand(3, 1)), [1, 2, 1].')
formattest('Class-Sample: (With Class Labels) 2-D Double matrix with 3 rows', 'PRED:LessThan4Rows', rand(3, 2), [1, 1, 2].')
formattest('Class-Sample: (With Class Labels) Class labels specified as rows', 'PRED:NonVectorClassLabels', rand(4, 2), [1, 1, 2, 2])
formattest('Class-Sample: (With Class Labels) Class labels specified as matrix', 'PRED:NonVectorClassLabels', rand(4, 2), [1, 1; 2, 2])
formattest('Class-Sample: (With Class Labels) Class labels specified as cell of numbers', 'PRED:UnsupportedClassLabelFormat', rand(4, 2), {1, 1, 1, 2}.')
formattest('Class-Sample: (With Class Labels) Mismatch in number of class labels and data rows', 'PRED:UnequalDataClassLabelLength', rand(4, 2), [1, 1, 2].')
formattest('Class-Sample: (With Class Labels) Less than 2 classes specified', 'PRED:LessThan2Classes', rand(4, 2), [1, 1, 1, 1].')
formattest('Class-Sample: (With Class Labels) Less than 2 samples in a class', 'PRED:LessThan2SamplesInClass', rand(6, 2), [1, 1, 1, 2, 2, 3].')

fprintf('\n<strong>Test PRED calculation using known cases:</strong> PASS - function outputs expected value of pred | FAIL - function outputs wrong value\n')

valuetest('Class-Vector: All values same', nan, [1 1; 1 1])
valuetest('Class-Vector: Identical vectors', 1, [1 2; 1 2])
valuetest('Class-Vector: Identical classes', 0, [1 1; 2 2])
valuetest('Class-Vector: Vectors with patterns reversed across classes', -1, [1 2; 2 1])
valuetest('Class-Vector: Specific 2x2 example as double matrix', 1/3, [1 2; 2 3])
valuetest('Class-Vector: Specific 2x2 example as cell matrix', 1/3, num2cell([1 2; 2 3]))
valuetest('Class-Vector: Specific 3x3 example as double matrix', [4/9, 5/27, 4/9].', [1 2 3; 2 3 4; 3 4 5])
valuetest('Class-Vector: Specific 3D double matrix example', 1/3, cat(3, [1 2; 2 3], [1 2; 2 3]))
valuetest('Class-Vector: Specific 2D cell example with vector values', 1/3, {[1 1], [2 2]; [2 2], [3 3]})
valuetest('Class-Vector: 2x3 cell matrix with a class with all empty values', 1, {1, 2, []; 1, 2, []})
valuetest('Class-Vector: 2x2 cell matrix with an empty value', nan, {[1, 1], [1, 2]; [], [1, 2]})
valuetest('Class-Vector: 2x2 double matrix with a nan value', nan, [1 2; nan 2])
valuetest('Class-Vector: 2x3 double matrix with a class with all nan values', 1, [1 2 nan; 1 2 nan])

valuetest('Class-Sample: All values same', nan, {1, 1, 1, 1}.', {'1', '1', '2', '2'}.')
valuetest('Class-Sample: Identical samples', 1, {1, 1, 2, 2}.', {'1', '1', '2', '2'}.')
valuetest('Class-Sample: Non-distinguishable classes', 0, {1, 1, 1, 2}.', {'1', '1', '2', '2'}.')
valuetest('Class-Sample: Specific case with 2 samples for 2 classes as 1-D cell vector', 1/6, {1, 2, 2, 3}.', {'1', '1', '2', '2'}.')
valuetest('Class-Sample: Specific case with 2 samples for 2 classes as 1-D double vector', 1/6, [1, 2, 2, 3].', {'1', '1', '2', '2'}.')
valuetest('Class-Sample: (Empty Class Labels) Specific case with 2 samples for 2 classes as 2-D cell matrix', 1/6, {1, 2; 2, 3}, {})
valuetest('Class-Sample: (Empty Class Labels) Specific case with 2 samples for 2 classes as 2-D double matrix', 1/6, [1, 2; 2, 3], [])
valuetest('Class-Sample: Specific case with 2 samples for 2 classes as 1-D cell vector of vectors', 1/6, {[1, 1], [2, 1], [2, 1], [3, 1]}.', {'1', '1', '2', '2'}.')
valuetest('Class-Sample: Specific case with 2 samples for 2 classes as 2-D double matrix', 1/6, [1, 1; 2, 1; 2, 1; 3, 1], {'1', '1', '2', '2'}.')
valuetest('Class-Sample: (Empty Class Labels) Specific case with 2 samples for 2 classes as 2-D cell matrix of vectors', 1/6, {[1, 1], [2, 1]; [2, 1], [3, 1]}, {})
valuetest('Class-Sample: (Empty Class Labels) Specific case with 2 samples for 2 classes as 3-D double matrix', 1/6, cat(3, [1 2; 2 3], [1 1; 1 1]), [])
valuetest('Class-Sample: Specific case with 2 samples for 2 classes as 1-D cell vector and numerical labels', 1/6, {1, 2, 2, 3}.', [1 1 2 2].')
valuetest('Class-Sample: Specific case with 3 samples for 3 classes', [-10/567 -10/567 -5/18], {1, 2, 3, 2, 3, 4, 2, 3, 4}.', [1 1 1 2 2 2 3 3 3].');
valuetest('Class-Sample: (Empty Class Labels) 2x2 Cell matrix with an empty element', nan, {[1, 1], [1, 2]; [], [1, 2]}, {})
end

function formattest(test_id, error_id, varargin)
try
    fprintf('Format Test: %s.....', test_id)
    p = pred(varargin{:});
    fprintf('<strong>FAIL</strong> (pred = %.4f)\n', p);
catch ME
    if strcmp(ME.identifier, error_id)
        fprintf('PASS\n')
    else
        fprintf('<strong>FAIL</strong> %s\n', ME.identifier)
    end
end
end

function valuetest(test_id, value, varargin)
fprintf('Value Test: %s.....', test_id)
p = pred(varargin{:});
if isequaln(round(p, 4), round(value, 4))
    fprintf('PASS\n')
else
    fprintf('<strong>FAIL</strong> (output = [%s], expected = [%s])\n', num2str(reshape(p, 1, []), '%.4f, '), num2str(reshape(value, 1, []), '%.4f, '));
end
end
