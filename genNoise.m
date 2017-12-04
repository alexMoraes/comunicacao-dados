function n = genNoise(NR, A)
    % geração de um vetor de ruído aditivo gaussiano branco (AWGN)
    n = A * sqrt(0.5) * complex(randn([NR 1]), randn([NR 1]));
end