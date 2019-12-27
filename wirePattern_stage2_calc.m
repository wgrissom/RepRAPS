% function: wirePattern_stage2_calc - plot point values of optimized power
% splitter with ratio <= 2
% in1: Radii_matrix - 4x1 matrix of turn radii (mm) [r1 r2 r3 r4]
% in2: tl - desired trace length (mm)
% in3: Width_matrix - 4x1 matrix of trace thickness (mm) [W1 W2 W3 W4]
% out1: rtls - 4x1 matrix of remaining trace lengths [rtl1 rtl2 rtl3 rtl4] --> all ~0 (sanity check)

function [rtls] = wirePattern_stage2_calc(Radii_matrix,tl,Width_matrix)
%CONSTANTS:
LIOP = 5; %length of input/output ports [mm] 
WIOP = 1.843; %trace width with 50ohm (width of input/output ports)[mm]
LOB =  72; %length of board ~70mm [mm]
DBP = 20; %distance between output ports [mm]
POR = LOB/2; %x coordinant position of resistor [mm]
startX = 4.1; %x coordinant to start optimized pattern ~4mm [mm]
startY = 3.3;%y coordinant to start optimized pattern ~3mm [mm]
rtls = [0 0 0 0];
%input port
line([-LIOP,-LIOP],[WIOP/2,-WIOP/2],'Color','red')
hold on
intersect = startX + (2*Radii_matrix(1)+Width_matrix(1)/2)*cos(pi - asin((WIOP/2 - (startY-2*Radii_matrix(1)))/(2*Radii_matrix(1)+Width_matrix(1)/2)));
line([-LIOP,intersect],[WIOP/2,WIOP/2],'Color','red')
intersect = startX + (2*Radii_matrix(2)+Width_matrix(2)/2)*cos(pi - asin((-WIOP/2 - (-startY+2*Radii_matrix(2)))/(2*Radii_matrix(2)+Width_matrix(2)/2)));
line([-LIOP,intersect],[-WIOP/2,-WIOP/2],'Color','red')
intersectu = startY-2*Radii_matrix(1) + (2*Radii_matrix(1)-Width_matrix(1)/2)*sin(acos(-startX/(2*Radii_matrix(1)-Width_matrix(1)/2)));
intersectl = -startY+2*Radii_matrix(2) + (2*Radii_matrix(2)-Width_matrix(2)/2)*sin(2*pi - acos(-startX/(2*Radii_matrix(2)-Width_matrix(2)/2)));
line([0,0],[intersectu,intersectl],'Color','red')
%output port 2
line([LOB-2*LIOP,LOB-LIOP],[DBP/2+WIOP/2,DBP/2+WIOP/2],'Color','red');
line([LOB-2*LIOP,LOB-LIOP],[DBP/2-WIOP/2,DBP/2-WIOP/2],'Color','red');
line([LOB-LIOP,LOB-LIOP],[DBP/2+WIOP/2,DBP/2-WIOP/2],'Color','red')
%output port 3
line([LOB-2*LIOP,LOB-LIOP],[-DBP/2+WIOP/2,-DBP/2+WIOP/2],'Color','red');
line([LOB-2*LIOP,LOB-LIOP],[-DBP/2-WIOP/2,-DBP/2-WIOP/2],'Color','red');
line([LOB-LIOP,LOB-LIOP],[-DBP/2+WIOP/2,-DBP/2-WIOP/2],'Color','red');
%plot trace with impedance Z1
[startXu,startYu,rtl] = Z1(Radii_matrix(1),Width_matrix(1)/2,tl,POR,WIOP/2,startX,startY);
rtls(1) = rtl;
%plot trace with impedance Z2
[startXl,startYl,rtl] = Z2(Radii_matrix(2),Width_matrix(2)/2,tl,POR,WIOP/2,startX,-startY);
rtls(2) = rtl;
%plot trace with impedance Z3
rtl = Z3(Radii_matrix(3),Width_matrix(3)/2,tl,DBP,LOB,LIOP,startXu,startYu);
rtls(3) = rtl;
%plot trace with impedance Z4
rtl = Z4(Radii_matrix(4),Width_matrix(4)/2,tl,DBP,LOB,LIOP,startXl,startYl);
rtls(4) = rtl;
end

