/*
 * B1      B2     | AND     OR
 * --------------------------------
 * true    true   | true    true
 * true    false  | false   true
 * true    null   | null    true
 * false   true   | false   true
 * false   false  | false   false
 * false   null   | false   null
 * null    true   | null    true
 * null    false  | false   null
 * null    null   | null    null
 * --------------------------------
 */

SET SERVEROUTPUT ON

declare

  TYPE tLista IS TABLE OF VARCHAR2 (10);
  aLista tLista := tLista('true','false','null');

  vBO1  number;
  vBO2  number;

  bool_1   boolean;
  bool_2   boolean;

  bool_and boolean;
  bool_or  boolean;

  res_and  varchar2(5);
  res_or   varchar2(5);

  function string_to_bool(str in varchar2) return boolean is begin
    return case when str = 'true'  then true
                when str = 'false' then false
                when str = 'null'  then null end;
    end;

  function bool_to_str(bool in boolean) return varchar2 is begin
    return case when bool =  true   then 'true'
                when bool =  false  then 'false'
                when bool is null   then 'null' end;
    end;

begin

  dbms_output.put_line('B1      B2     | AND     OR');
  dbms_output.put_line('--------------------------------');

        vBO1 := aLista.FIRST;

        LOOP


                EXIT WHEN vBO1 IS NULL;
                vBO2 := aLista.FIRST;

                LOOP

                        EXIT WHEN vBO2 IS NULL;

                        bool_1 := string_to_bool(aLista(vBO1));
                        bool_2 := string_to_bool(aLista(vBO2));

                        bool_and := bool_1 AND bool_2;
                        bool_or  := bool_1 OR  bool_2;

                        res_and  := bool_to_str(bool_and);
                        res_or   := bool_to_str(bool_or );

                        dbms_output.put_line(rpad(aLista(vBO1), 7) || ' ' ||
                        rpad(aLista(vBO2), 7) || '| ' ||
                        rpad(res_and, 7) || ' ' ||
                        rpad(res_or , 7));

                        vBO2 := aLista.NEXT(vBO2);

                END LOOP;

                vBO1 := aLista.NEXT(vBO1);

        END LOOP;

        dbms_output.put_line('--------------------------------');
END;
/
