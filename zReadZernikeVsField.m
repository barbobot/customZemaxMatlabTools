function Zdata = zReadZernikeVsField(FileName)    
% function Z = zReadZernikes(FileName)    
% A function that reads Zernike vs Field text files from Zemax.
% 
% Example:
% Z = zReadZernikes('C:\zernikes.txt')
% 
% Returns a 2D matrix of zernike terms vs field 
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
% Zdata          2D matrix of zernike terms vs field 
% 
% Revision history information -------------------------------------------
% $Author: Barbara Kruse $  (modified from Alex Maldonado's ReadZernikes
% script
% $Date: 2015/10/27 $
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
dstr = dstr(31<dstr & dstr<127 | dstr==10);  %%takes out null values
indx = regexp(dstr,'0.0000E+');  %finds the first zero value (should be zero field)
numTerms = str2num( dstr(indx(1)-10:indx(1)-1));
dstr = dstr(indx(1):end);    %cuts out all leading text
data = sscanf(dstr, '%12f');
numField = length(data)/(numTerms+1);
Zdata = reshape(data,numTerms+1,numField)';
end