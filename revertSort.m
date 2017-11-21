function y = revertSort(x, o)
    l = length(x);
    y = complex(zeros(l, 1), 0);
    for i = 1:l
        y(o(i)) = x(i);
    end
end