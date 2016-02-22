function [ fx, fy] = zPupilMapping(P_x,P_y,EPsurf,XPsurf,ConfigNum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inputs a given pupil map P_x, P_y (values -1 to 1) within pupil
%using merit functions, queries the global coordinates of the corresponding
%locations in exit pupil.  Calculates expected pupil location (magnification * EP coordinate)
%and calculates error between ideal and values reported by Zemax f_x and
%f_y
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%written by Barbara Kruse, Sept 2015
%                          revised Feb 2016 to account for array lengths
%                          >100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%sets location for ZEMAX Merit Functions RAGX and RAGY
%%(the merit functions are named after the zemax operand they call)
RAGX = ('C:\Users\Jane\Documents\Zemax\MeritFunction\RAGX.mf');
RAGY = ('C:\Users\Jane\Documents\Zemax\MeritFunction\RAGY.mf');
zDDEInit;     %initializes (or re-initializes) connection to Zemax
%
data = zReadSystemData;
AMAG = data.Angular_Magnification %this is the inverse of the ideal
%                                  spatial magnification in the exit pupil
wave = 1;  
Hx = 0;
Hy = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loops = ceil(length(P_x)/100); %MF has only 100 lines, these are for loop
stops = [ones(1,loops-1)*100, (rem(length(P_x),100))];%
for k = 1:length(stops)  %runs for each batch of 100 pupil coordinates
    i1 =((k-1)*100);
    i2 = stops(k);
    
 %%%%  EP_x data grab (for verification only)
    zLoadMerit(RAGX);zPushLens(4); zGetRefresh;
    zSetOperand(1,2,ConfigNum);
    for i = 1:i2;
        zSetOperand(i+1,2,EPsurf);
        zSetOperand(i+1,3,wave);
        zSetOperand(i+1,4,Hx);
        zSetOperand(i+1,5,Hy);
        zSetOperand(i+1,6,P_x(i1+i));
        zSetOperand(i+1,7,P_y(i1+i));
    end
    zPushLens(4); zGetRefresh;
    for i = 1:i2  
        EP_x(i1+i) = zGetOperand(i+1,10);
    end
 %%%%  EP_y data grab (for verification only)
    zLoadMerit(RAGY); zPushLens(4); zGetRefresh;
    zSetOperand(1,2,ConfigNum);

    for i = 1:i2;     %set up Merit function
        zSetOperand(i+1,2,EPsurf);
        zSetOperand(i+1,3,wave);
        zSetOperand(i+1,4,Hx);
        zSetOperand(i+1,5,Hy);
        zSetOperand(i+1,6,P_x(i1+i));
        zSetOperand(i+1,7,P_y(i1+i));
    end
    zPushLens(4); zGetRefresh;  %push Zemax to update MF values
    for i = 1:i2       %%get Data
        EP_y(i1+i) = zGetOperand(i+1,10);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  XP_x data grab
    zLoadMerit(RAGX);zPushLens(4); zGetRefresh;
    zSetOperand(1,2,ConfigNum);
    for i = 1:i2;
        zSetOperand(i+1,2,XPsurf);
        zSetOperand(i+1,3,wave);
        zSetOperand(i+1,4,Hx);
        zSetOperand(i+1,5,Hy);
        zSetOperand(i+1,6,P_x(i1+i));
        zSetOperand(i+1,7,P_y(i1+i));
    end
    zPushLens(4); zGetRefresh;
    for i = 1:i2
        XP_xActual(i1+i) = zGetOperand(i+1,10);
    end
    %%
    zLoadMerit(RAGY); zPushLens(4); zGetRefresh;
    zSetOperand(1,2,ConfigNum);
%%%%%%  XP_y data grab
    for i = 1:i2;
        zSetOperand(i+1,2,XPsurf);
        zSetOperand(i+1,3,wave);
        zSetOperand(i+1,4,Hx);
        zSetOperand(i+1,5,Hy);
        zSetOperand(i+1,6,P_x(i1+i));
        zSetOperand(i+1,7,P_y(i1+i));
    end
    zPushLens(4); zGetRefresh;
    for i = 1:i2
        XP_yActual(i1+i) = zGetOperand(i+1,10);
    end 
%%%%%%
%
end   %%ends loop per 100 coordinates
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XP_x = (1/AMAG)*EP_x;   %this is the ideal x coordinate
XP_y = (1/AMAG)*EP_y;   %this is the ideal y coordinate
fx = XP_xActual - XP_x;   %x error
fy = XP_yActual - XP_y;   %y error



