clear all;
close all;

NT = 2;
NR = 2;
nBits = 100000;
generateNoise = 1; % presença de ruído
freqRegenH = 10; % a cada quantos bits transmitidos H é regenerada

Eb_N0_dB = 0:1:10; % faixa de Eb/N0 a ser simulada (em dB)
Eb_N0_lin = 10 .^ (Eb_N0_dB/10); % Eb/N0 linearizado
Eb = 1; % energia por símbolo dada pela razão do código
nP = Eb ./ (Eb_N0_lin); % potência do ruído
nA = sqrt(nP); % amplitude é a raiz quadrada da potência

err_zf = zeros(1, length(Eb_N0_dB));
err_nc = zeros(1, length(Eb_N0_dB));
err_snc = zeros(1, length(Eb_N0_dB));
% simulação de todos Eb/N0
for i = 1:length(Eb_N0_lin)
    H = complex(rand([NR NT]), rand([NR NT]));
    err_zf(i) = 0;
    err_nc(i) = 0;
    err_snc(i) = 0;
    
    % simulação de n bits para o nível Eb/N0
    for j = 1 : nBits
        % y = Hx + n
        % bits transmitidos
        x = complex(2 * randi(2, NT, 1) - 3, 0);
        
        % ruído
        n = nA(i) * complex(randn(NR, 1), randn(NR, 1)) ...
            * sqrt(0.5) * generateNoise;
        
        % matriz H
        if mod(j, freqRegenH) == 0
            %H = complex(rand([NR NT]), rand([NR NT]));
            H = generateH(NR, NT);
        end
    
        % bits recebidos pelos receptores
        y = H * x + n;
        
        % algoritmos nos receptores
        x_zf = zf(H, y);
        x_nc = nc(H, y);
        x_snc = snc(H,y);
        
        % erros encontrados
        err_zf(i) = err_zf(i) + sum(x~=x_zf);
        err_nc(i) = err_nc(i) + sum(x~=x_nc);
        err_snc(i) = err_snc(i) + sum(x~=x_snc);
        %disp([sum(x~=x) err_zf(i) err_nc(i) err_snc(i)]);
    end
    
    err_zf(i) = err_zf(i) / (nBits*NT);
    err_nc(i) = err_nc(i) / (nBits*NT);
    err_snc(i) = err_snc(i) / (nBits*NT);
end

% Eb/N0 | errZF | errNC | errSNC
%disp([Eb_N0_dB.' repmat([nBits], [11 1]) err_zf.' err_nc.' err_snc.']);
disp([err_zf.' err_nc.' err_snc.'])

semilogy(Eb_N0_dB, err_zf, ...
    Eb_N0_dB, err_nc, ...
    Eb_N0_dB, err_snc, 'LineWidth', 2);
grid on;
title('Taxa de erros para sistema MIMO com BPSK');
legend('ZF', 'NC', 'SNC');
ylabel('BER');
xlabel('Eb/N0 (dB)');

function x = zf(H, y)
    pinvH = pinv(H);
    x = slice(pinvH * y);
end

function x = nc(H, y)
    [Q, R] = qr(H);
    z = Q' * y; % = R*x + n
    
    x = zeros(size(H, 2), 1);
    for i = size(R, 1) : -1 : 1
        x(i) = slice(z(i)/R(i,i));
        z = z - x(i)*R(i,i);
    end
end

function x = snc(H, y)
    sortOrder = getOrder(H);
    sortedH = sortMatrix(H, sortOrder);
    x = nc(sortedH, y);
    x = revertSort(x, sortOrder);
end

function x = slice(y)
    x = sign(real(y));
end



