function [] = LMSBeam(Angle, ARVFilename)
%LMSBeam will output the plots for the Magnitude of Array Weights,
%Acquisition and tracking of the desired signal, Mean Squared Error, and
%the Weighted LMS Array, the function can only have 4 inputs
%Inputs:
%the angle data that is already read in matlab(i.e Ant0_0, Ant0_1...)
%wavelength (d)

d=.5;
ARV = importdata(ARVFilename); %Import ARV data from music script

N=4; %N=number of inputs
thetaS  = Angle;
thetaI1 = -80;

%----- Desired Signal & Interferer -----%
T=1E-3;
t=(1:100)*T/100;
it=1:100;
S=cos(2*pi*t/T);
I = randn(1,100); 

thetaS=thetaS*pi/180;
thetaI=thetaI1*pi/180;

%----- Create Array Factors for each user's signal for linear array -----%

vS = []; vI = [];
i=1:N;
vS=exp(1j*(i-1)*2*pi*d*sin(thetaS)).';
vI=exp(1j*(i-1)*2*pi*d*sin(thetaI)).';

%----- Solve for Weights using LMS -----%
w = zeros(N,1); 
snr = 10; % signal to noise ratio
X=(vS+vI);   % Vector of desired and undesired angles
Rx=X*X';     % Matrix of the vetor times its tranpose?
mu=1/(4*real(trace(Rx)));
%mu is stepsize (maybe an input)
wi=zeros(N,max(it));


for n = 1:length(S)
x = S(n)*vS + I(n)*vI;
%y = w*x.';
y=w'*x;

e = conj(S(n)) - y; esARVe(n) = abs(e)^2;
% w = w +mu*e*conj(x);
w=w+mu*conj(e)*x;
wi(:,n)=w;
yy(n)=y;

end
w = (w./w(1));% normalize results to first weight

%----- Plot Results -----%

theta = -pi/2:.01:pi/2;
AF = zeros(1,length(theta));
% Determine the array factor for linear array

for i = 1:N
    AF = AF + w(i)'.*exp(1j*(i-1)*2*pi*d*sin(theta));
end
% AF1 = zeros(1,length(theta));
% 
% for i = 1:N
% AF1 = AF1 + w1(i)'.*exp(1j*(i-1)*2*pi*d*sin(theta));
% end
figure
plot(theta*180/pi,20*log10(abs(AF)/max(abs(AF))),'k')
title('LMS Beamform');
xlabel('AOA (deg)')
ylabel('dB')
axis([-90 90 -30 0])
set(gca,'xtick',[-90 -60 -30 0 30 60 90])
grid on

% figure;
% plot(it,S,'k',it,yy,'k--')
% xlabel('No. of Iterations')
% ylabel('Signals')
% legend('Desired signal','Array output')
% 
% disp('%------------------------------------------------------------------------%')
% disp(' ')
% disp(['   The weights for the N = ',num2str(N),' ULA are:'])
% disp(' ')
% for m = 1:length(w)
%     disp(['   w',num2str(m),' = ',num2str(w(m))])
% end
% disp(' ')
% 
% figure;plot(it,abs(wi(1,:)),'kx',it,abs(wi(2,:)),'ko',it,abs(wi(3,:)),'ks',it,abs(wi(4,:)),'k+','markersize',2)
% xlabel('Iteration no.')
% ylabel('|weights|')
% figure;plot(it,esARVe,'k')
% xlabel('Iteration no.')
% ylabel('Mean square error')
% end
% 
