%SignalCal - Signal Calibration
function [ant1cal,ant2cal,ant3cal,ant4cal] = SignalCal(ant1,ant2,ant3,ant4,DataFolder,plotOn)

    addpath(DataFolder);

    % Will be applied to input signals to bring signals into proper phase
    Ant1_broad = read_complex_binary(['ArrayTest0_0']);
    Ant2_broad = read_complex_binary(['ArrayTest1_0']);
    Ant3_broad = read_complex_binary(['ArrayTest2_0']);
    Ant4_broad = read_complex_binary(['ArrayTest3_0']);

    [row,~] = size(ant1);   % row => # of angles measured

    broadsideInd = round(row/2);

    ant1_FFT = fft(Ant1_broad(broadsideInd,:));
    [ant1a,ant1b] = max(abs(ant1_FFT));
    ant1_Phase = angle(ant1_FFT(ant1b));

    ant2_FFT = fft(Ant2_broad(broadsideInd,:));
    [ant2a,ant2b] = max(abs(ant2_FFT));
    ant2_Phase = angle(ant2_FFT(ant2b));

    ant3_FFT = fft(Ant3_broad(broadsideInd,:));
    [ant3a,ant3b] = max(abs(ant3_FFT));
    ant3_Phase = angle(ant3_FFT(ant3b));

    ant4_FFT = fft(Ant4_broad(broadsideInd,:));
    [ant4a,ant4b] = max(abs(ant4_FFT));
    ant4_Phase = angle(ant4_FFT(ant4b));

    % Now compensate for this phase shift for each channel
    ant1cal = ant1.*exp(-j*ant1_Phase);
    ant2cal = ant2.*exp(-j*ant2_Phase);
    ant3cal = ant3.*exp(-j*ant3_Phase);
    ant4cal = ant4.*exp(-j*ant4_Phase);

    % Compensate for amplitude differences (they should be equal). Make them
    % equal to ant1
    ant1cal = ant1a/ant1a*ant1cal;
    ant2cal = ant1a/ant2a*ant2cal;
    ant3cal = ant1a/ant3a*ant3cal;
    ant4cal = ant1a/ant4a*ant4cal;

    if plotOn
        figure
        plot(real(ant1cal))
        hold on
        plot(real(ant2cal))
        plot(real(ant3cal))
        plot(real(ant4cal))
        xlim([1000,1100])
        grid on
    end

end