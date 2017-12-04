function x = nc(Q, R, NT, y)
    % nulling and cancelling
    z = Q' * y; % = R*x + n
    
    x = zeros(NT, 1);
    for i = NT : -1 : 1
        x(i) = slice(z(i)/R(i,i));
        z = z - x(i)*R(:,i);
    end
end