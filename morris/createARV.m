function [] = createARV(interval)

    addpath(uigetdir('/data', 'Select a USRP Data Set'));

    
    ant0_0 = read_complex_binary("ArrayTest0_0");
    ant1_0 = read_complex_binary("ArrayTest1_0");
    ant2_0 = read_complex_binary("ArrayTest2_0");
    ant3_0 = read_complex_binary("ArrayTest3_0");
    
%     figure
%     hold on
%     plot(1:30,ant0_0(1:30));
%     plot(1:30,ant1_0(1:30));
%     plot(1:30,ant2_0(1:30));
%     plot(1:30,ant3_0(1:30));
%     legend('ant0','ant1','ant2','ant3');
%     title('Broadside Antenna Signals');
    
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
    
    ARV = [];
    
    angles = -90:interval:90;
    for i=1:length(angles)
        ant0 = read_complex_binary("ArrayTest0_" + angles(i) );
        ant1 = read_complex_binary("ArrayTest1_" + angles(i) );
        ant2 = read_complex_binary("ArrayTest2_" + angles(i) );
        ant3 = read_complex_binary("ArrayTest3_" + angles(i) );
        
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

%         figure
%         hold on
%         plot(1:30,ant0(1:30));
%         plot(1:30,ant1(1:30));
%         plot(1:30,ant2(1:30));
%         plot(1:30,ant3(1:30));
%         legend('ant0','ant1','ant2','ant3');
%         title('-90 Antenna Signals');
       
        ant0 = ant0*exp(-1i*a0_cal_phase);
        ant1 = ant1*exp(-1i*a1_cal_phase);
        ant2 = ant2*exp(-1i*a2_cal_phase);
        ant3 = ant3*exp(-1i*a3_cal_phase);
        
        ant0 = m0_cal/m0_cal*ant1;
        ant1 = m0_cal/m1_cal*ant1;
        ant2 = m0_cal/m2_cal*ant2;
        ant3 = m0_cal/m3_cal*ant3;
        
%         figure
%         hold on
%         plot(1:30,ant0(1:30));
%         plot(1:30,ant1(1:30));
%         plot(1:30,ant2(1:30));
%         plot(1:30,ant3(1:30));
%         legend('ant0','ant1','ant2','ant3');
%         title('-90 Calibrated Antenna Signals');
        
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
       
        ARV(i,1)= m0*exp(1i*a0_phase);
        ARV(i,2)= m1*exp(1i*a1_phase);
        ARV(i,3)= m2*exp(1i*a2_phase);
        ARV(i,4)= m3*exp(1i*a3_phase);
        
        display("Calculating ARV for angle " + angles(i));
    end
    
    ARV = ARV./max(max(abs(ARV)));
    date = datestr(now, 'mmmm-dd-yyyy');
    FILENAME = "ARV_"+date+".mat";
    matfile = fullfile('C:\Users\Morris\Documents\Fall 21\ECE 492\smart-antenna-dsp\morris\ARVs', FILENAME);
    save(matfile, 'ARV');
end
