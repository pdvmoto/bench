
doc

File :	bench_cu.sql: create user for bechmark (run as dba!)
	(mainly stolen from hr-benchmark in 9202)
	
additional files : 
	- bench.dmp : contents for schema, with minimal data (record time)
	- bench_fill.sql : add 100k records data to schema (record time)
	- bench_do.sql   : run once (add another 10k records) benchmark (record time)

notes:
 - run multiple sessions to simulate multi-users
 - study ins/upd/del procedures to understand benchmark.
 - play with emp-table and indexes
 - for many, repeated benchmarks : disable job-history to avoid skewed reslult.

#

SET ECHO OFF

PROMPT 
PROMPT specify password for BENCH as parameter 1:
DEFINE pass     = &1
PROMPT 
PROMPT specify default tablespeace for BENCH as parameter 2:
DEFINE tbs      = &2
PROMPT 
PROMPT specify temporary tablespace for BENCH as parameter 3:
DEFINE ttbs     = &3
PROMPT 
PROMPT


CREATE USER BENCH IDENTIFIED BY &pass;

ALTER USER BENCH DEFAULT TABLESPACE &tbs
              QUOTA UNLIMITED ON &tbs;

ALTER USER BENCH TEMPORARY TABLESPACE &ttbs;

GRANT CONNECT  TO BENCH;
GRANT RESOURCE TO BENCH;


PROMPT 
PROMPT Next steps :
prompt
prompt 1. Please import contents of bench.dmp to populate the schema.
Prompt    example : imp bench/bench file=bench.dmp fromuser=hr touser=bench
prompt
prompt 2. fill main table with 100K records : @bench_fill 
prompt    and please not the time it takes to run as a first impression
prompt
prompt 3. run the first benchmark : @bench_do, 
prompt    and save the ouput to get a 2nd impression.
prompt 




