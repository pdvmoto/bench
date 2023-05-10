set linesize 160
set trimspool on
set feedb off
set ver off
set timing off

column sql_text    format A80

column username    format A10
column buff_gets   format 99999999
column execs       format 999999
column per_exe     format 9999,999
column hash_value  format 99999999999
column sql_id      format A14
column chld        format 9999

column numrows     format 999,999
column cpu_sec     format 9999.99
column ela_sec     format 9999.99
column every_x_sec format 9999.99

column chld               format 99
column datatype           format A15
column bind_variable      format A15
column bind_value         format A20
column bind_vals          format A60 trunc


column operation   format A35
column options     format A15
column on_object   format A35
column cost        format 9999999

column acc_pred     format A30 
column fltr_pred    format A30 


column explout format A60 newline

prompt
prompt ---------------------------------------------------------------------
prompt
prompt statement, statistics from sh-pool....
prompt .
prompt . 

set head off

select 
  'Column          Value'
, '--------------  -----------'                as explout
, 'User          : ' ||  u.username            as explout
, 'sql_id =      : ' || sql_id                 as explout
, 'child_number  : ' || child_number           as explout
, 'plan_hash     : ' || plan_hash_value        as explout
, 'Executions    : ' || a.executions           as explout   
, 'Rows processed: ' || rows_processed         as explout
, 'Buffer_gets   : ' || a.buffer_gets          as explout
, 'disk_reads    : ' || disk_reads             as explout
, 'bufgets/exe   : ' || round ( a.buffer_gets/(decode ( executions    , 0, 1, executions     )), 2)  as explout
, 'bufgets/row   : ' || round ( a.buffer_gets/(decode ( rows_processed, 0, 1, rows_processed )), 2)  as explout
, 'Fist load     : ' || first_load_time        as explout
, 'elapsed (sec) : ' || round ( elapsed_time/1000000                                           , 2) as explout
--, a.cpu_time/(1000000) as cpu_sec, a.elapsed_time/(1000000) as ela_sec --, to_char ( ( sysdate - to_date ( a.first_load_time, 'YYYY-MM-DD/HH24:MI:SS' )  ) * 24 * 3600 / a.executions, '99,999.99' ) as every_x_sec --, a.* 
from v$sql a 
, dba_users u 
where u.user_id = a.parsing_user_id 
and a.sql_id = '&1'
order by sql_id, child_number
/

set head off

-- sqltxt from sh-pool memory

prompt .
prompt The SQL_TEXT from Sh-Pool...
prompt .

select  t.sql_text
from v$sqltext t
where sql_id = '&1'
order by piece
/

set head on


/**** skipped now ****/


