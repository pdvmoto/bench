CREATE OR REPLACE procedure ins_emp_fast (
    pi_n_nr_emps         number default 1  -- default : 1 emp.
  , pi_n_commitsize      number default 1  -- default : commit every rec.
  )
as

--
-- insert n employees, commit after batch or after every record.
--

  n_nr_emps         number := pi_n_nr_emps ;       -- assign input-parameters
  n_commitsize      number := pi_n_commitsize ;

  i	            number := 0 ;  -- loopcounter
  n_current_commit  number := 0 ;  -- nr inserted in current commit.

  n_nw_emp_id       employees.employee_id%type ;
  vc_nw_job_id      jobs.job_id%type ;
  n_nw_mgr_id       employees.employee_id%type ;
  n_nw_dept_id      departments.department_id%type ;

  d_start           date ;
  n_duration        number := 0 ;   -- sysdate - start, unit = sec!

  n_jobcount        number := 0 ;   -- workaround for v 8.x,
  n_mgrcount        number := 0 ;   -- no inline select in dbms_random.
  n_deptcount       number := 0 ;

begin

  -- initialize some counters, only once, outside loop.
  select count (*)
  into n_jobcount
  from jobs;

  select count (*)
  into n_mgrcount
  from departments
  where manager_id is not null ;

  select count (*)
  into n_deptcount
  from departments;

  d_start := sysdate ;

    vc_nw_job_id := 'AD_ASST';

    n_nw_mgr_id := 204 ;

    n_nw_dept_id := 250 ;


  for i in 1..n_nr_emps loop

    -- assign new values : id, job, mgr, dept
    -- selecting these will simulate in-cache lookup-table usage

    select employees_seq.nextval
    into n_nw_emp_id
    from dual;

    -- insert into table

    INSERT INTO EMPLOYEES (
	   EMPLOYEE_ID
	, FIRST_NAME
	, LAST_NAME
	, EMAIL
	, PHONE_NUMBER
	, HIRE_DATE
	, JOB_ID
	, SALARY
	, COMMISSION_PCT
	, MANAGER_ID
	, DEPARTMENT_ID )
	VALUES (
	  n_nw_emp_id
	, 'First_'  || to_char ( n_nw_emp_id )
	, 'Last_'   || to_char ( n_nw_emp_id )
	, 'MAIL_'   || to_char ( n_nw_emp_id ) || '@'
          || 'dpt_' || to_char( n_nw_dept_id ) || '.com'
	, '+31 (' || to_char (n_nw_dept_id) || ') ' || to_char ( n_nw_emp_id )
	, trunc ( sysdate )
	, vc_nw_job_id
	, 3000
	, 0
	, n_nw_mgr_id
	, n_nw_dept_id
	);

	n_current_commit := n_current_commit + 1 ;

	if n_current_commit >= n_commitsize then
	  commit ;
	  n_current_commit := 0;
	  --dbms_output.put_line ( 'p_ins_emp : Committed at record: '  || to_char (i) ) ;
	end if ;

   end loop;

   commit ;  -- final commit, always.
   n_duration := trunc ( ( sysdate - d_start ) * 24 * 60 * 60 );
   if n_duration < 1 then
	n_duration  := 1;
   end if ;

   dbms_output.put_line (  'p_ins_emp : total inserted: '  || to_char (n_nr_emps) ) ;
   dbms_output.put_line (  'p_ins_emp : duraton : '
			|| to_char ( n_duration ) || ' Sec.'
			|| to_char ( n_nr_emps / n_duration, '999,999.99' )
			|| ' recs/sec'
			) ;

   -- any exceptions go here...

end; -- ins_emp_fast
/

show errors

execute ins_emp_fast ( 100, 10 ) ;
