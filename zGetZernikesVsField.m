function [outputData] = zGetZernikesVsField
%% 
%%runs the default settings of ZernikeVsField (Change and save settings in
%%Zemax to alter default settings
fileName =  zGetFile;
fileName = [fileName(1:end-5),'_ZernVsField.txt'];
zGetTextFile(fileName, 'Zvf', ' ', 0);
outputData = zReadZernikeVsField(fileName);
