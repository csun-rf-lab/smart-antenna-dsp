%Main file that creates ARV and calibration, runs MUSIC algorithm and calculates beamforming
%Sampling and processing live signal still to be done


%Add path to folder storing ARVs and text files which hold command line text
%interface information
clear; clc; close all;
addpath('ARVs');
addpath('txt files');

welcome = fileread('WelcomeDoc.txt');
fprintf(welcome);

options = fileread('OptionsDoc.txt');
select = input(options);

while (select ~= 0)
    %Creates ARV
    %Select data set from GNU Radio output
    %Specify angle increment
    if(select == 1)
        ARVCreate = fileread('ARVCreationDoc.txt');
        fprintf(ARVCreate);
        while (select == 1)
            input('Please hit enter, then select your Data Set.');
            DataFolder = uigetdir('../data', 'Select a USRP Data Set');
            Degree = fileread('DegreeInterval.txt');
            DegreeInterval = input(Degree);
            ARVCreation(DataFolder, DegreeInterval);
            ARVContinue = fileread('ARVContinue.txt');
            select = input(ARVContinue);
        end    
    end
    
    %Test and process previous USRP data
    %Requires ARV
    %Select angle to test from dataset
    if(select == 2)
        Testing = fileread('TestingDoc.txt');
        fprintf(Testing);
        while (select == 2)
            input('Please hit enter, then select your ARV.');
            ARVFile = uigetfile('ARVs', 'Select ARV File');
            input('Please hit enter, then select your Data Set.');
            DataFolder = uigetdir('../data', 'Select a USRP Data Set');
            addpath(DataFolder);
            SelectedAngle = input('Please select angle to test: ');
            
            file0 = "ArrayTest0_"+SelectedAngle;
            file1 = "ArrayTest1_"+SelectedAngle;
            file2 = "ArrayTest2_"+SelectedAngle;
            file3 = "ArrayTest3_"+SelectedAngle;
    
            Ant0 = read_complex_binary([file0]);
            Ant1 = read_complex_binary([file1]);
            Ant2 = read_complex_binary([file2]);
            Ant3 = read_complex_binary([file3]);
            
            %Create calibration graph
            [Ant0_cal, Ant1_cal, Ant2_cal, Ant3_cal] =...
            SignalCalGraph(Ant0, Ant1, Ant2, Ant3, DataFolder);
        
            %Find angle of arrival with MUSIC algorithm
            [Angle] = MusicAlg(Ant0_cal, Ant1_cal, Ant2_cal, Ant3_cal, ARVFile);
            
            %Beamforming calculations
            LMSBeam(Angle, ARVFile)
            
            rmpath(DataFolder);
            TestingContinue = fileread('TestingContinue.txt');
            select = input(TestingContinue);
        end
    end
    
    %Invalid selection
    if(select > 3)
        invalid = fileread('InvalidSelection.txt');
        select = input(invalid);
    end
end

goodbye = fileread('Goodbye.txt');
fprintf(goodbye);