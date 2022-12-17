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
    t.OWNER
    , t.OBJECT_NAME
    , t.OBJECT_TYPE
FROM
    SYS.ALL_OBJECTS t
WHERE
    t.OWNER IN ('S01')
    AND t.OBJECT_TYPE NOT IN ('INDEX')
ORDER BY
    t.OWNER
    , t.OBJECT_TYPE
    , t.OBJECT_NAME;
