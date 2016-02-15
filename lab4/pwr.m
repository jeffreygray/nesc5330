function [output] = pwr(matrix, vector)
    for timestep = 1 : 10
        v2 = matrix * vector;
        v3 = v2 / norm(v2);
    end

    output = v3;
