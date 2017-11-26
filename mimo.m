close all;
clear;
%-------------------------------------------------------------------------%
%%% PAR�METROS %%%

generateNoise = 1;
transmissionAntennas = 2;   % N�mero de antenas de transmiss�o
receptionAntennas = 2;      % N�mero de antenas de recep��o
nSimulatedBits = 10000;     % N�mero de bits a serem simulados

%-------------------------------------------------------------------------%
Eb_N0_dB = 0:1:10;                  % Faixa de Eb/N0 a ser simulada (em dB)
Eb_N0_lin = 10 .^ (Eb_N0_dB/10);    % Eb/N0 linearizado
Eb = 1;                             % Energia por s�mbolo 
NP = Eb ./ (Eb_N0_lin);             % Pot�ncia do ru�do
NA = sqrt(NP);                      % Amplitude do ru�do

% Matriz para BER de cada Eb/N0
zfBER = zeros(1, length(Eb_N0_lin));
ncBER = zeros(1, length(Eb_N0_lin));
sncBER = zeros(1, length(Eb_N0_lin));

%-------------------------------------------------------------------------%
%%% SIMULA��O %%%

% Matriz de bits enviados por antena (linha == antena)
sentBits = randi([0, 1], transmissionAntennas, nSimulatedBits);
sentSignal = complex(sentBits * 2 - 1, 0);

% Matriz de transfer�ncia do canal
H = generateH(receptionAntennas, transmissionAntennas);

for i = 1 : 1%length(Eb_N0_lin)
    % Ru�do (AWGN)
    noise = NA(i) * complex(randn(receptionAntennas, nSimulatedBits), ...
        randn(receptionAntennas, nSimulatedBits)) * sqrt(0.5) ...
        * generateNoise;
    
    % Sinal recebido pelas antenas
    receivedSignal = H * sentSignal + noise;
    
    for bit = 1 : nSimulatedBits
        % Regenera��o peri�dica da matriz H
        if mod(bit, 1000) == 0
            H = generateH(receptionAntennas, transmissionAntennas);
        end
        
        % Recep��o do sinal - Zero forcing
        zfSignal = zeroForcing(receivedSignal(:, bit), H);
        zfBits = bpskToBits(zfSignal);
        zfBER(i) = zfBER(i) + sum(sentBits(:, bit) ~= zfBits);
        
        % Recep��o do sinal - Nulling and cancelling
        ncSignal = nullingAndCancelling(receivedSignal(:, bit), H);
        ncBits = bpskToBits(ncSignal);
        ncBER(i) = ncBER(i) + sum(sentBits(:, bit) ~= ncBits);
        
        % Recep��o do sinal - Sorted nulling and cancelling
        sncSignal = sortedNullingAndCancelling(receivedSignal(:, bit), H);
        sncBits = bpskToBits(sncSignal);
        sncBER(i) = sncBER(i) + sum(sentBits(:, bit) ~= sncBits);
    end
    
    zfBER(i) = zfBER(i) / (nSimulatedBits*transmissionAntennas);
    ncBER(i) = ncBER(i) / (nSimulatedBits*transmissionAntennas);
    sncBER(i) = sncBER(i) / (nSimulatedBits*transmissionAntennas);
end

semilogy(Eb_N0_dB, zfBER, ...
    Eb_N0_dB, ncBER, ...
    Eb_N0_dB, sncBER, 'LineWidth', 2);
grid on;
title('Taxa de erros para sistema MIMO com BPSK');
legend('ZF', 'NC', 'SNC');
ylabel('BER');
xlabel('Eb/N0 (dB)');




