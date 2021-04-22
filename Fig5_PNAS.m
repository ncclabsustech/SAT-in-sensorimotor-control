clear

folder = '/media/lzc/LIU32G/WheelCon_experiment/'; % define the path of data
cd(folder);

file_names{1} = [folder 'sub101/sub101_SAT_trail_2_20181211055431.txt'];
file_names{2} = [folder 'sub102/sub102_SAT_trail_2_20181213053727.txt'];
file_names{3} = [folder 'sub103/sub103_SAT_trail_3_20181213070308.txt'];
file_names{4} = [folder 'sub104/sub104_SAT_trail_2_20181215013536.txt'];


for sub=1:4
    
    [Linf_error_block(:,:,sub), MSE_error_block(:,:,sub)]  = code_SAT_trail_PNAS(file_names{sub});

end

colors = {'r', 'b',' k'};

Figure = figure('color',[1 1 1]);
set(Figure, 'Position', [100 100 600 500])
FN = 'Helvetica'; % 'Times New Roman';
for ii=1:3
    mean_sub = mean(Linf_error_block(1:7,ii,:),3);
    ste_sub =  std( squeeze(Linf_error_block(1:7,ii,:))' )'./sqrt(4);
    plot([1:7], mean_sub, [colors{ii} '-o'], 'LineWidth', 2); hold on; 
    h = fill([1:7 7:-1:1], [mean_sub-ste_sub; mean_sub(7:-1:1)+ste_sub(7:-1:1)], colors{ii}); alpha 0.1
    set(h, 'EdgeColor','None');
end
set(gca,'fontsize', 20);  set(gcf, 'color', 'w');
xlabel('R (bit)');  ylabel('L_{inf} error');

%print('-dpng',['Fig3B.png']);




Figure = figure('color',[1 1 1]);
set(Figure, 'Position', [100 100 600 500])
FN = 'Helvetica'; % 'Times New Roman';


myfittype = fittype('error_delay(T, Tin, b, d)',...
    'dependent',{'ft'},'independent',{'T'},...
    'coefficients',{'Tin', 'b', 'd'});  % error_delay = b*(T+Tin)+d
T = [1:7]'; ft = mean(Linf_error_block(1:7,2,:),3);  % -0.8:0.2:0.4
myfit_T = fit(T, ft, myfittype, 'StartPoint', [-2, 2, 0.1] )
Tin = myfit_T.Tin
b = myfit_T.b
d = myfit_T.d

i=1; clear ft
for t=[1:0.01:7]
    ft(i) = error_delay(t, Tin, b, d);
    i = i+1;
end
plot([1:0.01:7], ft, 'b-', 'LineWidth', 2); hold on;


% fit the quantizer error
myfittype = fittype('a/(2^(R)-1)+c',...
    'dependent',{'fr'},'independent',{'R'},...
    'coefficients',{'a','c'});

myfittype = fittype('a/(2^(R)-1)',...
    'dependent',{'fr'},'independent',{'R'},...
    'coefficients',{'a'});

R = [1:7]'; fr = mean(Linf_error_block(1:7,1,:),3);
myfit_R = fit(R, fr, myfittype, 'StartPoint', [5] )
a = myfit_R.a
% myfit_R = fit(R, fr, myfittype, 'StartPoint', [5, 1] )
% a = myfit_R.a
% c = myfit_R.c
i=1;
for r=1:0.01:7
    fr(i) = a/(2^(r)-1);
    i = i+1;
end
plot([1:0.01:7], fr, 'r-', 'LineWidth', 2);

plot([1:0.01:7], ft+fr', 'k-', 'LineWidth', 2);

ylim([0 15]);
set(gca,'fontsize', 20);  set(gcf, 'color', 'w');
xlabel('R (bit)');  ylabel('L_{inf} error');

%print('-dpng',['Fig3A.png']);





% fit the delay error
% function ft = error_delay(T, b, d)
%     
%     if T+2<=0  % delay is smaller than intrinsic delay 
%         ft = d;
%     else
%         ft = b*(T+2)+d;
%     end
% end



function ft = error_delay(T, Tin, b, d)
    
    if T+Tin<=0  % delay is smaller than intrinsic delay 
        ft = d;
    else
        ft = b*(T+Tin)+d;
    end
    
end