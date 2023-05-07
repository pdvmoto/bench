doc

File:	bench_do.sql : do a primitive benchmark.

notes:
	do study the related doc (bench_cu, and sourcecode)
	to improve/adjust the benchmark for your benefit.
#

set serveroutput on
set timing on

spool bench_do

exec ins_emp ( 10000, 100 ) ;

exec upd_emp ( 10000, 100 ) ;

exec del_emp ( 10000, 100 ) ;


exec ins_emp ( 10000, 100 ) ;

exec upd_emp ( 10000, 100 ) ;

exec del_emp ( 10000, 100 ) ;

spool off

