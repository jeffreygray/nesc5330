%   jeff gray
%   jhg7nm
%   02.01.2016
%   nesc5330
%   lab1
%   file: 'postexcite.m'

%   description: calculates dendritic excitation

function [post_excitation] = postexcite(input_vector, weight)
    %   check for errors
%    checkvecs(input_vector, weight_vector, 'postexcite');
%    checkfor_col_vector(input_vector, length(weight_vector), 'postexcite');

    %   calculate excitation
    post_excitation = input_vector * weight;
%    post_excitation = dot(input_vector, weight_vector);