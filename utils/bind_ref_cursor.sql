variable rc refcursor

declare
     blah number := 42;
begin
  open :rc for
     select *
     from dba_tables x;
end;
/

print rc
