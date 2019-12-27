%function: draw - helper to plot points in predetermined patterns
% in1: name - name of the pattern
% in2: startX - x coordinate of center point (mm)
% in3: startY - y coordinate of center point (mm)
% in4: r - radius of turn (mm)
% in5: w - width of trace (mm)
% in6: sf - stretch/shrink factor (mm)
% in7: start - start of turn (radians)
% out1: startX - x coordinate of center point after drawing (mm)
% out2: startY - y coordinate of center point after drawing (mm)
% out3: l - length of segment drawn (mm)
function [startX,startY,l] = draw(name,startX,startY,r,w,sf,start)
%CONSTANTS:
RESOLUTION = 0.001; %space between plotted points (mm)
% see Patterns
if strcmp(name,'wave_downR')
    [startX,startY,l] = wave_downR(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'wave_downL')
    [startX,startY,l] = wave_downL(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'wave_upR')
    [startX,startY,l] = wave_upR(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'wave_upL')
    [startX,startY,l] = wave_upL(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'top_capR')
    [startX,startY,l] = top_capR(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'top_capL')
     [startX,startY,l] = top_capL(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'bot_capR')
     [startX,startY,l] = bot_capR(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'bot_capL')
    [startX,startY,l] = bot_capL(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'top_capR_V')
    [startX,startY,l] = top_capR_V(RESOLUTION,startX,startY,r,w,sf);
elseif strcmp(name,'top_capL_V')
     [startX,startY,l] = top_capL_V(RESOLUTION,startX,startY,r,w,sf);
elseif strcmp(name,'bot_capR_V')
     [startX,startY,l] = bot_capR_V(RESOLUTION,startX,startY,r,w,sf);
elseif strcmp(name,'bot_capL_V')
    [startX,startY,l] = bot_capL_V(RESOLUTION,startX,startY,r,w,sf);
elseif strcmp(name,'u')
    [startX,startY,l] = u(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'n')
    [startX,startY,l] = n(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'c')
    [startX,startY,l] = c(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'D')
    [startX,startY,l] = D(RESOLUTION,startX,startY,r,w);
elseif strcmp(name,'single')
    [startX,startY,l] = single(RESOLUTION,startX,startY,r,w,start);
else
    %create safety 
