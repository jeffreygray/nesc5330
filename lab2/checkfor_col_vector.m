%   02.01.2016
%   nesc5330
%   lab1
%   file: 'checkfor_col_vector.m'

%   description: determines whether input vector A is of specified length

%   returns TRUE when input vector A is column vec of length desired_dim
function [truth] = checkfor_col_vector(A, desired_dim, func_name)
    errorfound = ['Function checkfor_col_vector detected an error in ', ...
        func_name, '.m'];
    
    truth = 1;
    [num_rows, num_col] = size(A);
    
    if num_col ~= 1
        beep
        truth = 0;
        disp(errorfound)
        disp('not a column vector')
    elseif num_rows ~= desired_dim
        beep
        truth = 0;
        disp(errorfound)
        disp('column vector is not of desired length')
    end
end