function n = genNoise(NR, A)
    n = A * sqrt(0.5) * complex(randn([NR 1]), randn([NR 1]));
end