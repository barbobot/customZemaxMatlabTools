function [data] = zRayTraceQuery(wave,mode,numSurf,hx,hy,px,py,skip)
%%
%%
count = 0;
for i=1:numSurf
    if isempty(find(skip == i))
        count = count+1;
        RayTraceData = zGetTrace(wave, mode, i, hx, hy, px, py);
        %error, vigcode, x, y, z, l, m, n, l2, m2, n2, intensity
        [RotationMatrix,ColVector] = zGetGlobalMatrix(i);
        data(count,2:4) = RayTraceData(3:5)+ColVector';
        data(count,1) = i;
    end
end