% function: Z1 - plot point values of optimized WPS's trace 1
% in1: r - radius for optimized pattern trace 1 (mm)
% in2: w - trace 1 thickness (mm)
% in3: tl - desired trace length (mm)
% in4: POR - position of radius (mm)
% in5: WIOP - width of input/output port (mm)
% in6: startX - x coordinate on wire pattern plot before Z1 (mm)
% in7: startY - y coordinate on wire pattern plot before Z1 (mm)
% out1: startX - x coordinate on wire pattern plot after Z1 (mm)
% out2: startY - y coordinate on wire pattern plot after Z1 (mm)
% out3: remaining_tl - actual minus desired trace length of Z1 ~0mm (mm)

function[startX,startY,remaining_tl] = Z1(r,w,tl,POR,WIOP,startX,startY)
%CONSTANTS:
RESOLUTION = 0.001; %space between plotted points (mm)
%plot first segment (out of pattern)
%a slightly tapered trace at the input avoids sharp edges --> loss
startY = startY-r;
start = pi/2;
q = start:RESOLUTION:pi - asin((WIOP - (startY-r))/(2*r+w));
trace_X = startX + (2*r+w)*cos(q);
trace_Y = startY-r + (2*r+w)*sin(q);
plot(trace_X,trace_Y,'r');
q = start:RESOLUTION:acos(-startX/(2*r-w));
trace_X = startX + (2*r-w)*cos(q);
trace_Y = startY-r + (2*r-w)*sin(q);
plot(trace_X,trace_Y,'r');
%remaining_tl - calculated, actual trace length not yet plotted - eventually ~0
remaining_tl = tl -(2*pi*r)*((((pi - asin((WIOP - (startY-r))/(2*r+w)) + acos(-startX/(2*r-w)))/2)- start)/(2*pi));
%plot base pattern
%see "Plotted Base Pattern"
startY = startY + 2*r;
%remaining_tl_calc - a running approximation of the trace length not yet
%plotted --> used to determine trace length variations
remaining_tl_calc = remaining_tl-(23*(pi*r/2)); %minimum of 23 segments in base pattern (see Minimum # of Segments), approximation bc some will be stretched/shrunk
%calculation of initial stretch/shink factor
if remaining_tl_calc < 0 %if the approximation already is too long, sf < 0
    sf = remaining_tl_calc/6; %overshoot (minimum_length - desired_length) / 6 (There are 6 locations in the remaining pattern that can be stretch/shrunk
else
   sf = 0; %ignore until postive sf is needed to increase trace length
end
[startX,startY,l] = draw('D',startX,startY,r,w,0); %cannot vary --> sf = 0
remaining_tl = remaining_tl-l;
[startX,startY,l] = draw('top_capL_V',startX,startY,r,w,sf); %cannot stretch - too close to the edge of the board (sf <= 0 here)
remaining_tl = remaining_tl-l;
[startX,startY,l] = draw('wave_downR',startX,startY,r,w,0); %cannot vary --> sf = 0
remaining_tl = remaining_tl-l;
[startX,startY,l] = draw('bot_capR_V',startX,startY,r,w,sf); %cannot stretch - too close to Z2 (sf <= 0 here)
%hold space to add variable trace length later
startXpA = startX;
startYpA = startY;
remaining_tl = remaining_tl-l;
startY = startY + 2*r;
[startX,startY,l] = draw('u',startX,startY,r,w,sf);
remaining_tl = remaining_tl-l;
%hold space to add variable trace length later
startXpB = startX;
startYpB = startY;
startX = startX + 2*r;
[startX,startY,l] = draw('bot_capL_V',startX,startY,r,w,sf); %cannot stretch - too close to Z2 (sf <= 0 here)
remaining_tl = remaining_tl-l;
%variation in radius of 'n' allows Z1 to end at POR
if (POR-(startX+r))/2 < 1.25*r % radius > 1.25*calculated radius starts to look weird
    [startXe,startYe,l] = draw('n',startX-(POR-(startX+r))/2 + r,startY,(POR-(startX+r))/2,w,0); %cannot stretch/shrink --> sf = 0
    startXe = startXe + (POR-(startX+r))/2;
else %allow POR to vary but retain point (startXe) so Z3 can compensate
    [startXe,startYe,l] = draw('n',startX-(1.25*r) + r,startY,(1.25*r),w,0); %cannot stretch/shrink --> sf = 0
    startXe = startXe + (1.25*r);
end
remaining_tl = remaining_tl-l;
% fill in space left for variability in trace length
remaining_tl_calc = remaining_tl-(6*(pi*r/2)); %subract estimated length of required traces (necessary for sf calculation)
count = 0;
startX = startXpA;
startY = startYpA;
while remaining_tl_calc > (4*(pi*r/2)) - 6*2 %~6mm is a reasonable adjustment in trace length through sf
[startX,startY,l] = draw('wave_upL',startX,startY,r,w,0);%cannot vary --> sf = 0
remaining_tl = remaining_tl-l;
remaining_tl_calc = remaining_tl_calc - 2*l;
count = count + 1;
end
sf = remaining_tl_calc/2; %remaining trace length / 2 (There are 2 locations in the remaining pattern that can be stretch/shrunk
[startX,startY,l] = draw('top_capL_V',startX,startY,r,w,sf);
remaining_tl = remaining_tl-l;
while count > 0
[startX,startY,l] = draw('wave_downR',startX,startY,r,w,0); %cannot vary --> sf = 0
remaining_tl = remaining_tl-l;
count = count - 1;
end
[startX,startY,l] = draw('top_capR_V',startXpB,startYpB,r,w,sf);
remaining_tl = remaining_tl-l;
%reset ending point
startX = startXe; %~POR
startY = startYe;
end

% function: Z2 - plot point values of optimized WPS's trace 2
% in1: r - radius for optimized pattern trace 2 (mm)
% in2: w - trace 2 thickness (mm)
% in3: tl - desired trace length (mm)
% in4: POR - position of radius (mm)
% in5: WIOP - width of input/output port (mm)
% in6: startX - x coordinate on wire pattern plot before Z2 (mm)
% in7: startY - y coordinate on wire pattern plot before Z2 (mm)
% out1: startX - x coordinate on wire pattern plot after Z2 (mm)
% out2: startY - y coordinate on wire pattern plot after Z2 (mm)
% out3: remaining_tl - actual minus desired trace length of Z2 ~0mm (mm)

function[startX,startY,remaining_tl] = Z2(r,w,tl,POR,WIOP,startX,startY)
%CONSTANTS:
RESOLUTION = 0.001; %space between plotted points (mm)
%plot first segment (out of pattern)
%a tapered trace at the input avoids sharp edges --> loss
startY = startY + r;
stop = 3*pi/2;
q = pi - asin((-WIOP - (startY+r))/(2*r+w)):RESOLUTION:stop;
trace_X = startX + (2*r+w)*cos(q);
trace_Y = startY+r + (2*r+w)*sin(q);
plot(trace_X,trace_Y,'r');
q = 2*pi - acos(-startX/(2*r-w)):RESOLUTION:stop;
trace_X = startX + (2*r-w)*cos(q);
trace_Y = startY+r + (2*r-w)*sin(q);
plot(trace_X,trace_Y,'r');
%remaining_tl - calculated, actual trace length not yet plotted - eventually ~0
remaining_tl = tl -(2*pi*r)*((((stop - (pi - asin((-WIOP - (startY+r))/(2*r+w))) + (stop - (2*pi - acos(-startX/(2*r-w)))))/2))/(2*pi));
%plot base pattern
%see slide "Plotting Base Pattern
startY = startY - 2*r;
%remaining_tl_calc - a running approximation of the trace length not yet
%plotted --> used to determine trace length variations
remaining_tl_calc = remaining_tl-(23*(pi*r/2)); %minimum of 23 segments in base pattern (see Minimum # of Segments), approximation bc some will be stretched/shrunk
%calculation of initial stretch/shink factor
if remaining_tl_calc < 0 %if the approximation already is too long, sf < 0
    sf = remaining_tl_calc/6; %overshoot (minimum_length - desired_length) / 6 (There are 6 locations in the remaining pattern that can be stretch/shrunk
else
   sf = 0; %ignore until postive sf is needed to increase trace length
end
[startX,startY,l] = draw('D',startX,startY,r,w,0); %cannot vary --> sf = 0
remaining_tl = remaining_tl-l;
[startX,startY,l] = draw('bot_capL_V',startX,startY,r,w,sf); %cannot stretch - too close to the edge of the board (sf <=0 here)
remaining_tl = remaining_tl-l;
[startX,startY,l] = draw('wave_upR',startX,startY,r,w,0); %cannot vary --> sf = 0
remaining_tl = remaining_tl-l;
[startX,startY,l] = draw('top_capR_V',startX,startY,r,w,sf); %cannot stretch - too close to Z1 (sf <=0 here)
%hold space to add variable trace length later
startXpA = startX;
startYpA = startY;
remaining_tl = remaining_tl-l;
startY = startY - 2*r;
[startX,startY,l] = draw('n',startX,startY,r,w,0); %cannot vary --> sf = 0
remaining_tl = remaining_tl-l;
%hold space to add variable trace length later
startXpB = startX;
startYpB = startY;
startX = startX + 2*r;
[startX,startY,l] = draw('top_capL_V',startX,startY,r,w,sf); %cannot stretch - too close to Z1 (sf <=0 here)
remaining_tl = remaining_tl-l;
%variation in radius of 'u' allows Z2 to end at POR
if (POR-(startX+r))/2 < 1.25*r % radius > 1.25*calculated radius starts to look weird
    [startXe,startYe,l] = draw('u',startX-(POR-(startX+r))/2 + r,startY,(POR-(startX+r))/2,w,0); %cannot stretch/shrink --> sf = 0
    startXe = startXe + (POR-(startX+r))/2;
else %allow POR to vary but retain point (startXe) so Z4 can compensate
    [startXe,startYe,l] = draw('u',startX-(1.25*r)+ r,startY,(1.25*r),w,0); %cannot stretch/shrink --> sf = 0
    startXe = startXe + (1.25*r);
end
remaining_tl = remaining_tl-l;
% fill in space left for variability in trace length
remaining_tl_calc = remaining_tl-(6*(pi*r/2)); %subract estimated length of required traces (necessary for sf calculation)
count = 0;
startX = startXpA;
startY = startYpA;
while remaining_tl_calc > (4*(pi*r/2)) - 6 %~6mm is a reasonable adjustment in trace length through sf
    [startX,startY,l] = draw('wave_downL',startX,startY,r,w,sf);
    remaining_tl = remaining_tl-l;
    remaining_tl_calc = remaining_tl_calc - 2*l;
    count = count + 1;
end
sf = remaining_tl_calc/2; %remaining trace length / 2 (There are 2 locations in the remaining pattern that can be stretch/shrunk
[startX,startY,l] = draw('bot_capL_V',startX,startY,r,w,sf);
remaining_tl = remaining_tl-l;
while count > 0
    [startX,startY,l] = draw('wave_upR',startX,startY,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    count = count - 1;
end
[startX,startY,l] = draw('bot_capR_V',startXpB,startYpB,r,w,sf);
remaining_tl = remaining_tl-l;
%reset ending point 
startX = startXe; %~POR
startY = startYe;
end

% function: Z3 - plot point values of optimized WPS's trace 3
% in1: r - radius for optimized pattern trace 3 (mm)
% in2: w - trace thickness (mm)
% in3: tl - desired trace length (mm)
% in4: DBP - distance between output ports (mm)
% in5: LOB - length of board (mm)
% in6: LIOP - length of input/output port (mm)
% in7: startX - x coordinate on wire pattern plot before Z3 (mm)
% in8: startY - y coordinate on wire pattern plot before Z3 (mm)
% out1: remaining_tl - actual - desired trace length of Z3 (mm)

function remaining_tl = Z3(r,w,tl,DBP,LOB,LIOP,startX,startY)
%plot base pattern
%see "Plotted Base Pattern"
startX = startX - r;
%remaining_tl - calculated, actual trace length not yet plotted - eventually ~0
remaining_tl = tl;
%remaining_tl_calc - a running approximation of the trace length not yet
remaining_tl_calc = remaining_tl-(15*(pi*r/2)); %minimum of 15 segments in base pattern (see Minimum # of Segments), approximation bc some will be stretched/shrunk
%calculation of initial stretch/shink factor
if remaining_tl_calc < 0 %if the approximation already is too long, sf < 0
    sf = remaining_tl_calc/4; %overshoot (minimum_length - desired_length) / 4 (There are 4 locations in the remaining pattern that can be stretch/shrunk)
else
   sf = 0; %ignore until postive sf is needed to increase trace length
end
[startX,startY,l] = draw('bot_capR_V',startX,startY,r,w,sf); %cannot stretch - too close Z4 (sf <= 0 here)
remaining_tl = remaining_tl-l;
%hold space to add variable trace length later
startXpA = startX;
startYpA = startY;
startY = startY + 2*r;
[startX,startY,l] = draw('u',startX,startY,r,w,0);
remaining_tl = remaining_tl-l;
%hold space to add variable trace length later
startXpB = startX;
startYpB = startY;
startX = startX + 2*r;
[startX,startY,l] = draw('bot_capL_V',startX,startY,r,w,sf); %cannot stretch - too close Z4 (sf <= 0 here)
remaining_tl = remaining_tl-l;
%variation in radius of 'single' allows Z3 to end at LOB-2*LIOP (beginning of output port)
[startXe,startYe,l] = draw('single',startX+2*r+DBP/2-startY-r ,startY,abs(DBP/2-startY),w,0,pi/2); %cannot stretch/shrink --> sf = 0
line([startXe,LOB-2*LIOP],[startYe + DBP/2-startY + w,startYe + DBP/2-startY + w],'Color','red');
line([startXe,LOB-2*LIOP],[startYe + DBP/2-startY - w,startYe + DBP/2-startY - w],'Color','red');
remaining_tl = remaining_tl-l - (LOB-2*LIOP - startXe);
% fill in space left for variability in trace length
remaining_tl_calc = remaining_tl-(6*(pi*r/2)); %subract estimated length of required traces (necessary for sf calculation)
countB = 0;
countA = 0;
while remaining_tl_calc > 4*(pi*r/2)-6 && LOB-2*LIOP - startXpB > 4*r && countB < 1 %~6mm is a reasonable adjustment in trace length through sf, edge cannot extend past LOB
    [startXpB,startYpB,l] = draw('wave_upR',startXpB,startYpB,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    remaining_tl_calc = remaining_tl_calc - 2*l;
    countB = countB + 1;
end
while remaining_tl_calc > (4*(pi*r/2)) - 6 %~6mm is a reasonable adjustment in trace length through sf
    [startXpA,startYpA,l] = draw('wave_upL',startXpA,startYpA,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    remaining_tl_calc = remaining_tl_calc - 2*l;
    countA = countA + 1;
end
sf = remaining_tl_calc/2; %remaining trace length / 2 (There are 2 locations in the remaining pattern that can be stretch/shrunk
[startX,startY,l] = draw('top_capR_V',startXpB,startYpB,r,w,sf);
remaining_tl = remaining_tl-l;
while countB > 0
    [startX,startY,l] = draw('wave_downL',startX,startY,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    countB = countB - 1;
end
[startX,startY,l] = draw('top_capL_V',startXpA,startYpA,r,w,sf);
remaining_tl = remaining_tl-l;
while countA > 0
    [startX,startY,l] = draw('wave_downR',startX,startY,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    countA = countA - 1;
end
end

% function: Z4 - plot point values of optimized WPS's trace 4
% in1: r - radius for optimized pattern trace 4 (mm)
% in2: w - trace thickness (mm)
% in3: tl - desired trace length (mm)
% in4: DBP - distance between output ports (mm)
% in5: LOB - length of board (mm)
% in6: LIOP - length of input/output port (mm)
% in7: startX - x coordinate on wire pattern plot before Z4 (mm)
% in8: startY - y coordinate on wire pattern plot before Z4 (mm)
% out1: remaining_tl - actual - desired trace length of Z4 (mm)

function remaining_tl = Z4(r,w,tl,DBP,LOB,LIOP,startX,startY)
%plot base pattern
%see "Plotted Base Pattern"
startX = startX - r;
%remaining_tl - calculated, actual trace length not yet plotted - eventually ~0
remaining_tl = tl;
%remaining_tl_calc - a running approximation of the trace length not yet
remaining_tl_calc = remaining_tl-(15*(pi*r/2)); %minimum of 15 segments in base pattern (see Minimum # of Segments), approximation bc some will be stretched/shrunk
%calculation of initial stretch/shink factor
if remaining_tl_calc < 0 %if the approximation already is too long, sf < 0
    sf = remaining_tl_calc/4; %overshoot (minimum_length - desired_length) / 4 (There are 4 locations in the remaining pattern that can be stretch/shrunk)
else
   sf = 0; %ignore until postive sf is needed to increase trace length
end
[startX,startY,l] = draw('top_capR_V',startX,startY,r,w,sf); %cannot stretch - too close Z3 (sf <= 0 here)
remaining_tl = remaining_tl-l;
%hold space to add variable trace length later
startXpA = startX;
startYpA = startY;
startY = startY - 2*r;
[startX,startY,l] = draw('n',startX,startY,r,w,0);
remaining_tl = remaining_tl-l;
%hold space to add variable trace length later
startXpB = startX;
startYpB = startY;
startX = startX + 2*r;
[startX,startY,l] = draw('top_capL_V',startX,startY,r,w,sf); %cannot stretch - too close Z3 (sf <= 0 here)
remaining_tl = remaining_tl-l;
%variation in radius of 'single' allows Z3 to end at LOB-2*LIOP (beginning of output port)
[startXe,startYe,l] = draw('single',startX+2*r+(DBP/2)+startY-r,startY,abs((-DBP/2)-startY),w,0,pi); %cannot stretch/shrink --> sf = 0
line([startXe,LOB-2*LIOP],[startYe + -DBP/2-startY + w,startYe + -DBP/2-startY + w],'Color','red');
line([startXe,LOB-2*LIOP],[startYe + -DBP/2-startY - w,startYe + -DBP/2-startY - w],'Color','red');
remaining_tl = remaining_tl-l - (LOB-2*LIOP - startXe);
% fill in space left for variability in trace length
remaining_tl_calc = remaining_tl-(6*(pi*r/2)); %subract estimated length of required traces (neccesary for sf calculation)
countB = 0;
countA = 0;
while remaining_tl_calc > 4*(pi*r/2)-6 && LOB-2*LIOP - startXpB > 4*r && countB < 1 %~6mm is a reasonable adjustment in trace length through sf, edge cannot extend past LOB
    [startXpB,startYpB,l] = draw('wave_downR',startXpB,startYpB,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    remaining_tl_calc = remaining_tl_calc - 2*l;
    countB = countB + 1;
end
while remaining_tl_calc > (4*(pi*r/2)) - 6 %~6mm is a reasonable adjustment in trace length through sf
    [startXpA,startYpA,l] = draw('wave_downL',startXpA,startYpA,r,w,0);
    remaining_tl = remaining_tl-l;
    remaining_tl_calc = remaining_tl_calc - 2*l;
    countA = countA + 1;
end
sf = remaining_tl_calc/2; %remaining trace length / 2 (There are 2 locations in the remaining pattern that can be stretch/shrunk
[startX,startY,l] = draw('bot_capR_V',startXpB,startYpB,r,w,sf);
remaining_tl = remaining_tl-l;
while countB > 0
    [startX,startY,l] = draw('wave_upL',startX,startY,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    countB = countB - 1;
end
[startX,startY,l] = draw('bot_capL_V',startXpA,startYpA,r,w,sf);
remaining_tl = remaining_tl-l;
while countA > 0
    [startX,startY,l] = draw('wave_upR',startX,startY,r,w,0); %cannot vary --> sf = 0
    remaining_tl = remaining_tl-l;
    countA = countA - 1;
end
end


