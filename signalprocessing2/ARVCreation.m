function [] = ARVCreation(startAngDeg,stopAngDeg,degInt)

input('Please hit enter, then select your Data Set.');
DataFolder = uigetdir('/Users/seniordesign/Documents/MATLAB/SIGNAL_PROCESSING_PROGRAM/SIGNAL_PROCESSING_PROGRAM/USRP_DATA/'); 
angles = startAngDeg:degInt:stopAngDeg;

ARV = [];
for k=1:length(angles)
    
    fprintf(['Processing ARV for ' num2str(angles(k)) char(176) '\n']);
    
    file0 = "ArrayTest0_"+angles(k);
    file1 = "ArrayTest1_"+angles(k);
    file2 = "ArrayTest2_"+angles(k);
    file3 = "ArrayTest3_"+angles(k);
    
    Ant0 = read_complex_binary(file0);
    Ant1 = read_complex_binary(file1);
    Ant2 = read_complex_binary(file2);
    Ant3 = read_complex_binary(file3);
    
    [Ant0_cal,Ant1_cal,Ant2_cal,Ant3_cal] = SignalCal(Ant0,Ant1,Ant2,Ant3,DataFolder,0);
    
    Ant0_calmag = max(abs(Ant0_cal));
    Ant0_FFT = fft(Ant0_cal);
    [Ant0a,Ant0b] = max(abs(Ant0_FFT));
    Ant0_Phase = wrapTo2Pi(angle(Ant0_FFT(Ant0b)));
    
    Ant1_calmag = max(abs(Ant1_cal));
    Ant1_FFT = fft(Ant1_cal);
    [Ant1a,Ant1b] = max(abs(Ant1_FFT));
    Ant1_Phase = wrapTo2Pi(angle(Ant1_FFT(Ant1b)));
    
    Ant2_calmag = max(abs(Ant2_cal));
    Ant2_FFT = fft(Ant2_cal);
    [Ant2a,Ant2b] = max(abs(Ant2_FFT));
    Ant2_Phase = wrapTo2Pi(angle(Ant2_FFT(Ant2b)));
    
    Ant3_calmag = max(abs(Ant3_cal));
    Ant3_FFT = fft(Ant3_cal);
    [Ant3a,Ant3b] = max(abs(Ant3_FFT));
    Ant3_Phase = wrapTo2Pi(angle(Ant3_FFT(Ant3b)));

    ARV(k,1)= Ant0_calmag*exp(1i*wrapTo2Pi(Ant0_Phase));
    ARV(k,2)= Ant1_calmag*exp(1i*wrapTo2Pi(Ant1_Phase));
    ARV(k,3)= Ant2_calmag*exp(1i*wrapTo2Pi(Ant2_Phase));
    ARV(k,4)= Ant3_calmag*exp(1i*wrapTo2Pi(Ant3_Phase));
end

% Adjust angles so that broadside is at 0 degrees
broadsideInd = find(angles == 0);
ARV = ARV.*exp(-j*angle(ARV(broadsideInd,1)));

% Normalize the ARV
ARV = ARV./max(max(abs(ARV)));

%Creates ARV file name and saves the ARV within the program directory ARVs.
%ARVs are named as ARV_"The Data set name that was used to make it"_"Date
%of creation"
date = datestr(now, 'mmmm-dd-yyyy');
ArrayTest = extractAfter(DataFolder, '/Users/seniordesign/Documents/MATLAB/SIGNAL_PROCESSING_PROGRAM/SIGNAL_PROCESSING_PROGRAM/USRP_DATA/');
FILENAME = "ARV_"+ArrayTest+"_Created_"+date+".mat";
matfile = fullfile('/Users/seniordesign/Documents/MATLAB/Signal_Processing_2', FILENAME);
save(matfile, 'ARV');
end

