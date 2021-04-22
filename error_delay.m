
function ft = error_delay(T, Tin, b, d)
    
    if T+Tin<=0  % delay is smaller than intrinsic delay 
        ft = d;
    else
        ft = b*(T+Tin)+d;
    end
    
end