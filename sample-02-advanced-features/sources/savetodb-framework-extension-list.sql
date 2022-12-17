set echo off
set feedback off
set linesize 4000
set pagesize 1000
set trimout on
set trimspool on
set underline=
set tab off
set newpage none
COLUMN OBJECT_TYPE FORMAT A11
COLUMN OWNER FORMAT A13
COLUMN OBJECT_NAME FORMAT A45

SELECT
    t.OBJECT_TYPE
    , t.OWNER
    , t.OBJECT_NAME
FROM
    SYS.ALL_OBJECTS t
WHERE
    t.OWNER IN ('XLS')
    AND t.OBJECT_TYPE NOT IN ('INDEX')
ORDER BY
    t.OWNER
    , t.OBJECT_TYPE
    , t.OBJECT_NAME;
