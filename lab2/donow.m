function donow(weight, set1, set2)

    thresh = [pi/24 : pi/12 : pi/2]

    ip1 = set1 * weight;
    ip2 = set2 * weight;
    for i = 1 : length(thresh)
        disp(i)
        a = ip1 > cos(thresh(i));
        b = ip2 > cos(thresh(i));
        out = [a b]
        disp('----------------------------')
    end
    