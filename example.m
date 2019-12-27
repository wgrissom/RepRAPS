% example for calculating the wire pattern for a 1:1 optimized wilkinson power
% splitter on a RO3006 substrate (copper
% clad=35um,thickness=50mil,Er=6.5)at 7T (298 MHz)
%Files Needed:
%Z_calc.m
%Width_calc.m
%Radius_calc.m
%wirePattern_stage2_calc.m AND/OR wirePattern_stage1_calc.m
%draw.m

ratio = 1; %power ratio (Port 1 / Port 2)
Z0 = 50; %characteristic impedance (ohm)
cu_weight = 35; %thickness of copper clad (um)
thickness = 50; %thickness of dielectric (mil)
Er = 6.5; %relative dielectric constant
frequency = 2.98*10^8; %Larmor frequency (Hz)

[Z_matrix , R] = Z_calc(ratio,Z0);
Width_matrix = Width_calc(Z_matrix,cu_weight,thickness,Er);
%comment/uncomment if ratio <= 2
[Radii_matrix,tl] = Radius_calc(Width_matrix,frequency);
%[Radii_matrix,tl] = Radius_calc_higherRatio(Width_matrix,frequency);
%comment/uncomment if using stage 1 or stage 2 with ratio <= 2
[rtls] = wirePattern_stage1_calc(Radii_matrix,tl,Width_matrix);
%[rtls] = wirePattern_stage2_calc(Radii_matrix,tl,Width_matrix);
%comment/uncomment if using stage 2 with ratio > 2
%[rtls] = wirePattern_stage2_calc_higherRatio(Radii_matrix,tl,Width_matrix);