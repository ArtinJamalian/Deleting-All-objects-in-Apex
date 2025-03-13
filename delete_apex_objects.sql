begin 
    for a in (select table_name from object_users) 
    loop
        execute immediate 'alter table "'|| a.table_name || '" disable all triggers';
    end loop;

    for obj in (select object_name, object_type from user_objects order by object_type desc)
    loop
        begin 
            if obj.object_type = 'TABLE' then 
                execute immediate 'DROP ' || obj.object_type || ' "' || obj.object_name || '" CASCADE CONSTRAINTS';
            else 
                execute immediate 'DROP ' || obj.object_type || ' "' || obj.object_name || '" FORCE';
            end if;
        exception 
            when others then continue; 
        end;
    end loop;
end;
