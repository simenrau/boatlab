clear all
close all
clc

%% PSD estimation
load('wave.mat');

fs = 10;
window = 4096;
noverlap = [];
nfft = [];

[est_psd, f] = pwelch(psi_w(2,:).*(pi/180),window,noverlap,nfft,fs);    %psi_w is given in degrees (translates to radians)

est_psd = est_psd*(1/(2*pi));   %converting pxx [power per Hz] to pxx [(power*sec)/rad] 
omega = f.*(2*pi);      %converting f [Hz] to f [rad/s]

[maxValPSD, indexMaxValPSD] = max(est_psd); 
omega_0 = omega(indexMaxValPSD);
sigma = sqrt(maxValPSD);

lambda = 0.085;
K_w = 2*lambda.*omega_0*sigma;
psd = (omega.*K_w).^2./(omega.^4 + omega_0^4 + 2*omega_0^2*omega.^2*(2*lambda.^2-1));

%% Plotting
figure
plot(omega,est_psd,'Linewidth',1); hold on;
plot(omega,psd,'Linewidth',1); grid
title('Estimate of Power Spectral Density (PSD)')
xlabel('[rad / sec]');
ylabel('[(power * sec) / rad]');
legend('Estimate of PSD','Analytical PSD with \lambda = 0.085');
axis([0 1.75 0 1.6e-3]);