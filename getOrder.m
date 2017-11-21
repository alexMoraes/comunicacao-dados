function y = getOrder(x)
    [~, c] = size(x);
    a = zeros(c, 2);
    for i = 1:c
        a(i, 1) = norm(x(:, i));
        a(i, 2) = i;
    end
    s = sortrows(a, -1);
    y = s(:, 2);
end