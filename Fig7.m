clear all;close all;clc;



% 12/09/2018 by Yorie Nakahira 
% updated 31/08/2020 by Quanying Liu
% Generate figure 7 in PNAS journal 2020
% showing diversity between layers are beneficial 

myfsize = 25;
linewidth = 4;
myname = 'helvetica';

%% non-uniform 

lambda1 = 0.1;  % lower layer
lambda2 = 0.1;  % higher layer
n = 1000;                    % varying number of neurons 
m = 1000;                    % for all T
ll = 100; Ta_max = 20;         % number/range of Ti to test
Ta_all = linspace(1,Ta_max,ll);  %
CostFinalH = zeros(1,ll);CostFinalU = zeros(1,ll);   % cost for each Ti
OptT = zeros(3,ll);OptR = zeros(3,ll);   % cost for each Ti

Tmin = 0.1;Tmax = 50;       % range of delay to search over 

epsilon = 1;
for index_Ta = 1:ll
    
    T_l = 10;  % delay in the lower layer
    T_h = Ta_all(index_Ta);  % advanced warning in the higher layer
    Trange = linspace(Tmin,Tmax,m);
    
    % diverse case
    Rrange = lambda1 * Trange;    % lower layer: equation 2 in the paper
    total_cost1 = max([zeros(1,m);Trange+T_l]) + 1./(2.^Rrange - 1);  % lower layer with delay
    [value1,index] = min(total_cost1); % find optimal T and R for lower layer
    OptT(1,index_Ta) = Trange(index);
    OptR(1,index_Ta) = Rrange(index);
    
    Rrange = lambda2 * Trange;    % higher layer: equation 2 in the paper
    total_cost2 = max([zeros(1,m);Trange-T_h]) + 1./(2.^Rrange - 1);  % higher layer with advanced warning
    [value2,index] = min(total_cost2); % find optimal T and R for higher layer
    OptT(2,index_Ta) = Trange(index);
    OptR(2,index_Ta) = Rrange(index);
    
    CostFinalH(index_Ta) = epsilon*value1 + value2; % diverse: equation 6 in the paper
                    
    % uniform case
    lambda = (lambda1+lambda2)/2;
    Rrange = lambda * Trange;  
    total_cost3 = epsilon*(max([zeros(1,m);Trange+T_l]) + 1./(2.^Rrange - 1)) + max([zeros(1,m);Trange-T_h]) + 1./(2.^Rrange - 1);
    [value3,index] = min(total_cost3);
    OptT(3,index_Ta) = Trange(index);
    OptR(3,index_Ta) = Rrange(index);
    CostFinalU(index_Ta) = value3;  % uniform
end
            

%%%% plot with axis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% fig7B
figure;
plot(Ta_all,CostFinalH,'k',Ta_all,CostFinalU,'k--','LineWidth',4);
ylim([16,24]);
set(gca,'fontsize', myfsize, 'FontName', myname);
xlim([1,20])
%% fig7A
figure;
hold on
yyaxis left 
% b- for lower level; b: for higher level
plot(Ta_all,OptT(1,:),'b-', Ta_all,OptT(2,:),'b:', 'LineWidth',4)
set(gca,'fontsize', myfsize, 'FontName', myname,'YColor','k','Layer', 'top');
xlim([1,Ta_max])
yyaxis right
% r- for lower level; r: for higher level
plot(Ta_all,OptR(1,:),'r-', Ta_all,OptR(2,:),'r:', 'LineWidth',4);
ylim([0,4]);
set(gca,'fontsize', myfsize, 'FontName', myname,'YColor','k');

hold off



% %%%% plot with axis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% figure;hold on;
% %subplot(211);
% plot(Ta_all,CostFinalH,'k',Ta_all,CostFinalU,'k--','LineWidth',4);
% ylabel('Total cost');
% xlabel('Advanced warning');
% %legend('Diverse','Uniform')
% % plot(QuantCostH,DelayLimit,'k',QuantCostU,DelayLimit,'k--','LineWidth',4);
% % h=text(11, 20.2, 'Uniform', 'Color', [0 0 0], 'FontSize', myfsize, 'FontName', myname);
% % h=text(11, 17.4, 'Diverse', 'Color', [0 0 0], 'FontSize', myfsize, 'FontName', myname);
% set(findall(gcf,'-property','FontSize'),'FontSize',myfsize);
% ylim([17,22]);
% % xlim([1,20]);
% set(gca,'fontsize', myfsize, 'FontName', myname);
% hold off;
% 
% %figure;
% %plot(Ta_all,CostFinalH./CostFinalU,'LineWidth',4);



% figure;
% hold on
% yyaxis left
% plot(Ta_all,OptT(1,:),'b-',Ta_all,OptT(2,:),'b:','LineWidth',4)
% xlabel('Advanced warning');
% ylabel('Optimal delay');xlim([1,20])
% yyaxis right
% plot(Ta_all,OptR(1,:),'r--',Ta_all,OptR(2,:),'r-.','LineWidth',4);
% ylim([0,4]);ylabel('Optimal data rate');
% % h=text(15, 1, 'Tl','Color', [0 0 0], 'FontSize', myfsize, 'FontName', myname,'interpreter','latex');
% % h=text(15, 3, 'Th', 'Color', [0 0 0], 'FontSize', myfsize, 'FontName', myname,'interpreter','latex');
% %legend('T_l','T_h','R_l','R_h','interpreter','latex')
% set(findall(gcf,'-property','FontSize'),'FontSize',myfsize);
% set(gca,'fontsize', myfsize, 'FontName', myname);
% %xlim([0,20]);ylim([0,2]);


