function y = sortMatrix(x, o)
    % Ordena as colunas de `x` baseada na ordem `o`
    [l, c] = size(x);
    y = zeros(l, c);
    for i = 1:c
        y(:, i) = x(:, o(i));
    end
end