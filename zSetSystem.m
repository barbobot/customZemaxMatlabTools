function SystemData = zSetSystem(unitcode, stopsurf, rayaimingtype, useenvdata, temp, pressure, globalrefsurf)
% zSetSystem - Sets a number of lens system operating data.
%
% Usage : SystemData = zSetSystem(unitcode, stopsurf, rayaimingtype, useenvdata, temp, pressure, globalrefsurf)
%
% This function sets the lens units code (0, 1, 2, or 3 for mm, cm, in , or M), the stop surf number,
% the ray aiming type (0, 1, 2 for none, paraxial, real), the use environment data flag (0 for no, 1 for yes), the current
% temperature and pressure, and the global coordinate reference surface number.
%
% The returned row vector  is formatted as follows:
% numsurfs, unitcode, stopsurf, nonaxialflag, rayaimingtype, useenvdata, temp, pressure, globalrefsurf
% where in addition to the above input parameters, numsurfs is the number of surfaces in the lens and  nonaxialflag is 
% a flag to indicate if the system is non-axial symmetric (0 for false, i.e. it is axial, or 1 if
% the system is not axial).
%
% See also zGetSystem and zGetSystemAper
%

%% Copyright 2002-2009, DPSS, CSIR
% This file is subject to the terms and conditions of the BSD Licence.
% For further details, see the file BSDlicence.txt
%
% Contact : dgriffith@csir.co.za
% 
% 
%
%
%


% $Revision: 221 $

global ZemaxDDEChannel ZemaxDDETimeout
DDECommand = sprintf('SetSystem,%i,%i,%i,%i,%1.20g,%1.20g,%i', unitcode, stopsurf, rayaimingtype, useenvdata, temp, pressure, globalrefsurf);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[ParmsCol,count,errmsg]= sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f,%f');
SystemData = ParmsCol';
