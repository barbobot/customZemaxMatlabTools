function [OPL] = zGetOPTH(surfNum,P_x,P_y, fieldType, fieldVal,ConfigNum)
%%
%%The parameter fieldType is an integer; either 0, 1, or 2, for angles in degrees, object height, or paraxial image height,
% respectively, 3 for real image height.
OPTH = ('C:\Users\Jane\Documents\Zemax\MeritFunction\OPTH.mf');

zLoadMerit(OPTH);
zSetFieldMatrix(fieldType,[0 0 1; 0 fieldVal 1]); %sets field 
wave = 1;
Hx = 0;
Hy = 1;
zSetOperand(1,2,ConfigNum);

for i = 1:length(P_x);
    zSetOperand(i+1,2,surfNum);
    zSetOperand(i+1,3,wave);
    zSetOperand(i+1,4,Hx);
    zSetOperand(i+1,5,Hy);
    zSetOperand(i+1,6,P_x(i));
    zSetOperand(i+1,7,P_y(i));
end
    zPushLens(4); zGetRefresh;
for i=1:length(P_x)
    OPL(i) = zGetOperand(i+1,10);
end
