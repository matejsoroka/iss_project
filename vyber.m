function x = vyber(s,howmuch,wherefrom,Fs) 
% function x = vyber (s,howmuch,wherefrom,Fs)
%
% s - signal 
% howmmuch - kolik vybrat [s]
% wherefrom - odkud [s]
% Fs - vzork. frekvence [Hz]
%
% funkce vyploti signal a jeho PSD. 

hm = howmuch * Fs; 
wf = wherefrom * Fs; 
x = s(wf:(wf+hm-1)); 
subplot(211); plot (x); grid; 

N = length(x);
G = 10 * log10(1/N * abs(fft(x)).^2);
f = (0:N/2-1)/N * Fs; G = G(1:N/2);
subplot(212); plot (f,G); xlabel('f [Hz]'); ylabel ('PSD [dB]'); grid; 