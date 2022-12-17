ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE USER SAMPLE07_USER1 IDENTIFIED BY "change_on_install" DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP PROFILE "DEFAULT" ACCOUNT UNLOCK;

ALTER  USER SAMPLE07_USER1 IDENTIFIED BY "Usr_2011#_Xls4168";

GRANT CREATE SESSION                                                TO SAMPLE07_USER1;

GRANT SELECT, INSERT, UPDATE, DELETE ON S07.EMPLOYEE_TERRITORIES    TO SAMPLE07_USER1;
GRANT SELECT, INSERT, UPDATE, DELETE ON S07.EMPLOYEES               TO SAMPLE07_USER1;
GRANT SELECT, INSERT, UPDATE, DELETE ON S07.TERRITORIES             TO SAMPLE07_USER1;
GRANT SELECT, INSERT, UPDATE, DELETE ON S07.REGIONS                 TO SAMPLE07_USER1;
