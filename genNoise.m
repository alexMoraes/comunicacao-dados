function n = genNoise(NR, A)
    % gera��o de um vetor de ru�do aditivo gaussiano branco (AWGN)
    n = A * sqrt(0.5) * complex(randn([NR 1]), randn([NR 1]));
end