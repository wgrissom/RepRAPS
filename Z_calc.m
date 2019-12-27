% function: Z_calc - calculate impedances of each trace and resistor
% in1: ratio - power ratio (Port 1 / Port 2) e.g. 1,2,3,4...
% in2: Z0 - characteristic impedance (ohm) e.g. 50, 75...
% out1: Z_matrix - 4x1 matrix of segment impedances [ohm] (Z1 Z2 Z3 Z4)
% out2: R - resistor value [ohm]

function [Z_matrix , R] = Z_calc(ratio,Z0)
Z1 = Z0*(ratio^(-1.5)+ ratio^(-0.5))^(0.5);
Z2 = Z0*(1+ratio)^(0.5)*ratio^(0.25);
Z3 = Z0*ratio^(-0.25);
Z4 = Z0*(ratio^(0.25));
Z_matrix = [Z1 Z2 Z3 Z4];
R = Z0*(ratio^(0.5)+ratio^(-0.5));
end

%cite: Pozar