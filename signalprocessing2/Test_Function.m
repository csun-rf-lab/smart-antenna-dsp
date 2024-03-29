%close all; clear all; clc;

addpath('/Users/seniordesign/Documents/USRP_DATA') %This is where the Testing Files Should be saved
addpath('/Users/seniordesign/Documents/MATLAB/SIGNAL_PROCESSING_PROGRAM/SIGNAL_PROCESSING_PROGRAM/txt_files');


% gnuFileName = '/ArrayTest3_Test.py';
% gnuFilePath = '/Users/seniordesign/Documents/MATLAB/PositionControl-master/PositionControl-master/USRP';
% takeMeasurementCommand = ['/opt/local/bin/python2.7 ' gnuFilePath gnuFileName ];
%  
% [~,usrpMeasurement] = system(takeMeasurementCommand)

input('Please hit enter, then select your Data Set.');
DataFolder = uigetdir('/Users/seniordesign/Documents/MATLAB/SIGNAL_PROCESSING_PROGRAM/SIGNAL_PROCESSING_PROGRAM/USRP_DATA/'); 

input('Please hit enter, then select your Live Data Set.');
LiveDataFolder = uigetdir('/Users/seniordesign/Documents/MATLAB/SIGNAL_PROCESSING_PROGRAM/SIGNAL_PROCESSING_PROGRAM/USRP_DATA/'); 
addpath(LiveDataFolder);

input('Please hit enter, then select your ARV.');
ARVFile = uigetfile('/Users/seniordesign/Documents/MATLAB/Signal_Processing_2', 'Select ARV File');

for ang = 0:1:45

    testAng = num2str(ang);

    LiveAnt0 = read_complex_binary(['LiveArrayTest0_' testAng]);
    LiveAnt1 = read_complex_binary(['LiveArrayTest1_' testAng]);
    LiveAnt2 = read_complex_binary(['LiveArrayTest2_' testAng]);
    LiveAnt3 = read_complex_binary(['LiveArrayTest3_' testAng]);

    Ant0 = read_complex_binary(['ArrayTest0_' testAng]);
    Ant1 = read_complex_binary(['ArrayTest1_' testAng]);
    Ant2 = read_complex_binary(['ArrayTest2_' testAng]);
    Ant3 = read_complex_binary(['ArrayTest3_' testAng]);

    [LiveAnt0_cal,LiveAnt1_cal,LiveAnt2_cal,LiveAnt3_cal]= SignalCal(LiveAnt0,LiveAnt1,LiveAnt2,LiveAnt3,DataFolder,0);
    [Ant0_cal,Ant1_cal,Ant2_cal,Ant3_cal]= SignalCal(Ant0,Ant1,Ant2,Ant3,DataFolder,0);

    MusicAlg(LiveAnt0_cal,LiveAnt1_cal,LiveAnt2_cal,LiveAnt3_cal,ARVFile);
    MusicAlg(Ant0_cal,Ant1_cal,Ant2_cal,Ant3_cal,ARVFile);

end