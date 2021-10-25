% Program Name: GetARV1.m
% Author: David Allen,  Last Modified: 10/20/2019
% Description: The following script is a user defined function used to
%              calculate the Array Response Vector (ARV) 

function [ARV,A_cal] = GetARV1(A1,A2,A3,A4,AngleNum)

% Inputs: ant0, ant1, ant2, & ant3 should be a matrix with rows
% representing the angles and columns representing the data collected at
% those angles: The following checks to see if the data is in such a
% format:
% -------------------------------------------------------------------------
    [row,~] = size(A1);
% 181 element row is the max amount of angles we would measure, 
% therefore if row is bigger than this then that means the rows are 
% actually the data and we need to make them columns;
    if row > 181
        A1 = transpose(A1);
        A2 = transpose(A2);
        A3 = transpose(A3);
        A4 = transpose(A4); 
    end
% -------------------------------------------------------------------------

%Load variables
broadsideInd=19; % Broaside is the 19th Row
ARV=[];

% Find fourier transforms at broadside should be 0, it wont be
% ant1_FFT is the fourier vector of the antenna
% ant1 is the max amplitude of the vecotor
% ant1b is when it occurs
% ant_Phase returns the angle in degrees
    A1_FFT = fft(A1(broadsideInd,:));
    [A1a,A1b] = max(abs(A1_FFT));
    A1_Phase = angle(A1_FFT(A1b))*180/pi;

    A2_FFT = fft(A2(broadsideInd,:));
    [A2a,A2b] = max(abs(A2_FFT));
    A2_Phase = angle(A2_FFT(A2b))*180/pi;

    A3_FFT = fft(A3(broadsideInd,:));
    [A3a,A3b] = max(abs(A3_FFT));
    A3_Phase = angle(A3_FFT(A3b))*180/pi;

    A4_FFT = fft(A4(broadsideInd,:));
    [A4a,A4b] = max(abs(A4_FFT));
    A4_Phase = angle(A4_FFT(A4b))*180/pi;

% Calibrate Amplitudes at Broadside
% ant1_fa finds the ratio in relationship to the first and scales each
% antenna by that amplitude
    [~,q] = size(A1);
    for c = 1:q
        A1_fa=A1(:,q)/A1(broadsideInd,q);
        A2_fa=A2(:,q)/A2(broadsideInd,q);
        A3_fa=A3(:,q)/A3(broadsideInd,q);
        A4_fa=A4(:,q)/A4(broadsideInd,q);
    end
    
    A_fa = [A1_fa,A2_fa,A3_fa,A4_fa];

% Calibrate Phases Diffrences at Broadside
% ant1_cal apply the phase diff to each of the antenna elements
% convert to radians, then multiply by e^()
    A1_cal=exp(-1i*pi/180*A1_Phase)*A1_fa;
    A2_cal=exp(-1i*pi/180*A2_Phase)*A2_fa;
    A3_cal=exp(-1i*pi/180*A3_Phase)*A3_fa;
    A4_cal=exp(-1i*pi/180*A4_Phase)*A4_fa;
    
    A_cal = [A1_cal,A2_cal,A3_cal,A4_cal];
    

% Array Vector Creation
% at every angle 1:AngleNum we want to find the phase of each element then
% create a vector in phases in refernce to the first element
    for k=1:AngleNum
        % ant1_calmag finds the amplitude at that angle
        % ant1_FFT creates a fourier vector
        % ant1a is the max amplitude of that vector
        % ant1b is where it occurs
        % ant1_Phase is the phase is degrees
        ant1_calmag = max(abs(A1_cal(k,:)));
        A1_FFT = fft(A1_cal(k,:));
        [A1a,A1b] = max(abs(A1_FFT));
        A1_Phase = angle(A1_FFT(A1b))*180/pi;

        ant2_calmag = max(abs(A1_cal(k,:)));
        A2_FFT = fft(A2_cal(k,:));
        [A2a,A2b] = max(abs(A2_FFT));
        A2_Phase = angle(A2_FFT(A2b))*180/pi;

        ant3_calmag = max(abs(A1_cal(k,:)));
        A3_FFT = fft(A3_cal(k,:));
        [A3a,A3b] = max(abs(A3_FFT));
        A3_Phase = angle(A3_FFT(A3b))*180/pi;

        ant4_calmag = max(abs(A1_cal(k,:)));
        A4_FFT = fft(A4_cal(k,:));
        [A4a,A4b] = max(abs(A4_FFT));
        A4_Phase = angle(A4_FFT(A4b))*180/pi; 

        % Find the Array Response Vector
        % Create the element by scaling the amplitutde and shifting it by
        % the diffrence between each element and the first element
        ARV(k,1)=ant1_calmag*exp(-1i*(A1_Phase-A1_Phase)*pi/180);
        ARV(k,2)=ant2_calmag*exp(-1i*(A2_Phase-A1_Phase)*pi/180);
        ARV(k,3)=ant3_calmag*exp(-1i*(A3_Phase-A1_Phase)*pi/180);
        ARV(k,4)=ant4_calmag*exp(-1i*(A4_Phase-A1_Phase)*pi/180);
    end  
end