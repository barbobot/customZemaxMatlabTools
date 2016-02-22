function Z = zReadZernikes(FileName)    
% function Z = zReadZernikes(FileName)    
% A function that reads Zernike data text files from Zemax.
% 
% Example:
% Z = zReadZernikes('C:\zernikes.txt')
% 
% Returns a vector of zernikes returned by matlab. Works with Zemax 2012. 
% 
% Required Packages: mzdde
% 
% INPUTS -----------------------------------------------------------------
% 
% FileName      The path and file name of the text file where the zernike
%               data is stored.
% 
% OUTPUTS ----------------------------------------------------------------
% 
% Z             A vector of values containing the zernike terms in the text
%               file.
% 
% Revision history information -------------------------------------------
% $Author: Alex Maldonado $
% $Date: 2012/09/01 $
% $Revision: 1 $
% $Revision History: 
% 
%
% Begin Code -------------------------------------------------------------

fileID = fopen(FileName);
% read the file data
vals = fileread(FileName);
fclose(fileID);
% Convert to string
dstr = sprintf('%s',vals);
% Remove term strings
idnZstr = regexp(dstr, '[^\d\s\.\-\Z\t]');
dstr(idnZstr) = [];
% Now remove zernike term numbers 
idn = regexp(dstr,'\n');
dstr(idn) = [];
dstr = dstr(600:end);
% Find the zernike coefficients starting line 
Zs = regexp(dstr, 'Z(?=\s)','start');
% Remove blank space
dstr = dstr(Zs:end);
dstr = strtrim(dstr);
% Identify starting point for coefficients
idz = regexp(dstr, 'Z\s\s', 'end');
% Put the coefficients into a vector
for k = 1:length(idz)
    ztemp = dstr(idz(k)+5:idz(k)+20);
    Z(k) = str2num(ztemp);
end
end