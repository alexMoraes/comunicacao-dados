function y = approximateToBpsk(x)
    real_y = (real(x) > 0)*2 - 1;
    y = complex(real_y, 0);
end