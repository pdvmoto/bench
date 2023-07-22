
doc
	spin_1sql.sql : run a regular SQL, repeatedly

notes:
 - needed to deminstrate sql_freq and the analysis from v$sql_plan
#




declare 
    /* pio */

    starttime	date ;
    str 		varchar2(1000);
    x 		  number;
    n_wait	number := 1 ; /* sec in between ? */

    vc_sql  varchar2(1000) ;

    vc_ename varchar2(30) ;
    d_hire   date ;
    vc_dname varchar2(100) ; 
    vc_loc   varchar2(100) ;

    vc_find  varchar2(100) := 'MILLER' ; 

    n_max   number := 10000000 ;
    n_count number := 0 ; 

begin

  starttime := sysdate ;

  vc_sql := '
      select e.ename, e.hiredate, d.dname, d.loc
      from emp e, dept d
      where 1=1
      and e.deptno = d.deptno   
      and e.ename = :vc_ename
      order by e.ename, d.dname
  ' ; 

  while (sysdate - starttime) < &1 / (24 * 3600) loop

    begin

      execute immediate vc_sql 
        into vc_ename, d_hire, vc_dname, vc_loc 
        using vc_find ; 

      n_count := n_count + 1 ; 

      sys.dbms_session.sleep(n_wait);

      exception   -- overkill, for the moment...
      when others then 
        dbms_output.put_line ( 'Exception...' ) ;
        DBMS_OUTPUT.PUT_LINE (SQLERRM);
        -- DBMS_OUTPUT.PUT_LINE (SQLCODE);

    end ;     

  end loop; -- while.

  dbms_output.put_line ( 'spin_1sql: .' )  ;
  dbms_output.put_line ( 'spin_1sql: count: ' ||  n_count ) ;
  dbms_output.put_line ( 'spin_1sql: .' )  ;

end ;
/

-- select to_char ( sysdate, 'HH24:MI:SS' ) from dual;

--@sleep &1

--select to_char ( sysdate, 'HH24:MI:SS' ) from dual;

