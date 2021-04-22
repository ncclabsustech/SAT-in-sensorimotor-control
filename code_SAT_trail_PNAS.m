function MSE_error_block = code_SAT_trail_PNAS(file_names)

M = dlmread(file_names,',',1,0); 

t = M(:,1);
trail = M(:,2);
bump = M(:,3);
quant_act = M(:,4);  
delay_act = M(:,5);   
delay_vis = M(:,6);  
quant_vis = M(:,7);  

error = M(:,8);  
control = M(:,9);  


T = 30;     % the time for each block

block = floor(max(t)/T);
inf_error_block = zeros(block,1);
inf_error_block_2s = zeros(block,1);

for ii=1:block
    sel = find(t>(ii-1)*T+9 & t<=ii*T-1);
    inf_error_block(ii) = max(abs(error(sel)));
    L1_error_block(ii) = mean(abs(error(sel)));
    L2_error_block(ii) = sqrt(mean(error(sel).^2));
    
    inf_u_block(ii) = max(abs(control(sel)));
    L1_u_block(ii) = mean(abs(control(sel)));
    L2_u_block(ii) = sqrt(mean(control(sel).^2));
    
    for jj=1:10
        sel = find(t>(ii-1)*T+9+2*(jj-1) & t<=(ii-1)*T+9+2*jj);
        inf_error_block_2s(ii,jj) = max(abs(error(sel)));
        inf_control_block_2s(ii,jj) = max(abs(control(sel)));
    end
    
    
end


% L2 error
internal_error = min(L2_error_block);

MSE_error_block(:,1) = L2_error_block(1:7)-internal_error;  % Quant
MSE_error_block(:,2) = L2_error_block(8:14)-internal_error; % delay
MSE_error_block(:,3) = L2_error_block(15:21)-internal_error;  % both
