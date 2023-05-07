
doc

#

set serveroutput on

spool bench_fill

prompt 
prompt add 100 K records to the benchmark schema.
prompt

exec ins_emp ( 10000, 1000 );
exec ins_emp ( 10000       );
exec ins_emp ( 10000, 1000 );
exec ins_emp ( 10000       );
exec ins_emp ( 10000, 1000 );

exec ins_emp ( 10000       );
exec ins_emp ( 10000, 1000 );
exec ins_emp ( 10000       );
exec ins_emp ( 10000, 1000 );
exec ins_emp ( 10000       );

spool off
