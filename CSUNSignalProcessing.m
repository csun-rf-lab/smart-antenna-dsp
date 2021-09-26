clear; clc; close all;

addpath('/Users/morris/Documents/fall 21/seniordesign/Mark_s Code/ARVs');
addpath('/Users/morris/Documents/fall 21/seniordesign/Mark_s Code/txt files');

welcome = fileread('WelcomeDoc.txt');
fprintf(welcome);

options = fileread('OptionsDoc.txt');
select = input(options);

while (select ~= 0)
    
    if(select > 3)
        invalid = fileread('InvalidSelection.txt');
        select = input(invalid);
    end
    
    if(select == 1)
        ARVCreate = fileread('ARVCreationDoc.txt');
        fprintf(ARVCreate);
        while (select == 1)
            input('Please hit enter, then select your Data Set.');
            DataFolder = uigetdir('/home/captain/Desktop/SIGNAL PROCESSING PROGRAM/USRP_DATA', 'Select a USRP Data Set');
            Degree = fileread('DegreeInterval.txt');
            DegreeInterval = input(Degree);
            ARVCreation(DataFolder, DegreeInterval);
            ARVContinue = fileread('ARVContinue.txt');
            select = input(ARVContinue);
        end    
    end
    
    if(select == 2)
        Testing = fileread('TestingDoc.txt');
        fprintf(Testing);
        while (select == 2)
            input('Please hit enter, then select your ARV.');
            ARVFile = uigetfile('/home/captain/Desktop/SIGNAL PROCESSING PROGRAM/ARVs', 'Select ARV File');
            input('Please hit enter, then select your Data Set.');
            DataFolder = uigetdir('/home/captain/Desktop/SIGNAL PROCESSING PROGRAM/USRP_DATA', 'Select a USRP Data Set');
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
            
            [Ant0_cal, Ant1_cal, Ant2_cal, Ant3_cal] =...
            SignalCalGraph(Ant0, Ant1, Ant2, Ant3, DataFolder);
        
            [Angle] = MusicAlg(Ant0_cal, Ant1_cal, Ant2_cal, Ant3_cal, ARVFile);
            
            LMSBeam(Angle, ARVFile)
            
            rmpath(DataFolder);
            TestingContinue = fileread('TestingContinue.txt');
            select = input(TestingContinue);
        end
    end
end

goodbye = fileread('Goodbye.txt');
fprintf(goodbye);