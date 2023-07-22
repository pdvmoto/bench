
set serveroutput on

declare 

  minsal number       := 3000 ;
  fname varchar2(20)  := 'First%' ;
  dt_before date      := trunc ( sysdate - 7 ) ;
  n_result number     := null ;

begin

  execute immediate '
      select sum ( e.salary) sumsal
      from employees e
      , departments d
      , locations l
      , countries c
      where d.location_id = l.location_id
        and e.department_id = d.department_id
        and l.country_id  = c.country_id
        and e.salary       >= :minsal
        and e.first_name like :fname
        and e.hire_date     < :dt_before ' 
    into n_result 
    using minsal, fname, dt_before ;

    dbms_output.put_line ( ' demo_bindvar, sum = ' || n_result ) ;

end;
/


--
-- sql_id = '6n9249jvs0h2p'
-- 

select /* watermark bind */ '&1' arg1 from dual ;

