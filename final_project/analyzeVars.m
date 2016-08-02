function [rsq] = analyzeVars(x, y)

    a = polyfit(x, y, 1);
    yfit = polyval(a, x);
    yresid = y - yfit;
    b = sum(yresid.^2);
    c = (length(y)-1) * var(y);
    rsq = 1 - b/c;