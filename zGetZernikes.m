function [outputZerks] = zGetZernikes(zerkType, pauseTime)
%% 
%% zerkTypes are the following 
% 'Zst' Standard Zernikes
% 'Zfr' Fringe
% 'Zat' "Zernike Annular Terms"
%increase PauseTime if ZernTerms are not writing before file is read
%
fileName =  zGetFile;
fileName = [fileName(1:end-5),'_ZernOut.txt'];
zGetTextFile(fileName, zerkType, ' ', 0); pause(pauseTime);
outputZerks = zReadZernikes(fileName);
