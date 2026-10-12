
% Evolution of Mobile Communication Systems

clear;
clc;
close all;

% Define parameters
generation = ["1G"; "2G"; "2G"; "3G"; "4G"; "5G"];

system = ["AMPS"; "GSM"; "IS-95"; "UMTS"; "LTE"; "5G NR"];

accessMethod = ["FDMA"; "TDMA"; "CDMA"; "WCDMA"; ...
                "OFDMA"; "OFDMA-based"];

keyIdea = ["Separate frequency channels"; ...
           "Separate time slots"; ...
           "Code-based user separation"; ...
           "Wideband code-based access"; ...
           "Orthogonal frequency resources"; ...
           "Flexible OFDM-based radio access"];

% Create and display the evolution table
evolutionTable = table(generation, system, ...
                       accessMethod, keyIdea);

disp(evolutionTable);
