% MusicAlg - Music Algorithm
%       MusicAlg(sig0, sig1, sig2, sig3) is a function designed to take 4
%       calibrated input signals received by a 4 part satellite array and
%       output the angle of arrival. 
%
%       Signals are currently calibrated using the SignalCal function which
%       produces 4 calibrated signals which are 1x181 real double arrays
%
%       Current Limitations: This current iteration of the Music Function
%       is only able to handle a single incident signal
%
% Program: MUSIC Algorithm Function
% Author: Mark McAllister 
% Last Modified: March 3, 2021

function [Angle] = MusicAlg(Ant0_cal, Ant1_cal, Ant2_cal, Ant3_cal, ARVFile)

%i = DegreeInterval;

% Imports the Array Response Vector which is created seperately using 
% ARV_Creation.m. Must recreate is changes are made to the testing set up

ARV = importdata(ARVFile);

i = 180/(length(ARV)-1);


% ARVTest1 = transpose(ARV(1:i:181,1));
% ARVTest2 = transpose(ARV(1:i:181,2));
% ARVTest3 = transpose(ARV(1:i:181,3));
% ARVTest4 = transpose(ARV(1:i:181,4));
% 
% ARV = transpose([ARVTest1;ARVTest2;ARVTest3;ARVTest4]);

M = 4; % Number of elements in the array
D = 1; % Number of signals

[row,~] = size(Ant0_cal);   % row => # of angles measured
broadside = round(row/2);

% Produces important values such as Ant#_calmag and ant#_phase
% which are used to make the calibrated signals into the correct form
% so that the MUSIC algorithm can appropriately parse through the ARV

ant0_calmag = max(abs(Ant0_cal));
ant0_FFT = fft(Ant0_cal(broadside,:));
[~,ant0b] = max(abs(ant0_FFT));
ant0_Phase = wrapTo2Pi(angle(ant0_FFT(ant0b)));

% if ant0_Phase > (90/180*pi) || ant0_Phase < (-90/180*pi)
%     ant0_calmag = max(abs(Ant0_cal));
%     ant0_FFT = fft(-Ant0_cal(broadside,:));
%     [~,ant0b] = max(abs(ant0_FFT));
%     ant0_Phase = angle(ant0_FFT(ant0b));
% end

ant1_calmag = max(abs(Ant1_cal));
ant1_FFT = fft(Ant1_cal(broadside,:));
[~,ant1b] = max(abs(ant1_FFT));
ant1_Phase = wrapTo2Pi(angle(ant1_FFT(ant1b)));

% if ant1_Phase > (90/180*pi) || ant1_Phase < (-90/180*pi)
%     ant1_calmag = max(abs(Ant1_cal));
%     ant1_FFT = fft(-Ant1_cal(broadside,:));
%     [~,ant1b] = max(abs(ant1_FFT));
%     ant1_Phase = angle(ant1_FFT(ant1b));
% end

ant2_calmag = max(abs(Ant2_cal));
ant2_FFT = fft(Ant2_cal(broadside,:));
[~,ant2b] = max(abs(ant2_FFT));
ant2_Phase = wrapTo2Pi(angle(ant2_FFT(ant2b)));

% if ant2_Phase > (90/180*pi) || ant2_Phase < (-90/180*pi)
%     ant2_calmag = max(abs(Ant2_cal));
%     ant2_FFT = fft(-Ant2_cal(broadside,:));
%     [~,ant2b] = max(abs(ant2_FFT));
%     ant2_Phase = angle(ant2_FFT(ant2b));
% end

ant3_calmag = max(abs(Ant3_cal));
ant3_FFT = fft(Ant3_cal(broadside,:));
[~,ant3b] = max(abs(ant3_FFT));
ant3_Phase = wrapTo2Pi(angle(ant3_FFT(ant3b)));

% if ant3_Phase > (90/180*pi) || ant3_Phase < (-90/180*pi)
%     ant3_calmag = max(abs(Ant3_cal));
%     ant3_FFT = fft(-Ant3_cal(broadside,:));
%     [~,ant3b] = max(abs(ant3_FFT));
%     ant3_Phase = angle(ant3_FFT(ant3b));
% end

% Creates the data for that the algorithm will use to parse through the ARV

Ant0_cal = ant0_calmag*exp(1i*(ant0_Phase));
Ant1_cal = ant1_calmag*exp(1i*(ant1_Phase));
Ant2_cal = ant2_calmag*exp(1i*(ant2_Phase));
Ant3_cal = ant3_calmag*exp(1i*(ant3_Phase));

% For our particular set up, our angle range is -90 to 90, however if this is
% changed, it is possible for the angle range to be 0 to 180
ang = -90:i:90;

% Compute the autocorrelation matrix
x = [Ant0_cal; Ant1_cal; Ant2_cal; Ant3_cal];
Rrr =x*x'/length(x);

% Finds eigenvectors and corresponding eigenvalues, then sorts them from 
% least to greatest
[V,Dia] = eig(Rrr);
[~,Index] = sort(diag(Dia));
EN = V(:,Index(1:M-D));

% Essentially parses through all 180 angles comparing gathered data against
% the ARV mathematically. EN is made using x which is
% produced using calibrated data. 
for k = 1:(180/i+1)
    P(k) = 1/abs(transpose(ARV(k,:))'*EN*EN'*transpose(ARV(k,:)));
end

% Produces a plotable data set based on the P calculated above
% MUSIC produces a massive spike at the angle the signals are coming from
% so by using the max function, we can accurately locate the angle of
% arrival
y = 10*log10(P/max(P));
[~,idxv] = max(y);
formatspec = 'The Estimated Angle of Arrival is: %3.1f degrees\n';

% Assigns Angle which will be the output of the function
Angle = ang(idxv);
fprintf(['The Estimated Angle of Arrival is: %3.1f' char(176) '\n'], Angle)

% Plots the MUSIC Pseudospectrum
figure
plot(ang,y,'k')
grid on, xlabel('Angle'), ylabel('|P(\theta)|')
title(['Pseudospectrum with a Peak Value at ', num2str(ang(idxv)),'\circ'])
axis([-90 90 -50 0])