% function: Width_calc - calculate widths of traces for power splitter
% in1: Z_matrix - 4x1 matrix of segment impedances (ohm) [Z1 Z2 Z3 Z4]
% in2: cu_weight - thickness of copper clad (um) e.g. 17um, 35um...
% in3: thickness - thickness of dielectric (mil)
% in4: Er - relative dielectric constant
% out1: Width_matrix - 4x1 matrix of trace thickness (mm) [W1 W2 W3 W4]

function Width_matrix = Width_calc(Z_matrix,cu_weight,thickness,Er)
cu_weight = cu_weight*0.0393701; %convert to mil
Width_matrix_i = [0 0 0 0];
   for i = 1:4
       Z0 = Z_matrix(i);
       Width = ((7.48*thickness)/(exp((Z0 * (Er + 1.41)^0.5)/87)))-1.25*cu_weight;
       Width_matrix_i(i) = Width/39.37;
   end 
       if Width_matrix_i(2) < 0.4
           if Width_matrix_i(2) > 0
               Width_matrix = Width_calc([exp(0.4-Width_matrix_i(2))*Z_matrix(1)*94.777/Z_matrix(2) 94.77 exp(0.4-Width_matrix_i(2))*Z_matrix(3)*94.77/Z_matrix(2) Z_matrix(4)],cu_weight,thickness,Er);
           else 
               Width_matrix = Width_calc([exp(Width_matrix_i(2)-0.4)*Z_matrix(1)*94.777/Z_matrix(2) 94.77 exp(Width_matrix_i(2)-0.4)*Z_matrix(3)*94.77/Z_matrix(2) Z_matrix(4)],cu_weight,thickness,Er);
           end
       else 
           Width_matrix = Width_matrix_i;
       end
end

%cite: Pozar, Steel, Hoffman, Gupta