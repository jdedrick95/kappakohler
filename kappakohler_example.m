%% TITLE: kappakohler_example.m
% 
% PURPOSE: Example code for using the kappakohler.m function.
% 
% INPUTS: None.
%
% AUTHOR: Jeramy Dedrick
%         Scripps Institution of Oceanography, La Jolla, CA
%         March 15, 2024

clear all; close all; clc



%% Option 1: get supersaturation from critical diameter and kappa

% input parameters
supersat_IN = NaN;   % don't know supersaturation
Dcrit_IN    = 0.10;  % critical diameter of 0.1 micron (100 nm)
kappa_IN    = 0.25;  % kappa value of 0.25
opt_IN      = 1;     % want the first option (critical supersaturation)

OUT = kappakohler(supersat_IN, ...
                  Dcrit_IN, ...
                  kappa_IN, ...
                  opt_IN);

disp(strcat('Critcal supersaturation = ', num2str(round(OUT,2)), '%'))
 


%% Option 2: get critical diameter from kappa and supersaturation

% input parameters
supersat_IN = 0.3;   % 0.3% supersaturation
Dcrit_IN    = NaN;   % don't know critical diameter
kappa_IN    = 0.25;  % kappa value of 0.25
opt_IN      = 2;     % want the second option (critical diameter)

OUT = kappakohler(supersat_IN, ...
                  Dcrit_IN, ...
                  kappa_IN, ...
                  opt_IN);

disp(strcat('Critcal diameter = ', num2str(round(OUT,3)), ' micrometers'))
 


%% Option 3: get kappa from critical diameter and supersaturation 

% input parameters
supersat_IN = 0.3;   % 0.3% supersaturation
Dcrit_IN    = 0.1;   % critical diameter of 0.1 micron (100 nm)
kappa_IN    = NaN;   % don't know kappa
opt_IN      = 3;     % want the third option (kappa)

OUT = kappakohler(supersat_IN, ...
                  Dcrit_IN, ...
                  kappa_IN, ...
                  opt_IN);

disp(strcat('kappa = ', num2str(round(OUT,2))))



%% Option 4: calculate the maximum peak of a Kohler curve using numerical search for maximum 

% input parameters
supersat_IN = NaN;   % don't know peak of Kohler curve supersaturation
Dcrit_IN    = 0.1;   % this is a guess diameter to start numerical search
kappa_IN    = 0.25;  % kappa
opt_IN      = 4;     % want the fourth option (maximum peak in Kohler curve)

OUT = kappakohler(supersat_IN, ...
                  Dcrit_IN, ...
                  kappa_IN, ...
                  opt_IN);

disp(strcat('peak supersaturation = ', num2str(round(OUT,2)), '%'))
