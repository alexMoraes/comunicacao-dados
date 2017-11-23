function H = generateH(receptionAntennas, transmissionAntennas)
    H_real = randn(receptionAntennas, transmissionAntennas);
    H_img = randn(receptionAntennas, transmissionAntennas);
    H = complex(H_real, H_img);
end

