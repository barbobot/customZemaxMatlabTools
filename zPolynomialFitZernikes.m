function [fits] = zPolynomialFitZernikes(fieldType, maxField, numFieldScans,fieldAxis)

%%the built in Zernike vs Field is cumbersome to verify the negative
%%field behavior, so this script varies field accordingly from -field to
%%+field and gets Zernike Coeff
%%
%%make sure you save the default to Field 2 in Zemax before running
%%%%%
%%WARNING - THIS CAN TAKE AWHILE - I recommend saving the data with Zemax
%%File when done
%%
%% INPUTS :  fieldType : same as defined previously (0-3 (Angle, Obj Height, Parax Image Height, and Real image Height)
%            maxfield : maxValue of field (script will scan +/- max field
%            numFieldScans : number of Scans per field (default = 20)
%            fieldAxis : 1=x-direction 2= y-direction
%% OUTPUTS :
%            linearZernikes = will give vector of field dependence for 1-37
%            Zernike coefficients
%
% REVISION HISTORY
% Written by Barbara Kruse, Oct 27,2015
% Version 1.1;  requires mzDDE toolbox and initiation
%
%% collect Zernikes
%%
%%
%set field to positive
%%get the linear fit output from Zemax
f = [0 0 1]; f(fieldAxis)=maxField;
zSetFieldMatrix(fieldType, [[0 0 1];f]); zPushLens(2); zGetRefresh;
ZvsField = zGetZernikesVsField; pause(10);zPushLens(2); zGetRefresh;
Zpos = zGetZernikes('Zst',10);
%%
f_ = [0 0 1]; f_(fieldAxis)=-maxField;
zSetFieldMatrix(fieldType, [[0 0 1];f_]); zPushLens(2); zGetRefresh;
Zneg = zGetZernikes('Zst',10);
zSetFieldMatrix(fieldType, [[0 0 1];f]); zPushLens(2); zGetRefresh;
%%
%check for symmetry
signChange = Zpos./Zneg;
symCheck = (signChange ==1) + (signChange == -1) + isnan(signChange);
if sum(symCheck) < length(symCheck); notSymmetric = 1; else notSymmetric = 0; end
%
notSymmetric = 1;
if notSymmetric  %%this takes a loooong time!!
    step = maxField/numFieldScans;
    fields = linspace(-maxField,maxField,2*numFieldScans+1);
    f = [0 0 1; 0 0 1];  %to be updated in loop
        for i=1:length(fields)
            f(2,fieldAxis) = fields(i);
            zSetFieldMatrix(fieldType,f);  zPushLens(4); zGetRefresh;
            Zs(i,:) = zGetZernikes('Zst', 10);
            zDDEInit;
        end
    %automatically saves a copy of this data if its collected
    fileName =  zGetFile;
    fileName = [fileName(1:end-5),'_ZernVsField.mat'];
    save(fileName,'fields','fieldType','fieldAxis','Zs');
else %%data is symmetric
    [m n] = size(ZvsField);
    signChange(isnan(signChange))=1; 

    %create negative Field values
    for i = 1:m-1
        Zs(i,:) = ZvsField(m-i+1,:) .* [-1, signChange(1:n-1)];
    end
    Zs(i+1:(m-1)*2+1,:) = ZvsField;
end
    
    
[m n] = size(Zs);

for i=1:n
    fits(:,i) = polyfit(fields,Zs(:,i)',5);
end




