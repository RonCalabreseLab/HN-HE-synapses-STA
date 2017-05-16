% Apply band-pass filter to all IPSC traces in bursts
% Parameters:
%   dataI: Current trace.
%   hpf, lpf: High-pass and low-pass cutoff frequencies for band-pass filter.
%   dt: Time step of data in seconds.
function [filtDataI] = filterITraces(dataI, hpf, lpf, dt)

hpf = 5;   % high-pass after this [Hz]
lpf = min(3000, 1/dt/2 - 1); % also filter high freq noise

% make a new filter based on the given dt
% multiply by 2 to find nyquist freq
assert(all(2*[lpf hpf]*dt <= 1), ...
       [ 'For custom filter, highPassFreq and lowPassFreq must be <= ' ...
         'Nyquist freq (' num2str(1/dt/2) ').' ]);

% Create two Butterworth filters for high and low pass
[b,a] = butter(2,2*hpf*dt,'high');
butterWorth.highPass = struct('b', b, 'a', a);
[b,a] = butter(2,2*lpf*dt,'low');
butterWorth.lowPass = struct('b', b, 'a', a);
        
% Use zero-phase forward-reverse digital IIR filter
filtDataI = ...
    filtfilt(butterWorth.highPass.b, butterWorth.highPass.a, dataI);
filtDataI = ...
    filtfilt(butterWorth.lowPass.b, butterWorth.lowPass.a, filtDataI);

% Manual testing shows <%1 reduction in spike amplitude
% and IPSC amplitude (~%0.3) after filtering