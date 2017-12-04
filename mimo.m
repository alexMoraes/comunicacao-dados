clear;
close all;

%-------------------------------------------------------------------------%
%%% PAR�METROS %%%

NT = 4;                          	% N�mero de antenas de transmiss�o
NR = 4;                         	% N�mero de antenas de recep��o
nBits = 500000;                   	% N�mero de bits por antena
freqRegenH = 2;                     % a cada quantos bits transmitidos H � regenerada

%-------------------------------------------------------------------------%

Eb_N0_dB  = 0:1:10;                 % Faixa de Eb/N0 a ser simulada (em dB)
Eb_N0_lin = 10 .^ (Eb_N0_dB/10); 	% Eb/N0 linearizado
Eb        = 1;                      % Energia por s�mbolo 
NP        = Eb ./ (Eb_N0_lin);      % Pot�ncia do ru�do
NA        = sqrt(NP);               % Amplitude do ru�do

% Vetor para BER de cada Eb/N0
ber_zf  = zeros(1, length(Eb_N0_lin));
ber_nc  = zeros(1, length(Eb_N0_lin));
ber_snc = zeros(1, length(Eb_N0_lin));

%-------------------------------------------------------------------------%

tic();

for j = 1 : length(Eb_N0_lin)
    % bits e s�mbolos a serem simulados por cada antena para este Eb/N0
    sentBits    = randi([0 1], [nBits * NT 1]);
    sentSymbols = complex(sentBits * 2 - 1, 0);

    err_zf  = 0;
    err_nc  = 0;
    err_snc = 0;
    % envio de 1 bit por antena
    for i = 1 : nBits
        b = sentBits((i - 1) * NT + 1 : i * NT);    % bits da rodada
        x = sentSymbols((i - 1) * NT + 1 : i * NT); % s�mbolos da rodada

        if mod(i, freqRegenH) == 1
            [H, pinvH, Q, R, sortH, sortQ, sortR, I] = genH(NR, NT);
        end

        n = genNoise(NR, NA(j));
        y = H * x + n;

        % algoritmos nos receptores
        x_zf  = zf(pinvH, y);
        x_nc  = nc(Q, R, NT, y);
        x_snc = snc(sortQ, sortR, I, NT, y);

        % bits recebidos
        b_zf  = (real(x_zf)  > 0) * 1;
        b_nc  = (real(x_nc)  > 0) * 1;
        b_snc = (real(x_snc) > 0) * 1;

        % acumulador de erros
        err_zf  = err_zf  + sum(b_zf  ~= b);
        err_nc  = err_nc  + sum(b_nc  ~= b);
        err_snc = err_snc + sum(b_snc ~= b);
    end

    tBits      = nBits * NT; % total de bits transmitidos
    ber_zf(j)  = err_zf  / tBits;
    ber_nc(j)  = err_nc  / tBits;
    ber_snc(j) = err_snc / tBits;

end

toc();

semilogy(Eb_N0_dB, ber_zf, Eb_N0_dB, ber_nc, Eb_N0_dB, ber_snc, 'LineWidth', 2);
grid on;
title(sprintf("Taxa de erros para sistema MIMO %dx%d com BPSK", NT, NR));
legend('ZF', 'NC', 'SNC');
ylabel('BER');
xlabel('Eb/N0 (dB)');
