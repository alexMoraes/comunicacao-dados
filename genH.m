function [H, pinvH, Q, R, sortH, sortQ, sortR, I] = genH(NR, NT)
    H = complex(randn([NR NT]), randn([NR NT]));
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