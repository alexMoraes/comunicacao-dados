function x = zf(pinvH, y)
    % zero forcing
    x = slice(pinvH * y);
end