%% TITLE: kappakohler.m
% 
%
% PURPOSE: Uses kappa-Kohler theory (Petters & Kreidenweis, 2007) to solve
% for specified hygroscopicity variables (kappa, critical diameter,
% critical supersaturation, and maximum supersaturation). 
% 
% 
% INPUTS: supersat_IN: supersaturation (%; e.g. 0.1% = 100.1%
%                      supersaturation)
%
%         Dcrit_IN: critical diameter (micrometers)
%
%         kappa_IN: hygroscopicity parameter (-)
%           
%         opt_IN: option of varaible(s) for which to solve (numeric value)
%         1 = get supersaturation from critical diameter and kappa
%         2 = get critical diameter from kappa and supersaturation
%         3 = get kappa from critical diameter and supersaturation 
%         4 = calculate maximum supersaturation from a critical diameter 
%             using numerical maximization search. (e.g. Kruger et al., 
%             2014; doi:10.5194/amt-7-2615-2014)
%           
%         if a variable input is not needed for a specific solution,
%         enter NaN. An opt_IN must be inlcuded or the output will be NaN.
% 
%
% OUTPUTS: specified hygroscopicity variable
%
%
% AUTHOR: Jeramy Dedrick
%         Scripps Institution of Oceanography, La Jolla, CA
%         May 1, 2023


function [OUT] = kappakohler(supersat_IN, ...
                             Dcrit_IN, ...
                             kappa_IN, ...
                             opt_IN)
                                              

% options
% 1 = get supersaturation from critical diameter and kappa
% 2 = get critical diameter from kappa and supersaturation
% 3 = get kappa from critical diameter and supersaturation 
% 4 = calculate maximum supersaturation from a critical diameter using
%     numerical maximization search. (e.g. Kruger et al., 2014;
%     doi:10.5194/amt-7-2615-2014)

% size of inputs
N_size = length(supersat_IN);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% kappa-Kohler constants (Seinfeld & Pandis, 2016) %%%%%%%%%%%%%

sig = 0.0728;       % surface tension of pure water (N/m^2)
Mw  = 18 * (1e-3);  % molecular weight of water (kg/mol)
R   = 8.314;        % universal gas constant (J/mol/K)
Rv  = 461;          % gas constant for vapor (J / K / kg)
rho = 1e3;          % density of water (kg/m^3)
T   = 298.15;       % absolute temperature (K) 

A   = ( (4 * sig * Mw) / (rho * R * T) ); % A term consolidation
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% OPTION 1: get supersaturation from critical diameter and kappa
if opt_IN == 1
    
    for ii = 1:N_size
        
        OUT(ii) = log( sqrt( (4 ./ (27 .* kappa_IN(ii) .* (Dcrit_IN(ii) .* (1e-6)).^3)) .* ...
                        (A.^3) ) + 1) .* 100;     
        
    end
    
    
    
% OPTION 2: get critical diameter from kappa and supersaturation
elseif opt_IN == 2
    
    for ii = 1:N_size
        
        OUT(ii) = (( (4 .* A.^3) ./ ...
                        (27 .* kappa_IN(ii) .* (log((supersat_IN(ii) ./ 100) + 1).^2)) ) .^(1/3)) .* (1e6);    

    end
    
    
    
% OPTION 3: get kappa from critical diameter and supersaturation   
elseif opt_IN == 3
                   
    for ii = 1:N_size
        
        OUT(ii) = (4 .* A.^3) ./ ...
                        (27 .* ((Dcrit_IN(ii) .* (1e-6)).^3) .* (log((supersat_IN(ii) ./ 100) + 1).^2));    
                
    end
    
    
    
% OPTION 4: calculate maximum supersaturation from a critical diameter using
%           numerical maximization search. 
elseif opt_IN == 4
                   
    for ii = 1:N_size
        
        % convert guess diameter from micron to meters
        guess_D = Dcrit_IN(ii) .* (1e-6);
        
        kappa   = kappa_IN(ii);
        
        % kappa-Kohler function (for maximization)
        kappakohlefun = @(x) (((x.^3 - (guess_D).^3) ./ ...
               (x.^3 - ((guess_D).^3 .* (1 - kappa)))) .* ...
               exp(A./x)) .* (-1);
        
        % wet diameter at maximum kappa-Kohler supersaturation and kappakohlerfun
        % solved at max diameter
        [Dwet, SS_val] = fminsearch(kappakohlefun, guess_D);

        % convert wet diameter to micron
        Dwet_OUT = Dwet .* (1e6);

        % cloud-base supersaturation
        supersat_OUT = ((SS_val .* -1) - 1) .* 100;
        
        OUT(ii,:) = supersat_OUT; 
             
    end  
    
   
    
% no option selected    
else

    OUT = NaN;
    
    disp('No option selected')
    
end



end