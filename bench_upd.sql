
doc

#

set serveroutput on

spool bench_upd

prompt 
prompt add 100 K records to the benchmark schema.
prompt

exec upd_emp ( 10000, 1000 );
exec upd_emp ( 10000       );
exec upd_emp ( 10000, 1000 );
exec upd_emp ( 10000       );
exec upd_emp ( 10000, 1000 );

exec upd_emp ( 10000       );
exec upd_emp ( 10000, 1000 );
exec upd_emp ( 10000       );
exec upd_emp ( 10000, 1000 );
exec upd_emp ( 10000       );

spool off
