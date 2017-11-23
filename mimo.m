close all;
clear;
%-------------------------------------------------------------------------%
%%% PARÂMETROS %%%

generateNoise = 1;
transmissionAntennas = 2;   % Número de antenas de transmissão
receptionAntennas = 2;      % Número de antenas de recepção
nSimulatedBits = 10000;     % Número de bits a serem simulados

%-------------------------------------------------------------------------%
Eb_N0_dB = 0:1:10;                  % Faixa de Eb/N0 a ser simulada (em dB)
Eb_N0_lin = 10 .^ (Eb_N0_dB/10);    % Eb/N0 linearizado
Eb = 1;                             % Energia por símbolo 
NP = Eb ./ (Eb_N0_lin);             % Potência do ruído
NA = sqrt(NP);                      % Amplitude do ruído

% Matriz para BER de cada Eb/N0
zfBER = zeros(1, length(Eb_N0_lin));
ncBER = zeros(1, length(Eb_N0_lin));
sncBER = zeros(1, length(Eb_N0_lin));

%-------------------------------------------------------------------------%
%%% SIMULAÇÃO %%%

% Matriz de bits enviados por antena (linha == antena)
sentBits = randi([0, 1], transmissionAntennas, nSimulatedBits);
sentSignal = complex(sentBits * 2 - 1, 0);

% Matriz de transferência do canal
H = generateH(receptionAntennas, transmissionAntennas);

for i = 1 : length(Eb_N0_lin)
    % Ruído (AWGN)
    noise = NA(i) * complex(randn(1, nSimulatedBits), ...
        randn(1, nSimulatedBits)) * sqrt(0.5) ...
        * generateNoise;
    
    % Sinal recebido pelas antenas
    receivedSignal = H * sentSignal + noise;
    
    for bit = 1 : nSimulatedBits
        % Regeneração periódica da matriz H
        if mod(bit, 1000) == 0
            H = generateH(receptionAntennas, transmissionAntennas);
        end
        
        % Recepção do sinal - Zero forcing
        zfSignal = zeroForcing(receivedSignal(:, bit), H);
        zfBits = bpskToBits(zfSignal);
        zfBER(i) = zfBER(i) + sum(sentBits(:, bit) ~= zfBits);
        
        % Recepção do sinal - Nulling and cancelling
        ncSignal = nullingAndCancelling(receivedSignal(:, bit), H);
        ncBits = bpskToBits(ncSignal);
        ncBER(i) = ncBER(i) + sum(sentBits(:, bit) ~= ncBits);
        
        % Recepção do sinal - Sorted nulling and cancelling
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




