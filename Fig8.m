%clear all;close all;clc;

% plot parameters 
FS = 25;
linewidth = 4;
myname = 'helvetica';


%% generate data %%%%%%%%%%%%%%%%


lambda = 0.1;
n = 100;                       % delay cost index 
m = 100;                       % for all T
ll = 100;level = 20;             % number/range of Ti to test
%Ti_all = linspace(10,level,ll);
CostFinalH = zeros(1,ll);CostFinalU = zeros(1,ll);      % cost for each Ti
OptT = zeros(3,ll);OptR = zeros(3,ll);                  % cost for each Ti

%%%%%%%%%% to change plot range %%%%%%%%%%%%%%%%
DelayLimit = linspace(0.1,50,n);
Ta = 10;   % advanced warning: Ta = 20 for bike, Ta=10 for visual
Ti = 10;   % internal delay:   Ti = 0 for bike; Ti=10 for visual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


QuantCostU = zeros(1,n);
QuantCostH = zeros(1,n);
Tmin = 0.1;Tmax = 50;            % range of delay to search over 
Trange = linspace(Tmin,Tmax,m);
Rrange = lambda * Trange;

delay_cost1 = max([zeros(1,m);Trange+Ti]); 
qunat_cost1 = 1./(2.^Rrange - 1);
delay_cost2 = max([zeros(1,m);Trange-Ta]);
qunat_cost2 = 1./(2.^Rrange - 1);

[D1,D2] = meshgrid(delay_cost1,delay_cost2);
[Q1,Q2] = meshgrid(qunat_cost1,qunat_cost2); 

% heterogeneous 
for index = 1:n

    FixDelay = ( D1+D2 >= DelayLimit(index)); 

    Value = (Q1+Q2)+FixDelay*1000;
    QuantCostH(index) = min(min(Value));

end

D = delay_cost1+delay_cost2;
Q = qunat_cost1+qunat_cost2;


for index = 1:n

    FixDelay = ( D >= DelayLimit(index)); 

    Value = Q+FixDelay*1000;
    QuantCostU(index) = min(min(Value));

end

%% plots %%%%%%%%%%%%%%%%


% normal 
Figure = figure('color', [1 1 1]);
subplot(111); hold on;
plot(QuantCostH,DelayLimit,'k',QuantCostU,DelayLimit,'k--','LineWidth',linewidth);
%legend('Diverse','Uniform');
%xlabel('Quantization cost');
%ylabel('Delay cost')
set(findall(gcf,'-property','FontSize'),'FontSize',FS);
set(gca,'fontsize', FS, 'FontName', myname);
hold off



%%%%%%%%%% to change plot range %%%%%%%%%%%%%%%%
axis([2 10 12 20]) % for visual
%axis([2 10 2 10])  % for bike
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 
% % loglog
% figure;
% loglog(QuantCostH,DelayLimit,'k',QuantCostU,DelayLimit,'k--','LineWidth',4);
% legend('Diverse','Uniform');
% xlabel('Quantization cost');
% ylabel('Delay cost')
% 
% 
% 
% %%%%%%%%%% to change plot range %%%%%%%%%%%%%%%%
% axis([1 3.5 5 7])
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% % semilogy
% figure;
% semilogy(QuantCostH,DelayLimit,'k',QuantCostU,DelayLimit,'k--','LineWidth',4);
% legend('Diverse','Uniform');
% xlabel('Quantization cost');
% ylabel('Delay cost')




%%%%%%%%%% to change plot range %%%%%%%%%%%%%%%%
%axis([1 3.5 5 7])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%