function [ARV, Cal] = createARV(interval)
    
    addpath(uigetdir('/data', 'Select a USRP Data Set'));
    ant0_0 = read_complex_binary("ArrayTest0_0");
    ant1_0 = read_complex_binary("ArrayTest1_0");
    ant2_0 = read_complex_binary("ArrayTest2_0");
    ant3_0 = read_complex_binary("ArrayTest3_0");
    
    figure
    hold on
    plot(10:30,ant0_0(10:30));
    plot(10:30,ant1_0(10:30));
    plot(10:30,ant2_0(10:30));
    plot(10:30,ant3_0(10:30));
    legend('ant0','ant1','ant2','ant3');
    title('Broadside Antenna Signals');
    
    a0_fft = fft(ant0_0);
    [m, i] = max(abs(a0_fft));
    a0_phase = angle(a0_fft(i));
    
    a1_fft = fft(ant1_0);
    [m, i] = max(abs(a1_fft));
    a1_phase = angle(a1_fft(i));
    
    a2_fft = fft(ant2_0);
    [m, i] = max(abs(a2_fft));
    a2_phase = angle(a2_fft(i));
    
    a3_fft = fft(ant3_0);
    [m, i] = max(abs(a3_fft));
    a3_phase = angle(a3_fft(i));
    
    a1_phase_diff = a1_phase - a0_phase;
    a2_phase_diff = a2_phase - a1_phase;
    a3_phase_diff = a3_phase - a1_phase;
    
    ARV = zeros(floor(181/interval),4);
    
    for i=-90:interval:90
        ant0 = read_complex_binary("ArrayTest0_" + (-90+interval) );
        ant1 = read_complex_binary("ArrayTest1_" + (-90+interval) );
        ant2 = read_complex_binary("ArrayTest2_" + (-90+interval) );
        ant3 = read_complex_binary("ArrayTest3_" + (-90+interval) );
        
%         a0_fft = fft(ant0_0);
%         [m, i] = max(abs(a0_fft));
%         a0_phase = angle(a0_fft(i))*180/pi;
% 
%         a1_fft = fft(ant1_0);
%         [m, i] = max(abs(a1_fft));
%         a1_phase = angle(a1_fft(i))*180/pi;
% 
%         a2_fft = fft(ant2_0);
%         [m, i] = max(abs(a2_fft));
%         a2_phase = angle(a2_fft(i))*180/pi;
% 
%         a3_fft = fft(ant3_0);
%         [m, i] = max(abs(a3_fft));
%         a3_phase = angle(a3_fft(i))*180/pi;

        figure
        hold on
        plot(10:30,ant0(10:30));
        plot(10:30,ant1(10:30));
        plot(10:30,ant2(10:30));
        plot(10:30,ant3(10:30));
        legend('ant0','ant1','ant2','ant3');
        title('-90 Antenna Signals');
        
        ant1 = ant1*exp(-1i*a1_phase_diff);
        ant2 = ant2*exp(-1i*a2_phase_diff);
        ant3 = ant3*exp(-1i*a3_phase_diff);
        
        figure
        hold on
        plot(10:30,ant0(10:30));
        plot(10:30,ant1(10:30));
        plot(10:30,ant2(10:30));
        plot(10:30,ant3(10:30));
        legend('ant0','ant1','ant2','ant3');
        title('-90 Calibrated Antenna Signals');
        
        
    end
    
end
