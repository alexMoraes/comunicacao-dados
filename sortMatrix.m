function y = sortMatrix(x, o)
    [l, c] = size(x);
    y = zeros(l, c);
    for i = 1:c
        y(:, i) = x(:, o(i));
    end
end