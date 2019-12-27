% function: Radius_calc - calculate turn radius of optimized pattern with
% ratio <= 2
% in1: Width_matrix - 4x1 matrix of trace widths [mm] (W1 W2 W3 W4)
% in2: frequency - Larmor frequency (Hz)
% out1: Radii_matrix - 4x1 matrix of turn radii for optimized pattern [mm] (r1 r2
% r3 r4)
% out2: tl - desired trace length [mm]

function [Radii_matrix,tl] = Radius_calc(Width_matrix,frequency)
c = 299792458*10^3; % speed of light [mm/s]
lambda = c/frequency; % wavelength [mm]
tl = lambda/4/2; %lambda/4 wavelength /2 traces 
Radii_matrix_i = [0 0 0 0];
for i = 1:4
    r1 = sqrt((tl/(32*pi))^2 + (Width_matrix(i)/2)^2)+ (tl/(32*pi))-(Width_matrix(i)/2);
    r2 = Width_matrix(i) + r1;
    r = 2*r1*r2/(r1+r2);
    Radii_matrix_i(i) = r;
end
for i = 1:4 
       if Radii_matrix_i(i) - Width_matrix(i) <  1.8270*exp(Width_matrix(i)*(0.3107))
           Radii_matrix_i(i) = 1.8270*exp(Width_matrix(i)*(0.3107));
       end
end
Radii_matrix_i(2) = Radii_matrix_i(1); %need equal radii for vertical symmetry 
Radii_matrix_i(4) = Radii_matrix_i(3); %need equal radii for vertical symmetry
Radii_matrix = Radii_matrix_i; 
end

%cite: Popugaev A. & Wansch R.