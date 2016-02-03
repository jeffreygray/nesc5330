%   02.01.2016
%   nesc5330
%   lab1
%   file: 'checkvecs.m'

%   description: determines whether two vectors are balanced

function checkvecs(vec1,vec2,func_name)
%   error checking
    if length(vec1) ~= length(vec2)
        a = ['ERROR: in ', func_name, '.m'];
        disp(a)
        disp('vector dimensions don''t match!')
    end