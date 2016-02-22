function [sysData] = zReadSystemData()    
% A function that reads System Prescription data text files from open lens file in Zemax.
% $$$$ ASSUMES INTIALIZED CONNECTION TO ZEMAX
%
%  This function uses eval() to create structure variable names.  Could go
%  unstable.  Do not cross the streams
%  
% INPUTS -----------------------------------------------------------------
% 
% OUTPUTS ----------------------------------------------------------------
%
%   sysData - a structure with all the fields following in either numerical
%           or text form
%   
%      $$ Currently Ignores Fields, Vignetting Factors, and Waves information at
%      bottom of text files
% 
%
% Revision history information -------------------------------------------
% $Author: Barbara Kruse, Will Welch$
% $Date: 2015/08/27 $
% $Revision: 1 $
% $Revision History: 
% 
%
% Begin Code -------------------------------------------------------------
tempFileName =  zGetFile;
%%  if isempty(tempFileName);tempFileName = 'C:\Users\Jane\Documents\Zemax\Samples\LENS';end
tempFileName = [tempFileName(1:end-5),'_Prescription.txt'];   
zGetTextFile(tempFileName, 'Sys', ' ', 0);  %creates text file of prescription data
fileID = fopen(tempFileName);
% read the file data
if fileID ~= -1  
    vals = fileread(tempFileName);
    fclose(fileID);
    % Convert to string
    dstr = sprintf('%s',vals); 
    dstr = dstr(31<dstr & dstr<127 | dstr==10);  %%takes out null values

    % keep only lens data
    GLDstart = regexp(dstr, 'GENERAL LENS DATA:','end');
    dstr = dstr(GLDstart+2:end);
    Fieldstart = regexp(dstr, 'Fields','start');
    dstr = dstr(1:Fieldstart-2);
    lines = regexp(dstr, '\n', 'split');
    % parse the lines into name/value
    pairs = regexp(lines, '(?<name>[^:]*):\s*(?<value>\S*)', 'names');

    %%for EFL modifications below
    EFLadd = [ '_in air     ';'_image space'];
    EFLcount = 1;
    %
    %
    for i = 1:length(pairs)
        chk = size(pairs{1,i});
        if chk(1) ~= 0  %%if field isn't empty
            fieldName = pairs{1,i}.name;
                %% need to modify EFL inputs (because there are two)
                if sum(fieldName(1:23) == 'Effective Focal Length ') == 23;
                    fieldName = ['Effective Focal Length',EFLadd(EFLcount,:)];
                    q = find((pairs{1,i}.value) == '(');
                    pairs{1,i}.value = pairs{1,i}.value(1:q-1);  %pulls off text at end
                    EFLcount = EFLcount +1;
                end
            %%lots of cleaning up fieldnames
            fieldName = strtrim(fieldName);  %get rid of trailing spaces
            %%pull out all the bad characters
            fieldName = strrep(fieldName,'F/#','Fnum');
            fieldName = strrep(fieldName,' ','_');
            fieldName = strrep(fieldName,'(','_');
            fieldName = strrep(fieldName,')','_');
            fieldName = strrep(fieldName,'[','_');
            fieldName = strrep(fieldName,']','_');
            fieldName = strrep(fieldName,'-','_');
            fieldName = strrep(fieldName,'/','_');
            fieldName = strrep(fieldName,'.','_');  %%not sure if there is a more efficient way to do this
            %
            textVal = str2num(pairs{1,i}.value);  %%attempts to convert data to numerical
            if length(textVal) ~= 0   %%if numerical data
                cmdLine = ['sysData.',fieldName,' = ',pairs{1,i}.value,';'];
                eval(cmdLine);    %creates structure with numeric data
            else   %string type system data
                cmdLine = ['sysData.',fieldName,' = ''',pairs{1,i}.value,''';'];
                eval(cmdLine);     %creates new structure with text data
            end  %if
        end% if empty array
    end  %for loop  (all the datas)
else
    disp('Couldn''t get Prescription Data');
    sysData = [];
end



