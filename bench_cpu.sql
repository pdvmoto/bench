
rem test speed of cpu based upon speed of plsql

set serveroutput on

declare 
	starttime	date ;
	f1              number ;
	f2              number ;
	counter		number := 0 ;
	secs		number := 10 ;  -- was 10
	secs_cc         number ;
	startcc		number ;
	nruns		number := 4 ;
	nrun		number := 0 ;
        
begin

    secs_cc := secs * 100 ;

    while nrun < nruns loop


	counter   := 0 ;
	startcc   := dbms_utility.get_time ;
 
	dbms_output.put_line ('util get_time: ' || startcc );

	while ( dbms_utility.get_time - startcc) < secs_cc loop

		counter := counter + 1 ;

	end loop ;

	dbms_output.put_line ('Loop without multiply: ' 
			|| to_char ( counter, '999,999,999') 
			|| ' or loops/sec: ' || to_char ( counter / secs, '999,999,999') );

	counter   := 0 ;
	startcc   := dbms_utility.get_time ;

	while ( dbms_utility.get_time - startcc) < secs_cc loop
	
		f1 := ( 1234.5678 ** nrun ) * ( 9876.54321 * nrun ) * 99999.99999 ;
		f2 := ( 123.45679 ** nrun ) * ( 9876.54322 * nrun ) * 88888.88888 ;
	
		counter := counter + 1 ;
	end loop ;

	dbms_output.put_line ('Loop with    multiply: ' 
 			|| to_char ( counter, '999,999,999') 
			|| ' or loops/sec: ' || to_char ( counter / secs, '999,999,999') );

	nrun := nrun + 1 ;

    end loop ;


end ;
/
