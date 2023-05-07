--
-- bench_go_run.sql: use this to start slave-scripts for benchmark.
--
-- related : bench_go_start.sql, to set+release starting point.
--
-- note: edit the host command for windows (timetout via bat file) or sleep.
--       on unix:          SQL> host sleep n
--       on older windows: SQL> host sleep.exe n           (sleep.exe from windows sysutils??)
--       on win-7-upward:  SQL> host bench_timeout.bat n   (needs wrapper to exit)
-- 


-- this stmnt will wait for previous transaction.
update semaphore set s='b' ; 

-- now introduce the delay...

@time
-- add delay here...
host bench_timeout 5

@time
	
commit ; 

-- add real work below this line...

set echo on

select count (*) , to_char ( sysdate, 'hh24:mi:ss' ) as now_is from all_objects ;

set echo off




 
