function [H, pinvH, Q, R, sortH, sortQ, sortR, I] = genH(NR, NT)
    % gera uma matriz H e todas matrizes derivadas para a simulação
    % de um sistema mimo
    H = sqrt(0.5) * complex(randn([NR NT]), randn([NR NT]));
    %H = eye(NR, NT);
    pinvH = pinv(H);
    [Q, R] = qr(H);
    
    n = zeros([1 NT]);
    for i = 1 : NT
        n(i) = norm(H(:, i));
    end
    
    [~, I] = sort(n);
    
    sortH = zeros([NR NT]);
    for i = 1 : NT
        sortH(:, i) = H(:, I(i));
    end
    [sortQ, sortR] = qr(sortH);
end