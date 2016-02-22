function ConfigInserted = zDeleteConfig(n)
%%  Inserts Operand MOFF to top of table 
global ZemaxDDEChannel ZemaxDDETimeout

DDECommand = sprintf('DeleteConfig');
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);  %sends to command line, stores string of reply in Reply variable

ConfigInserted = Reply;%col';

