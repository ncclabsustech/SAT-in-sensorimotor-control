clear all;close all;clc;

% 12/09/2018 by Yorie Nakahira 
% updated 31/08/2020 by Quanying Liu
% Generate figure 6 in PNAS journal 2018
% Plot delay/warning versus L-infinity cost (mode = 1)
% Plot delay/warning versus optimal delay/data rate (mode = 2)

% content 
%mode = 1; % for fig.6A
mode = 2; % for fig.6B


% plot parameters
myfsize = 25;linewidth = 4;
yrange = [0.1,100];
yrange2 = [-0.1,15];
myname = 'helvetica';

% search parameter 
n = 1000;    
T = linspace(0,10,n);   % signaling delay
lambda = 0.1;            % lambda*T = R

%% fig 6.a
% plot range: delayed system  

tau =linspace(-10,0,n);  % advanced warning
c = tau;c1 = c;c2 = c;Top = c;Ropt = c;Tnet = c;

for ii = 1:length(tau)

    x1 = max(0,T - tau(ii));            % delay cost 
    x2 = 1./( (2.^(lambda*T)) -1 );      % quantization cost 
    x = x1+x2;
    
    [c(ii),index] = min(x);
    c1(ii) = x1(index);c2(ii) = x2(index);
    Topt(ii) = T(index);Ropt(ii) = Topt(ii)*lambda;
    Tnet(ii) = Topt(ii)-tau(ii);
end

if mode == 1
figure;semilogy(-tau,c1,'b-.',-tau,c2,'r:',-tau,c,'k','Linewidth',linewidth);set(gca,'fontsize',myfsize,'fontname',myname);
set(gca,'xdir','reverse')
%ylabel('Worst-case error');
%xlabel('Net delay');
%ylabel('Worst case error','Interpreter','latex');
%xlabel('Net delay: $T_i-T_a$','Interpreter','latex');
ylim(yrange);
else
figure;plot(-tau,Topt,'b-.',-tau,Ropt,'r:',-tau,Tnet,'k','Linewidth',linewidth);set(gca,'fontsize',myfsize,'fontname',myname);
set(gca,'xdir','reverse')
%ylabel('Optimal parameter')
%xlabel('Net delay')
% ylabel('Optimal parameter','Interpreter','latex');
% xlabel('Net delay: $T_i-T_a$','Interpreter','latex');
ylim(yrange2);
end



%% plot range: warned system 
clear Topt; clear Ropt;
tau =linspace(0,10,n);  % advanced warning
c = tau;c1 = c;c2 = c;Top = c;Ropt = c;

for ii = 1:length(tau)

    x1 = max(0,T - tau(ii));            % delay cost 
    x2 = 1./( (2.^(lambda*T)) -1 );      % quantization cost 
    x = x1+x2;
    
    [c(ii),index] = min(x);
    c1(ii) = x1(index);c2(ii) = x2(index);
    Topt(ii) = T(index);Ropt(ii) = Topt(ii)*lambda;
    Tnet(ii) = Topt(ii)-tau(ii);
end
index
x
Topt
if mode == 1
figure;semilogy(tau,c1,'b-.',tau,c2,'r:',tau,c,'k','Linewidth',linewidth);
set(gca,'fontsize',myfsize);
set(gca, 'YAxisLocation', 'right','fontname',myname);%set(gca,'ytick',[]);
%xlabel('Net warning');
ylim(yrange);
else
figure;plot(tau,Topt,'b-.',tau,Ropt,'r:',tau,Tnet,'k','Linewidth',linewidth);
set(gca,'fontsize',myfsize);
set(gca, 'YAxisLocation', 'right','fontname',myname);
ylim(yrange2);
end



