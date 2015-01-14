% LDPC Graphing Run Script
clear
close

% "Parity Check Matrix" or graph connections
H = load('../../LDPC data/Rate0.876/H-3584-3140.mat');
H = sparse(H.H); %Dodgy work-around!

% "Generator Matrix"
G = load('../../LDPC data/Rate0.876/G-3584-3141-v2.mat');
G = sparse(G.G); %Dodgy work-around!


% Belief Propogation Iterations
l = 1000;
% MC Simulation Iterations
N = 10;

% Modulation Rate
Rm = 1; %Always 1 for BPSK
% Code Rate Calculation
[m,n] = size(G);
Rc = m/n;

% Loop to go over all values of EbNo, as well as perform MC Simulation
I = [];
for EbNo = -2:1:6
    fprintf('SNR =%6.2f',EbNo);
    fprintf('\n');
    tic;
    % Noise Variance Extraction
    sigma2 = getVariance(EbNo,Rc,Rm);
    %Parfor Loop
    %parfor_progress(N);
    parfor i = 1:N
        [~,errRatio(i),iterations(i)] = ldpc_BER_AWGN(G,H,l,sigma2);
    %parfor_progress;
    end
    %parfor_prohress(0);
    toc;
    %Output Matrix
    I = [I;EbNo-10*log10(1/Rc),mean(iterations),mean(errRatio)];
end
