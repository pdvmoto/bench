
doc

File:	bench_do_fast.sql : do a primitive benchmark (fast variety).

notes:
	do study the related doc (bench_cu, and sourcecode)
	to improve/adjust the benchmark for your benefit.
#

set serveroutput on
set timing on

spool bench_do

exec ins_emp ( 100, 10 ) ;

exec upd_emp ( 100, 10 ) ;

exec del_emp ( 100, 10 ) ;

spool off

