function y = nullingAndCancelling(x, h)
    [q, r] = qr(h);
    z = q'*x;
    l = length(z);
    y = complex(zeros(l, 1), 0);
    for i = l:-1:1
        y(i) = z(i)/r(i,i);
        z = z - y(i)*r(:,i);
    end
    y = approximateToBpsk(y);
end