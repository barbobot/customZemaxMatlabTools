function [connectValid] = zInitializeZemax(saveData)
%%
%%initialize connection to Zemax (needs to be open prior) 
% Starts new lens file, saves data if prompted
%
% INPUTS -----------------------------------------------------------------
% 
% OUTPUTS ----------------------------------------------------------------
%
%connectValid -  0 if connected, -1 if fail
% 
% Revision history information -------------------------------------------
% $Author: Barbara Kruse$
% $Date: 2015/08/28 $
% $Revision: 1 $
% $Revision History: 
% 
%
% Begin Code -------------------------------------------------------------
connectValid = zDDEInit + 1;
if ~connectValid   %tries one time to launch Zemax (typically fails)
    zDDEStart;
    connectValid = zDDEInit + 1;  
end


if connectValid 
    if isempty(saveData)
        saveData = input('Save file currently open in Zemax? (y/n) ','s');
    end

    if sum((saveData == 'y') | (saveData == 'Y')) > 0
        fileSaved = zGetFile
        zSaveFile(fileSaved);
    end

    %% 

    zNewLens;
    zPushLens(4);
else
    disp('Connection to Zemax Failed')
end
