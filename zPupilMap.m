function [quiverData, m] = zPupilMap(arms,radial,EPsurf,XPsurf, plotON)
%%
%% Assumes initialized Zemax Connection
% Gets global coordinates of entrance and exit pupil via Zemax
% single ray trace.  Gets angular magnification from System Data and
% calculates ideal XP coordinates as (1/angular magnification)*(EP
% coordinate).  Generates quiver plot of error
%
% INPUTS -----------------------------------------------------------------
%   arms -      number of arms sampled in Entrance Pupil
%   radial -    number of points along single arm that are sampled in Entrance
%               Pupil
%   EPsurf -    surface number in Lens Editor of Entrance Pupil (must be
%               defined in lens editor, not just calculated.  Solve for
%               chief ray if necessary to determine location
%   XPsurf -    surface number in Lens Editor of Exit Pupil (must be
%               defined in lens editor, not just calculated.  Solve for
%               chief ray if necessary to determine location
%   plotON -    turns plotting on/off  (1 = plot)

% OUTPUTS ----------------------------------------------------------------
%
%   quiverData - 4 x n array [px;py;x_quiv,y_quiv] consisting of pupil 
%               coordinates(px and py) and x and y directions of quiver plot
% 
% Revision history information -------------------------------------------
% $Author: Barbara Kruse$
% $Date: 2015/08/28 $
% $Revision: 1 $
% $Revision History: 
% 
%
% Begin Code -------------------------------------------------------------
%
%get magnification
sysData= zReadSystemData;
angularMag = sysData.Angular_Magnification;
%
%% get transformation matrices to global coordinates
[rotEP transEP] = zGetGlobalMatrix(EPsurf);
[rotXP transXP] = zGetGlobalMatrix(XPsurf);
%
%create pupil sampling coordinates
thetas = (2*pi/arms)*(0:arms-1);
r = 1/(radial-1)*(0:radial-1);
for i=1:length(r)
    px(i,:) = r(i)*cos(thetas); py(i,:) = r(i)*sin(thetas);
end
[m n] = size(px);
px = reshape(px,1,m*n); py = reshape(py,1,m*n);
%%
%%get EP and XP coordinates via raytrace

for i=1:length(px)
    EPlocal = zGetTrace(1,0,EPsurf,0,0,px(i),py(i));
    x_EP(i) = EPlocal(3) + transEP(1);
    y_EP(i) = EPlocal(4) + transEP(2);
    XPlocal = zGetTrace(1,0,XPsurf,0,0,px(i),py(i));
    x_XP(i) = XPlocal(3) + transXP(1);
    y_XP(i) = XPlocal(4) + transXP(2);
end
m = 1/angularMag;
x_idealXP = (m)*x_EP;
y_idealXP = (m)*y_EP;

x_quiver = x_idealXP-x_XP;
y_quiver = y_idealXP-y_XP;

quiverData = [px;py;x_quiver;y_quiver];

if plotON
    subplot(1,3,1);plot(x_EP,y_EP,'k.')
    subplot(1,3,2);plot(x_XP,y_XP,'bo'); hold on;
                   plot(x_idealXP,y_idealXP,'r.'); legend('actual XP','ideal XP','Location','Best')
    subplot(1,3,3);quiver(px,py,x_quiver,y_quiver);
    title(['Magnification = ',num2str(1/angularMag)])
end


    

