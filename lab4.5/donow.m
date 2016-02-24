%   jeff gray
%   jhg7nm
%   lab4.5
%   02.23.2016


function [optimalThreshold] = donow()
    %   where matricies exist in form 2xN
    %   [ x1 x2 ... ]
    %   [ y1 y2 ... ]
    
    %   standard entrance routine for new environment
    rng(9711963);
    clear
    
    %   creating points
    a = rand(5, 1) * pi/12 + pi/6 - pi/24;
    b = rand(5, 1) * pi/12 + pi/4 - pi/24;
    c = rand(5, 1) * pi/12 + pi/3 - pi/24;

    %   grouping points into clusters
    matA = [cos(a) sin(a)]';
    matB = [cos(b), sin(b)]';
    matC = [cos(c), sin(c)]';
    
    thresh = 0;
    wrong = 0;
    itr = 0;
    
    
    for z = 1 : 100    
        %    
        a_correct = 0;
        b_correct = 0;
        c_correct = 0;

        
        %   construct classification outputs for each matrix input
        for i = 1 : size(matA,2)
            a_class(1, i) = classifyVec(matA(:,i), thresh);
        end
        for j = 1 : length(a_class);
            if (a_class(1, j) == 1);
                a_correct = a_correct + 1;

            else
                wrong = wrong + 1;
        end
        end

        for i = 1 : size(matB,2);
            b_class(1, i) = classifyVec(matB(:,i), thresh);
        end
        for j = 1 : length(b_class);
            if (b_class(1, j) == 2);
                b_correct = b_correct + 1;

            else
                wrong = wrong + 1;
        end
        end

        for i = 1 : size(matC,2);
            c_class(1, i) = classifyVec(matC(:,i), thresh);
        end
        for j = 1 : length(c_class);
            if (c_class(1, j) == 3);
                c_correct = c_correct + 1;

            else
                wrong = wrong + 1;
        end
        end

        right = a_correct + b_correct + c_correct;
        %
        numRight(z,1) = right;
        curThresh(z,1) = thresh;
        thresh = thresh + pi/2 / 1000;
        if (right == 15);
            itr = thresh;
        end
end
    optimalThreshold = itr;
    plot(curThresh, numRight*100/15)
    
    
    
   