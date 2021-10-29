
close all; clear all; clc;

addpath('/Users/seniordesign/Documents/USRP_DATA') %This is where the Testing Files Should be saved
addpath('/Users/seniordesign/Documents/MATLAB/SIGNAL_PROCESSING_PROGRAM/SIGNAL_PROCESSING_PROGRAM/txt_files');


gnuFileName = '/ArrayTest3_Test.py';
gnuFilePath = '/Users/seniordesign/Documents/MATLAB/PositionControl-master/PositionControl-master/USRP';
takeMeasurementCommand = ['/opt/local/bin/python2.7 ' gnuFilePath gnuFileName ];
 
[~,usrpMeasurement] = system(takeMeasurementCommand)

input('Please hit enter, then select your Data Set.');
DataFolder = uigetdir('/Users/seniordesign/Documents/MATLAB/SIGNAL_PROCESSING_PROGRAM/SIGNAL_PROCESSING_PROGRAM/USRP_DATA/'); 

input('Please hit enter, then select your ARV.');
ARVFile = uigetfile('/Users/seniordesign/Documents/MATLAB/Signal_Processing_2', 'Select ARV File');

LiveAnt0 = read_complex_binary(['LiveArrayTest0']);
LiveAnt1 = read_complex_binary(['LiveArrayTest1']);
LiveAnt2 = read_complex_binary(['LiveArrayTest2']);
LiveAnt3 = read_complex_binary(['LiveArrayTest3']);

Ant0 = read_complex_binary(['ArrayTest0_']);
Ant1 = read_complex_binary(['ArrayTest1_']);
Ant2 = read_complex_binary(['ArrayTest2_']);
Ant3 = read_complex_binary(['ArrayTest3_']);

[LiveAnt0_cal,LiveAnt1_cal,LiveAnt2_cal,LiveAnt3_cal]= SignalCal(LiveAnt0,LiveAnt1,LiveAnt2,LiveAnt3,DataFolder,0);
[Ant0_cal,Ant1_cal,Ant2_cal,Ant3_cal]= SignalCal(Ant0,Ant1,Ant2,Ant3,DataFolder,0);

MusicAlg(LiveAnt0_cal,LiveAnt1_cal,LiveAnt2_cal,LiveAnt3_cal,ARVFile);
MusicAlg(Ant0_cal,Ant1_cal,Ant2_cal,Ant3_cal,ARVFile);

