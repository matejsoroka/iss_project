% 1
[signal, Fs] = audioread('xsorok02.wav'); s = signal';
x = (0 : (length(s) - 1)) / Fs;
len = length(s); % pocet vzorkov

% 2
i = 8;
j = 1;
while i < len
	if (s(i) > 0)
		bit_samples(j) = 1;
		else
		bit_samples(j) = 0;
	endif
	i = i + 16;
	j = j + 1;
endwhile
% len(bit_samples); pocet bitovych symbolov

stem_spaced = linspace(0, 0.02, 20);
grid;
plot(x(1:320), s(1:320));
xlabel("t [s]");
hold on
stem(stem_spaced, bit_samples(1:20));
hold off

% 3
B = [0.0192 -0.0185 -0.0185 0.0192];
A = [1.0000 -2.8870 2.7997 -0.9113];
zplane(B, A); xlabel('Reálna časť'); ylabel('Imaginárna časť');
p = roots(A);
if (isempty(p) | abs(p) < 1)
	disp('3 - stabilny signal')
else
	disp('3 - nestabilny signal')
end

% 4
f = (0:len - 1) / len * Fs / 2;
h = freqz(B, A, len);
[M,I] = min(abs(h(1:16000)));
printf("4 - %f\n", I / 4); % mezni frekvence
plot(f(1:16000), abs(h(1:16000))); grid; xlabel('f [Hz]'); ylabel('|H(f)|');

% 5
filtered = filter(B, A, signal);
i = 8;
j = 1;
while i < len
	if (filtered(i) > 0)
		bit_samples_filtered(j) = 1;
	else
		bit_samples_filtered(j) = 0;
	endif
	i = i + 16;
	j = j + 1;
endwhile
plot(x, s); xlim([0, 0.02]);
hold on
plot(x, filtered); xlim([0, 0.02]);
ylabel("s[n], ss[n] ss_s_h_i_f_t_e_d[n], symbols");
xlabel("t [s]");

% 6
shifted = circshift(filtered, -15);
plot(x, shifted);
stem(stem_spaced, bit_samples_filtered(1:20));
xlim([0, 0.02]);
hold off


% 7
tmp = 0;
for k = 1:1:1999
	if (xor(bit_samples(k), bit_samples_filtered(k + 1)))
		tmp = tmp + 1;
	endif
end
disp((tmp / 1999) * 100); % pocet percent chybnych bitov

% 8
dft = fft(signal);
mag = abs(dft);
hold on;
grid;
plot(mag(1:(Fs/2)));
filtered_dft = fft(filtered);
filteredMag = abs(filtered_dft);
plot(filteredMag(1:(Fs/2)));
xlabel("f[Hz]");
hold off;

% 9
plot(hist(signal, 100) / len);

% 10
[r, delay] = xcorr(s, 'biased');
plot(delay, r);
xlim([-50 50]);

% 11
R0 = r(len);
R1 = r(1 + len);
R16 = r(16 + len);

% 12
x = linspace(min(s), max(s), 100);
printf("12 - ");
[h,p,r] = hist2(s(1:len - 1), s(2:len), x);
plot3(-x,x,p);
axis xy;
colorbar;

% 14
printf("13 - %d\n", r);
