
-- 1. created to try and simulate large number of Log-file-syncs (LFS).
-- 2. find benefits of IOT and Clusters for parent-child relations.

drop table lfs ;
drop table lfsp ;
drop sequence lfs_seq ;

-- sequence, although later versions use timestamp to generate a number...
create sequence lfs_seq start with 1 cache 100 maxvalue 1000 cycle ;

-- in case we want a parent-child relation...
create table lfsp (
  p_id number           not null,
  p_desc varchar2(64)
);

create index lfsp_pk on lfsp ( p_id ) ;
alter table lfsp add constraint lfsp_pk primary key ( p_id) ;


/**/
create table lfs (
  p_id	    number                              not null, -- hard constraint to parent ?
  lfs_ID    NUMBER                              NOT NULL,
  CREATED   DATE                                NOT NULL,
  lfs_desc  VARCHAR2(64)                        NOT NULL
);
create unique index lfs_pk  on lfs ( p_id, lfs_id   ) ;

alter table lfs add constraint lfs_pk primary key ( p_id, lfs_id ); 
/**/

/*
create table lfs (
  p_id	    number                              not null, -- hard constraint to parent ?
  lfs_ID    NUMBER                              NOT NULL,
  CREATED   DATE                                NOT NULL,
  lfs_desc  VARCHAR2(64)                        NOT NULL
, constraint lsf_pk primary key ( p_id, lfs_id)
)
organization index ;
*/

create unique index lfs_ix1 on lfs ( lfs_desc ) ;

-- this would be less-advantageous, but it often happens.
--create unique index lfs_ix2 on lfs ( lfs_id ) ;


CREATE OR REPLACE procedure ins_lfs (
    pi_n_nr_emps         number default 1  -- default : 1 emp.
  , pi_n_commitsize      number default 1  -- default : commit every rec.
  )
as

--
-- insert n employees, commit after batch or after every record.
--

  n_nr_lfs          number := pi_n_nr_emps ;       -- assign input-parameters
  n_commitsize      number := pi_n_commitsize ;

  i	            number := 0 ;  -- loopcounter
  n_current_commit  number := 0 ;  -- nr inserted in current commit.

  n_nw_emp_id       lfs.lfs_id%type ;

  d_start           date ;
  n_duration        number := 0 ;   -- sysdate - start, unit = sec!
  n_p_id            number := 0 ;   -- paren_id, assume 0-999 or something...

begin

  d_start := sysdate ;

  for i in 1..n_nr_lfs loop

    select to_number (  ltrim ( to_char ( systimestamp   , 'FF2'    ) ) 
                     || ltrim ( to_char ( lfs_seq.nextval, '09999'  ) )
                     || ltrim ( to_char ( systimestamp   , 'SSSSS'  ) ) -- unique withing a day...
                     ) 
         , round ( dbms_random.value( 0, 999) )    
    into n_nw_emp_id, n_p_id
    from dual;

    -- insert into table

    INSERT INTO lfs  ( p_id, lfs_id, created, lfs_desc ) 
	VALUES (
          n_p_id
	, n_nw_emp_id
        , sysdate
	, 'name_'  || to_char ( n_nw_emp_id ) -- think of a more randome varchar..
	);

	n_current_commit := n_current_commit + 1 ;

	if n_current_commit >= n_commitsize then
	  commit ;
	  n_current_commit := 0;
	  --dbms_output.put_line ( 'p_ins_lfs : Committed at record: '  || to_char (i) ) ;
          --dbms_lock.sleep ( 0.01 ) ;
	end if ;

   end loop;

   commit ;  -- final commit, always.
   n_duration := trunc ( ( sysdate - d_start ) * 24 * 60 * 60 );
   if n_duration < 1 then
	n_duration  := 1;
   end if ;

   dbms_output.put_line (  'p_ins_lfs : total inserted: '  || to_char (n_nr_lfs) ) ;
   dbms_output.put_line (  'p_ins_lfs : duraton : '
			|| to_char ( n_duration ) || ' Sec.'
			|| to_char ( n_nr_lfs / n_duration, '999,999.99' )
			|| ' recs/sec'
			) ;

   -- any exceptions go here...

end; -- ins_lfs
/

show errors

CREATE OR REPLACE procedure del_lfs (
    pi_n_nr_emps         number default 1  -- default : 1 emp.
  , pi_n_commitsize      number default 1  -- default : commit every rec.
  )
as

--
-- insert n employees, commit after batch or after every record.
--

  n_nr_lfs          number := pi_n_nr_emps ;       -- assign input-parameters
  n_commitsize      number := pi_n_commitsize ;

  i	            number := 0 ;  -- loopcounter
  n_current_commit  number := 0 ;  -- nr inserted in current commit.

  n_nw_emp_id       employees.employee_id%type ;

  d_start           date ;
  n_duration        number := 0 ;   -- sysdate - start, unit = sec!

begin

  d_start := sysdate ;

  for i in 1..n_nr_lfs loop

    -- delete from table
    -- the old delete: the max lead to locking on the top of the value-range,
    -- and locking is worse if batch-size increases..
    -- delete from lfs where lfs_id = (select max (lfs_id ) from lfs) ;

    -- this looks like the cheapest in cost... why exactly ?  
    delete from bench.lfs 
    where lfs_id = (select max (lfs_id ) from bench.lfs
                    where p_id = to_number ( to_char ( systimestamp , 'FF2' ))   
                   ) 
	  and p_id = to_number ( to_char ( systimestamp , 'FF2' )) ;

    --  this is the simplest statment, but the range scan is apparently more expensive ??
    -- delete /*+ FIRST_ROWS */ from bench.lfs where 
    -- lfs_id > to_number (  ( to_char ( systimestamp , 'FF3' )) * 1000 * 1000 * 1000 * 10  )   
    -- and rownum < 2 

	n_current_commit := n_current_commit + 1 ;

	if n_current_commit >= n_commitsize then
	  commit ;
	  n_current_commit := 0;
	  --dbms_output.put_line ( 'p_ins_lfs : Committed at record: '  || to_char (i) ) ;
	  --dbms_lock.sleep ( 0.01 ) ;
	end if ;

   end loop;

   commit ;  -- final commit, always.
   n_duration := trunc ( ( sysdate - d_start ) * 24 * 60 * 60 );
   if n_duration < 1 then
	n_duration  := 1;
   end if ;

   dbms_output.put_line (  'p_del_lfs : total deleted: '  || to_char (n_nr_lfs) ) ;
   dbms_output.put_line (  'p_del_lfs : duraton : '
			|| to_char ( n_duration ) || ' Sec.'
			|| to_char ( n_nr_lfs / n_duration, '999,999.99' )
			|| ' recs/sec'
			) ;

   -- any exceptions go here...

end; -- del_lfs
/

show errors

set serveroutput on

-- put a resonable amount of data in
execute ins_lfs ( 20046, 1 ) ;

execute del_lfs ( 1000, 1 ) ;

analyze table lfs compute statistics ;

select count ('1') as nr_of_records
from lfs ;
