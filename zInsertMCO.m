function MCOinserted = zInsertMCO(OperType)
%%  Inserts Operand MOFF to top of table 
global ZemaxDDEChannel ZemaxDDETimeout

%OperType = 'MOFF';
DDECommand = sprintf('InsertMCO,%s',OperType);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);  %sends to command line, stores string of reply in Reply variable

MCOinserted = Reply;%col';

