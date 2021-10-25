 function [] = ARVCreation(DataFolder, DegreeInterval)

addpath(DataFolder);

ARV = [];
for k=1: DegreeInterval :181
    index = k-91;
    
    message = 'Currently processing array response for %2.0d \n';
    fprintf(message, index);
    
    file0 = "ArrayTest0_"+index;
    file1 = "ArrayTest1_"+index;
    file2 = "ArrayTest2_"+index;
    file3 = "ArrayTest3_"+index;
    
    Ant0 = read_complex_binary([file0]);
    Ant1 = read_complex_binary([file1]);
    Ant2 = read_complex_binary([file2]);
    Ant3 = read_complex_binary([file3]);
    
    [Ant0_cal, Ant1_cal, Ant2_cal, Ant3_cal] =...
    SignalCal(Ant0, Ant1, Ant2, Ant3, DataFolder);

    [row, ~] = size(Ant0);   % row => # of angles measured
                          % col => Data at the angle specified by the row
    broadside = round(row/2);
    
    Ant0_calmag = max(abs(Ant0_cal));
    Ant0_FFT = fft(Ant0_cal);
    [Ant0a,Ant0b] = max(abs(Ant0_FFT));
    Ant0_Phase = angle(Ant0_FFT(Ant0b));
    
    Ant1_calmag = max(abs(Ant1_cal));
    Ant1_FFT = fft(Ant1_cal);
    [Ant1a,Ant1b] = max(abs(Ant1_FFT));
    Ant1_Phase = angle(Ant1_FFT(Ant1b));
    
    Ant2_calmag = max(abs(Ant2_cal));
    Ant2_FFT = fft(Ant2_cal);
    [Ant2a,Ant2b] = max(abs(Ant2_FFT));
    Ant2_Phase = angle(Ant2_FFT(Ant2b));
    
    Ant3_calmag = max(abs(Ant3_cal));
    Ant3_FFT = fft(Ant3_cal);
    [Ant3a,Ant3b] = max(abs(Ant3_FFT));
    Ant3_Phase = angle(Ant3_FFT(Ant3b));

    % Find the Phase Vector
    % Create the element by scaling the amplitude and shifting it by the
    % diffrence between each element and the first element
    ARV(k,1)= Ant0_calmag*exp(1i*Ant0_Phase);
    ARV(k,2)= Ant1_calmag*exp(1i*Ant1_Phase);
    ARV(k,3)= Ant2_calmag*exp(1i*Ant2_Phase);
    ARV(k,4)= Ant3_calmag*exp(1i*Ant3_Phase);
end
% Normalize the ARV
ARV = ARV./max(max(abs(ARV)));

%Creates ARV file name and saves the ARV within the program directory ARVs.
%ARVs are named as ARV_"The Data set name that was used to make it"_"Date
%of creation"
date = datestr(now, 'mmmm-dd-yyyy');
ArrayTest = extractAfter(DataFolder, "/Users/morris/Desktop/seniordesign/arv");
FILENAME = "ARV_"+ArrayTest+"_Created:"+date+".mat";
matfile = fullfile('ARVs', FILENAME);
save(matfile, 'ARV');
%need to export the ARV as a file to import later into the MUSIC function
end

