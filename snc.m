function x = snc(sortQ, sortR, I, NT, y)
    % sorted nulling and cancelling
    xs = nc(sortQ, sortR, NT, y);
    
    x = zeros([NT 1]);
    for i = 1 : NT
        x(I(i)) = xs(i);
    end
end