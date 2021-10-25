% Programe Name: MUSIC_ALG.m
%        Author: David Allen
%   Description: Implementing MUSIC Algorithm. 
%          Date: January 24, 2019

clear, clc, close all

% -------------------------------------------------------------------------
% Load the data: (Structure Data Type)

load('ant1capture.mat') % No phase ambiguity 
load('ant2capture.mat') % No phase ambiguity 
load('ant3capture.mat') % No phase ambiguity 
load('ant4capture.mat') % No phase ambiguity 

% ant1 = data captured by antenna 1
% ant2 = data captured by antenna 2
% ant3 = data captured by antenna 3
% ant4 = data captured by antenna 4
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Find the Array Response Vector (ARV)

[row,col] = size(ant1);   % row => # of angles measured
                          % col => Data at the angle specified by the row
broadside = round(row/2); % The row # that represents broadside incidence

ARV = []; % Pre-assign variable for array response vector

% Find the FFT at broadside. (It should be zero, but it wont be)
% ant1_FFT is the fourier transform vector from data collected from ant1
% ant1b is the column location when the amplitude
% of the ant1_FFT vector is maximum; ant_Phase returns
% the angle at ant1b in degrees. 
ant1_FFT = fft(ant1(broadside,:));
[ant1a,ant1b] = max(abs(ant1_FFT));
ant1_Phase = angle(ant1_FFT(ant1b))*180/pi;

ant2_FFT = fft(ant2(broadside,:));
[ant2a,ant2b] = max(abs(ant2_FFT));
ant2_Phase = angle(ant2_FFT(ant2b))*180/pi;

ant3_FFT = fft(ant3(broadside,:));
[ant3a,ant3b] = max(abs(ant3_FFT));
ant3_Phase = angle(ant3_FFT(ant3b))*180/pi;

ant4_FFT = fft(ant4(broadside,:));
[ant4a,ant4b] = max(abs(ant4_FFT));
ant4_Phase = angle(ant4_FFT(ant4b))*180/pi;

% Calibrate Phases Diffrences at Broadside
% ant1_cal apply the phase diff to each of the antenna elements
% convert to radians, then multiply by e^()
ant1_cal=exp(-1i*pi/180*ant1_Phase)*ant1;
ant2_cal=exp(-1i*pi/180*ant2_Phase)*ant2;
ant3_cal=exp(-1i*pi/180*ant3_Phase)*ant3;
ant4_cal=exp(-1i*pi/180*ant4_Phase)*ant4;

% Calibrate Amplitudes at Broadside
% ant1_fa finds the ratio in relationship to the first and scales each
% antenna by that amplitude
ant1_cal = (ant1a/ant1a)*ant1_cal;
ant2_cal = (ant1a/ant2a)*ant2_cal;
ant3_cal = (ant1a/ant3a)*ant3_cal;
ant4_cal = (ant1a/ant4a)*ant4_cal;

% Array Vector Creation
% at every angle 1:181 we want to find the phase of each element then
% create a vector in phases in refernce to the first element
for k=1:181
  % Find phase 
    % ant1_calmag finds the amplitude at that angle
    % ant1_FFT creates a fourier vectpr
    % ant1a is the max amplitude of that vector
    % ant1b is where it occurs
    % ant1_Phase is the phase is degrees
    ant1_calmag = max(abs(ant1_cal(k,:)));
    ant1_FFT = fft(ant1_cal(k,:));
    [ant1a,ant1b] = max(abs(ant1_FFT));
    ant1_Phase = angle(ant1_FFT(ant1b))*180/pi;

    ant2_calmag = max(abs(ant1_cal(k,:)));
    ant2_FFT = fft(ant2_cal(k,:));
    [ant2a,ant2b] = max(abs(ant2_FFT));
    ant2_Phase = angle(ant2_FFT(ant2b))*180/pi;

    ant3_calmag = max(abs(ant1_cal(k,:)));
    ant3_FFT = fft(ant3_cal(k,:));
    [ant3a,ant3b] = max(abs(ant3_FFT));
    ant3_Phase = angle(ant3_FFT(ant3b))*180/pi;

    ant4_calmag = max(abs(ant1_cal(k,:)));
    ant4_FFT = fft(ant4_cal(k,:));
    [ant4a,ant4b] = max(abs(ant4_FFT));
    ant4_Phase = angle(ant4_FFT(ant4b))*180/pi; 

    % Find the Phase Vector
    % Create the element by scaling the amplitutde and shifting it by the
    % diffrence between each element and the first element
    ARV(k,1)=ant1_calmag*exp(1i*(ant1_Phase-ant1_Phase)*pi/180);
    ARV(k,2)=ant2_calmag*exp(1i*(ant2_Phase-ant1_Phase)*pi/180);
    ARV(k,3)=ant3_calmag*exp(1i*(ant3_Phase-ant1_Phase)*pi/180);
    ARV(k,4)=ant4_calmag*exp(1i*(ant4_Phase-ant1_Phase)*pi/180);
end

% Normalize the ARV
ARV = ARV./max(max(abs(ARV)));

% -------------------------------------------------------------------------

% MUSIC Algorithm 
% -------------------------------------------------------------------------
M = 4;
D = 1; % number of signals

inc_ang = 85;

ang = -90:1:90;

ang_ind = find(ang == inc_ang);

A = ARV(ang_ind,:).';

Rss = eye(D);

% Compute the autocorrelation matrix
x = [ant1_cal(ang_ind,:); ant2_cal(ang_ind,:); ant3_cal(ang_ind,:); ant4_cal(ang_ind,:)];
Rrr =x*x'/length(x);

[V,Dia] = eig(Rrr);
[~,Index] = sort(diag(Dia));
EN = V(:,Index(1:M-D));

for k = 1:181
    P(k) = 1/abs(transpose(ARV(k,:))'*EN*EN'*transpose(ARV(k,:)));
end

infInd = find(P == inf);
P(infInd) = 1e-10;

y = 10*log10(P/max(P));
[~,idxv] = max(y);
formatspec = 'The Estimated Angle of Arrival is: %4.3f degrees\n';
fprintf(formatspec,ang(idxv))

figure
plot(ang,y,'k')
grid on, xlabel('Angle'), ylabel('|P(\theta)|')
title(['Pseudospectrum with a Peak Value at ', num2str(ang(idxv)),'\circ'])
axis([-90 90 -50 0])