end
end
%function: route_out - plots arc pattern
% in1: q - vector of coordinates (radians)
% in2: startX - x coordinate of center point (mm)
% in3: startY - y coordinate of center point (mm)
% in4: r - radius of turn (mm)
% in5: w - width of trace (mm)
%see Route Out
function route_out(q,startX,startY,r,w)
%parametric equations for outer arc
trace_X = startX + (r+w)*cos(q);
trace_Y = startY + (r+w)*sin(q);
plot(trace_X,trace_Y,'r'); 
%parametric quation for inner arc
trace_X = startX + (r-w)*cos(q);
trace_Y = startY + (r-w)*sin(q);
plot(trace_X,trace_Y,'r');
end
%see Patterns
function [startX,startY,l] = wave_downR(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as wave_downR
n = 2;
l = n*(pi*r/2);
start = pi;
stop = 3*pi/2;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX,startY,r,w)
start = 0;
stop = pi/2;
q = start:resolution:stop;
startY = startY - 2*r;
route_out(q,startX,startY,r,w)
end
function [startX,startY,l] = wave_downL(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as wave_downL
n = 2;
l = n*(pi*r/2);
start = pi/2;
stop = pi;
q = start:resolution:stop;
startY = startY - 2*r;
route_out(q,startX,startY,r,w)
start = 3*pi/2;
stop = 2*pi;
q = start:resolution:stop;
startX = startX - 2*r;
route_out(q,startX,startY,r,w)
end
function [startX,startY,l] = wave_upL(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as wave_upL
n = 2;
l = n*(pi*r/2);
start = pi;
stop = 3*pi/2;
q = start:resolution:stop;
startY = startY + 2*r;
route_out(q,startX,startY,r,w)
start = 0;
stop = pi/2;
q = start:resolution:stop;
startX = startX - 2*r;
route_out(q,startX,startY,r,w)
end
function [startX,startY,l] = wave_upR(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as wave_upR
n = 2;
l = n*(pi*r/2);
start = pi/2;
stop = pi;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX,startY,r,w)
start = 3*pi/2;
stop = 2*pi;
q = start:resolution:stop;
startY = startY + 2*r;
route_out(q,startX,startY,r,w)
end
function [startX,startY,l] = top_capR(resolution,startX,startY,r,w)
%routes three segments in the pattern defined as top_capR
n = 3;
l = n*(pi*r/2);
start = -pi/2;
stop = pi;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX,startY,r,w)
end
function [startX,startY,l] = top_capL(resolution,startX,startY,r,w)
%routes three segments in the pattern defined as top_capL
n = 3;
l = n*(pi*r/2);
start = 0;
stop = 3*pi/2;
q = start:resolution:stop;
startY = startY + 2*r;
route_out(q,startX,startY,r,w)
end
function [startX,startY,l] = bot_capR(resolution,startX,startY,r,w)
%routes three segments in the pattern defined as bot_capR
n = 3;
l = n*(pi*r/2);
start = -pi;
stop = pi/2;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX,startY,r,w);
end
function [startX,startY,l] = bot_capL(resolution,startX,startY,r,w)
%routes three segments in the pattern defined as bot_capL
n = 3;
l = n*(pi*r/2);
start = pi/2;
stop = 2*pi;
q = start:resolution:stop;
startY = startY - 2*r;
route_out(q,startX,startY,r,w);
end
function [startX,startY,l] = top_capR_V(resolution,startX,startY,r,w,sf)
%routes three segments in the pattern defined as top_capR
n = 1;
rV = r+(sf/pi);
l1 = n*(pi*rV/2);
start = -pi/2;
stop = 0;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX,startY+(sf/pi),rV,w)
n = 1;
l2 = n*(pi*r/2);
start = 0;
stop = pi/2;
q = start:resolution:stop;
route_out(q,startX+(sf/pi),startY+(sf/pi),r,w)
n = 1;
l3 = n*(pi*rV/2);
start = pi/2;
stop = pi;
q = start:resolution:stop;
route_out(q,startX+(sf/pi),startY,rV,w)
l = l1+l2+l3;
end
function [startX,startY,l] = top_capL_V(resolution,startX,startY,r,w,sf)
%routes three segments in the pattern defined as top_capL
n = 1;
rV = r+(sf/pi);
l1 = n*(pi*rV/2);
start = 0;
stop = pi/2;
q = start:resolution:stop;
startY = startY + 2*r;
route_out(q,startX-(sf/pi),startY,rV,w)
n = 1;
l2 = n*(pi*r/2);
start = pi/2;
stop = pi;
q = start:resolution:stop;
route_out(q,startX-(sf/pi),startY+(sf/pi),r,w)
n = 1;
l3 = n*(pi*rV/2);
start = pi;
stop = 3*pi/2;
q = start:resolution:stop;
route_out(q,startX,startY+(sf/pi),rV,w)
l = l1+l2+l3;
end
function [startX,startY,l] = bot_capR_V(resolution,startX,startY,r,w,sf)
%routes three segments in the pattern defined as bot_capR
n = 1;
rV = r+(sf/pi);
l1 = n*(pi*rV/2);
start = -pi;
stop = -pi/2;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX+(sf/pi),startY,rV,w)
n = 1;
l2 = n*(pi*r/2);
start = -pi/2;
stop = 0;
q = start:resolution:stop;
route_out(q,startX+(sf/pi),startY-(sf/pi),r,w)
n = 1;
l3 = n*(pi*rV/2);
start = 0;
stop = pi/2;
q = start:resolution:stop;
route_out(q,startX,startY-(sf/pi),rV,w)
l = l1+l2+l3;
end
function [startX,startY,l] = bot_capL_V(resolution,startX,startY,r,w,sf)
%routes three segments in the pattern defined as bot_capL_V
n = 1;
rV = r+(sf/pi);
l1 = n*(pi*rV/2);
start = pi/2;
stop = pi;
q = start:resolution:stop;
startY = startY - 2*r;
route_out(q,startX,startY-(sf/pi),rV,w)
n = 1;
l2 = n*(pi*r/2);
start = pi;
stop = 3*pi/2;
q = start:resolution:stop;
route_out(q,startX-(sf/pi),startY-(sf/pi),r,w)
n = 1;
l3 = n*(pi*rV/2);
start = 3*pi/2;
stop = 2*pi;
q = start:resolution:stop;
route_out(q,startX-(sf/pi),startY,rV,w)
l = l1+l2+l3;
end
function [startX,startY,l] = u(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as u
n = 2;
l = n*(pi*r/2);
start = pi;
stop = 2*pi;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX,startY,r,w);
end
function [startX,startY,l] = n(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as n
n = 2;
l = n*(pi*r/2);
start = 0;
stop = pi;
q = start:resolution:stop;
startX = startX + 2*r;
route_out(q,startX,startY,r,w);
end
function [startX,startY,l] = c(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as c
n = 2;
l = n*(pi*r/2);
start = pi/2;
stop = 3*pi/2;
q = start:resolution:stop;
route_out(q,startX,startY,r,w);
end
function [startX,startY,l] = D(resolution,startX,startY,r,w)
%routes two segments in the pattern defined as D
n = 2;
l = n*(pi*r/2);
start = -pi/2;
stop = pi/2;
q = start:resolution:stop;
route_out(q,startX,startY,r,w);
end
function [startX,startY,l] = single(resolution,startX,startY,r,w,start)
%routes 1 segment in the pattern defined as single
n = 1;
l = n*(pi*r/2);
stop = start + pi/2;
q = start:resolution:stop;
route_out(q,startX,startY,r,w);
end