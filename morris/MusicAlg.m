function [Angle] = MusicAlg(ARV)

addpath(uigetdir('/data', 'Select a Live Test Data Set'));

ant0 = read_complex_binary("LiveArrayTest0_0");
ant1 = read_complex_binary("LiveArrayTest1_0");
ant2 = read_complex_binary("LiveArrayTest2_0");
ant3 = read_complex_binary("LiveArrayTest3_0");

ant0_0 = read_complex_binary("LiveArrayTest0_0");
ant1_0 = read_complex_binary("LiveArrayTest1_0");
ant2_0 = read_complex_binary("LiveArrayTest2_0");
ant3_0 = read_complex_binary("LiveArrayTest3_0");

a0_fft = fft(ant0_0);
[m0_cal, i] = max(abs(a0_fft));
a0_cal_phase = angle(a0_fft(i));

a1_fft = fft(ant1_0);
[m1_cal, i] = max(abs(a1_fft));
a1_cal_phase = angle(a1_fft(i));

a2_fft = fft(ant2_0);
[m2_cal, i] = max(abs(a2_fft));
a2_cal_phase = angle(a2_fft(i));

a3_fft = fft(ant3_0);
[m3_cal, i] = max(abs(a3_fft));
a3_cal_phase = angle(a3_fft(i));
    

ant0 = ant0*exp(-1i*a0_cal_phase);
ant1 = ant1*exp(-1i*a1_cal_phase);
ant2 = ant2*exp(-1i*a2_cal_phase);
ant3 = ant3*exp(-1i*a3_cal_phase);

ant0 = m0_cal/m0_cal*ant1;
ant1 = m0_cal/m1_cal*ant1;
ant2 = m0_cal/m2_cal*ant2;
ant3 = m0_cal/m3_cal*ant3;

i = 180/(length(ARV)-1);


% ARVTest1 = transpose(ARV(1:i:181,1));
% ARVTest2 = transpose(ARV(1:i:181,2));
% ARVTest3 = transpose(ARV(1:i:181,3));
% ARVTest4 = transpose(ARV(1:i:181,4));
% 
% ARV = transpose([ARVTest1;ARVTest2;ARVTest3;ARVTest4]);

M = 4; % Number of elements in the array
D = 1; % Number of signals

a0_fft = fft(ant0);
[m0, i0] = max(abs(a0_fft));
a0_phase = angle(a0_fft(i0));

a1_fft = fft(ant1);
[m1, i1] = max(abs(a1_fft));
a1_phase = angle(a1_fft(i1));

a2_fft = fft(ant2);
[m2, i2] = max(abs(a2_fft));
a2_phase = angle(a2_fft(i2));

a3_fft = fft(ant3);
[m3, i3] = max(abs(a3_fft));
a3_phase = angle(a3_fft(i3)); 

% Creates the data for that the algorithm will use to parse through the ARV

Ant0_cal = m0*exp(1i*(a0_phase));
Ant1_cal = m1*exp(1i*(a1_phase));
Ant2_cal = m2*exp(1i*(a2_phase));
Ant3_cal = m3*exp(1i*(a3_phase));

% For our particular set up, our angle range is -90 to 90, however if this is
% changed, it is possible for the angle range to be 0 to 180
ang = -90:i:90;

% Compute the autocorrelation matrix
x = [Ant0_cal; Ant1_cal; Ant2_cal; Ant3_cal];
% x= x/max(abs(x));
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