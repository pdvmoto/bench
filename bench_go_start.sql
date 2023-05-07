
drop table semaphore ; 

create table semaphore 
( s varchar2(10) 
, constraint semaphore_pk primary key ( s ) 
); 

insert into semaphore select 'a' from dual ;
commit ;

-- the table exists, and has 1 records that others can update..
-- now set a lock...

update semaphore set s='b' ; 

accept abc prompt "hit enter to signal start..." 

commit ; 

 
