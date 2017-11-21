close all;
clear;

generateNoise = 1;

transmissionAntennas = 10;   % N�mero de antenas de transmiss�o
receptionAntennas = 10;      % N�mero de antenas de recep��o

% Pontos da constela��o BPSK
validPoints = complex([-1 1], 0);

% Matriz de transfer�ncia do canal
H_real = rand(receptionAntennas, transmissionAntennas);
H_img = rand(receptionAntennas, transmissionAntennas);
H = complex(H_real, H_img);

% Ru�do
if generateNoise
    noise_real = rand(receptionAntennas, 1);
    noise_img = rand(receptionAntennas, 1);
    noise = complex(noise_real, noise_img);
else
    noise = complex(zeros(receptionAntennas, 1), 0);
end

% Gera��o do sinal
sentBits = randi([0, 1], transmissionAntennas, 1);
sentSignal = complex(sentBits * 2 - 1, 0);

% Canal
receivedSignal = H*sentSignal + noise;

% Recep��o do sinal - Zero forcing
zfSignal = zeroForcing(receivedSignal, H);
zfBits = bpskToBits(zfSignal);

% Recep��o do sinal - Nulling and cancelling
ncSignal = nullingAndCancelling(receivedSignal, H);
ncBits = bpskToBits(ncSignal);

% Recep��o do sinal - Sorted nulling and cancelling
sncSignal = sortedNullingAndCancelling(receivedSignal, H);
sncBits = bpskToBits(sncSignal);










