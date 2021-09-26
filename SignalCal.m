%SignalCal - Signal Calibration
%       SignalCal(sig0, sig1, sig2, sig3, foldername) - is a function designed to take
%       4 signals taken from a specific angle from a USRP N310, and remove
%       phase differences from them by removing phase differences found at
%       a 0 degree (or Broadside) position.
%
%       Includes an optional string input for the choice of array test
%       data. This allows for users to choose from multiple selections of
%       test data they may have gathered which are stored in the same
%       location.
%
%       Input Signals are 2000000x1 complex doubles
%       Output signals are 1x181 real double arrays
% 
%Program: USRP Signal Calibration Function
%Author: Mark McAllister 
%Last Modified: Feb 2, 2021


function [Ant0_cal, Ant1_cal, Ant2_cal, Ant3_cal] =...
SignalCal(Ant0, Ant1, Ant2, Ant3, DataFolder)

%Adds the particular path to the data gathered. I plan to somehow make this
%a user input or to have a directory withint he program file so its all
%easier to access rather than having to find the filepath everytime.

%addpath(DataFolder);

%Known parameters for signals being gathered
fs = 100e6;
dt = 1/fs;
StartTime = dt;
StopTime = 181*dt;
t = (StartTime:dt:StopTime);
F = 1949950;


%Phase differences at broadside which were caluculated beforehand.
%Will be applied to input signals to bring signals into proper phase
Ant0_broad = read_complex_binary(['ArrayTest0_0']);
Ant1_broad = read_complex_binary(['ArrayTest1_0']);
Ant2_broad = read_complex_binary(['ArrayTest2_0']);
Ant3_broad = read_complex_binary(['ArrayTest3_0']);

[row,col] = size(Ant0);   % row => # of angles measured
                          % col => Data at the angle specified by the row
broadside = round(row/2);

Ant0_FFT = fft(Ant0_broad(broadside,:));
[Ant0a,Ant0b] = max(abs(Ant0_FFT));
Ant0_Phase = angle(Ant0_FFT(Ant0b));

Ant11_FFT = fft(Ant1_broad(broadside,:));
[Ant1a,Ant1b] = max(abs(Ant11_FFT));
Ant1_Phase = angle(Ant11_FFT(Ant1b));

Ant22_FFT = fft(Ant2_broad(broadside,:));
[Ant2a,Ant2b] = max(abs(Ant22_FFT));
Ant2_Phase = angle(Ant22_FFT(Ant2b));

Ant3_FFT = fft(Ant3_broad(broadside,:));
[Ant3a,Ant3b] = max(abs(Ant3_FFT));
Ant3_Phase = angle(Ant3_FFT(Ant3b));

Ant01_broadside = Ant0_Phase - Ant1_Phase;
Ant02_broadside = Ant0_Phase - Ant2_Phase;
Ant03_broadside = Ant0_Phase - Ant3_Phase;


%Use FFT to derive the amplitude and phases of the signals

Ant0_FFT = fft(Ant0(broadside,:));
[Ant0a,Ant0b] = max(abs(Ant0_FFT));
Ant0_Phase = angle(Ant0_FFT(Ant0b));

Ant11_FFT = fft(Ant1(broadside,:));
[Ant1a,Ant1b] = max(abs(Ant11_FFT));
Ant1_Phase = angle(Ant11_FFT(Ant1b));

Ant22_FFT = fft(Ant2(broadside,:));
[Ant2a,Ant2b] = max(abs(Ant22_FFT));
Ant2_Phase = angle(Ant22_FFT(Ant2b));

Ant3_FFT = fft(Ant3(broadside,:));
[Ant3a,Ant3b] = max(abs(Ant3_FFT));
Ant3_Phase = angle(Ant3_FFT(Ant3b));

%Creates strictly real signals based on the variables gathered from FFT and
%the phase shifts calculated from broadside
Ant0_cal = Ant0a*sin(2*pi*F*t-Ant0_Phase);
Ant1_cal = Ant1a*(Ant0a/Ant1a)*sin(2*pi*F*t-(Ant1_Phase+Ant01_broadside));
Ant2_cal = Ant2a*(Ant0a/Ant2a)*sin(2*pi*F*t-(Ant2_Phase+Ant02_broadside));
Ant3_cal = Ant3a*(Ant0a/Ant3a)*sin(2*pi*F*t-(Ant3_Phase+Ant03_broadside));

%Uncomment this section if you need to confirm that your signals are being
%properly calibrated
% figure;
% plot(t, Ant0_cal,'r', t, Ant1_cal, 'b', t, Ant2_cal, 'g', t, Ant3_cal, 'm');
% title('Calibrated Signal using Function');
% legend('ant 0', 'ant 1', 'ant 2', 'ant 3')
% xlabel('Seconds (us)');
% ylabel('Amplitude');
% xlabel('Seconds')
% ylabel('Amplitude')
% xlim([0 100*dt])
% ylim([-.1 .1]);


end