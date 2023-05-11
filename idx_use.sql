
column sql_id format A13
column phv format 99999999999 
column execs format 99,999,999
column  operation format A20
column  options format A25

select sqa.sql_id, sqa.plan_hash_value phv 
, sqp.operation, sqp.options, sqa.executions execs
--, sqp.* 
from 
v$sql_plan sqp
, v$sqlarea sqa 
where sqp.sql_id = sqa.sql_id
and object_name = upper ( '&1' )
order by sqa.executions desc ;

