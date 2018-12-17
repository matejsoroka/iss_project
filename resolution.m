% 1
[s, Fs] = audioread('xsorok02.wav'); s = s';
x = (0 : (length(s) - 1)) / Fs;
info = audioinfo('xsorok02.wav');
total_samples = info.TotalSamples;
duration = info.Duration;
symbols = total_samples / info.BitsPerSample;
sampleRate = info.SampleRate;

% 2
len = length(s)
i = 8;
j = 1;
while i < len
  if (s(i) > 0)
    a(j) = 1;
  else
    a(j) = 0;
  endif
  i = i + 16;
  j = j + 1;
endwhile

x1 = linspace(0, 0.02, 20);
grid;
plot(x(1:320), s(1:320));
xlabel("t [s]");
hold on
stem(x1, a(1:20));
hold off

% % 3
B = [0.0192 -0.0185 -0.0185 0.0192];
A = [1.0000 -2.8870 2.7997 -0.9113];
zplane(B, A);xlabel('Reálna časť'); ylabel('Imaginárna časť');
p = roots(A);
if (isempty(p) | abs(p) < 1)
 disp('stabilny signal')
else
 disp('nestabilny signal')
end

% 4
f = (0:len - 1) / len * Fs / 2;
h = freqz(B, A, len);
plot(f, abs(h)); grid; xlabel('f [Hz]'); ylabel('|H(f)|');

% 5
foo = audioread ('xsorok02.wav');
filtered = filter(B, A, foo);
plot(x, s); xlim([0, 0.02]);
hold on
plot(x, filtered); xlim([0, 0.02]);
ylabel("s[n], ss[n] ss_s_h_i_f_t_e_d[n], symbols");
xlabel("t [s]");

% 6
shifted = circshift(filtered, -15);
plot(x, shifted);
stem(x1, a(1:20));
xlim([0, 0.02]);
hold off

% 7

% 8
dft = fft(foo);
mag = abs(dft);
subplot(2,1,1);
plot(f, mag);
xlabel("f[Hz]");
filtered_dft = fft(filtered);
filteredMag = abs(filtered_dft);
subplot(2,1,2); plot(f, filteredMag);
xlabel("f[Hz]");

% 9

% % 10
[r, delay] = xcorr(s, 'biased');
plot(delay, r);
xlim([-50 50]);
% 11
R0 = r(len);
R1 = r(1 + len);
R16 = r(16 + len);

% 12
x = linspace(min(s), max(s), 100);
[h,p,r] = hist2opt(s(1:len - 1), s(2:len), x);
plot3(-x,x,p);
axis xy;
colorbar;

% 13
disp(r);
