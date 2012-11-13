
-- 使用方法: 
--    @ins_plsql.sql   入力テーブル 出力テーブル
--   (例) @ins_plsql.sql   HAT420HKKJ_FOR_NEWPART HAT420HKKJ

--   (例) @ins_plsql.sql   user1.intable  user2.outtable
--   (例) @ins_plsql.sql   intable@dblnk  user2.outtable

set verify off
set echo off
set timing on
set time on
set termout  on
set trimspool on



set serveroutput on size 100000
DECLARE
CURSOR c1 IS
     select /*+ FULL */A.*  from &1 A -- where  rownum < 1000
     ;
TYPE t_c1 IS TABLE OF c1%ROWTYPE;
r_c1   t_c1;
tmp_no number :=0;
BEGIN
    open c1;
    LOOP
	    FETCH c1 BULK COLLECT INTO r_c1  limit 10000;
	    FORALL i IN r_c1.FIRST..r_c1.LAST   insert into  &2 values r_c1(i);
		tmp_no := tmp_no  + r_c1.LAST;
--
--        DBMS_OUTPUT.PUT_LINE( 'rec= ' || to_char(r_c1.LAST) );
--
--      rollback;
        commit;
	    EXIT WHEN c1%NOTFOUND;
    END LOOP;
    close c1;
--  rollback;
    commit;
--
    DBMS_OUTPUT.PUT_LINE( 'reccnt= ' || to_char(tmp_no) );
END;
/

