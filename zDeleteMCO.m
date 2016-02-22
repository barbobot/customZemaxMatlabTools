function remainMCO = zDeleteMCO
%%  Inserts Operand MOFF to top of table 
global ZemaxDDEChannel ZemaxDDETimeout

DDECommand = sprintf('DeleteMCO');
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);  %sends to command line, stores string of reply in Reply variable

remainMCO = Reply;%col';

