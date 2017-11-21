function y = zeroForcing(r, h)
    i = pinv(h);
    x = i*r;
    y = approximateToBpsk(x);
end