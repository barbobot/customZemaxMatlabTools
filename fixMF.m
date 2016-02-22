zDDEInit;
target = 'RAGY';
match = 0;
count = 395;
while match < 4
    count = count + 1;
    zSetOperand(8,1,count);
    t = zPushLens(10); 
    if t < 0 
            t = zPushLens(10); 
    end
    zGetRefresh;
    OPERAND(count,1:4) = zGetOperand(8,1);
    match = sum(target ==   OPERAND(count,1:4));
    zDDEInit;
end
