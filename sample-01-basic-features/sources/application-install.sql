ALTER SESSION SET "_ORACLE_SCRIPT"=true;

ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS' NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SSXFF' NLS_TIMESTAMP_TZ_FORMAT='YYYY-MM-DD HH24:MI:SSXFF TZH:TZM';

CREATE USER S01
  IDENTIFIED BY "change_on_install"
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    PROFILE "DEFAULT"
    ACCOUNT UNLOCK
    QUOTA UNLIMITED ON USERS;

CREATE TABLE S01.CASHBOOK (
    ID NUMBER,
    "DATE" DATE DEFAULT NULL,
    ACCOUNT VARCHAR2(50) DEFAULT NULL,
    ITEM VARCHAR2(50) DEFAULT NULL,
    COMPANY VARCHAR2(50) DEFAULT NULL,
    DEBIT BINARY_DOUBLE DEFAULT NULL,
    CREDIT BINARY_DOUBLE DEFAULT NULL,
    CONSTRAINT PK_CASHBOOK PRIMARY KEY (ID)
);

CREATE SEQUENCE S01.SQ_CASHBOOK_ID
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 1E28
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE TRIGGER S01.TR_CASHBOOK_ID
 BEFORE INSERT OR UPDATE
 ON S01.CASHBOOK
REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
BEGIN
  IF :new.ID IS NULL THEN
    SELECT SQ_CASHBOOK_ID.NEXTVAL INTO :new.ID FROM dual;
  END IF;
END;
/

CREATE INDEX S01.IX_CASHBOOK_DATE ON S01.CASHBOOK("DATE");

CREATE TABLE S01.FORMATS (
  ID NUMBER,
  TABLE_SCHEMA VARCHAR2(30) NOT NULL,
  TABLE_NAME VARCHAR2(30) NOT NULL,
  TABLE_EXCEL_FORMAT_XML NCLOB,
  CONSTRAINT PK_FORMATS PRIMARY KEY (ID)
);

CREATE SEQUENCE S01.SQ_FORMATS_ID
  INCREMENT BY 1
  START WITH 21
  MAXVALUE 1E28
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE TRIGGER S01.TR_FORMATS_ID
  BEFORE INSERT OR UPDATE
  ON S01.FORMATS
REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
BEGIN
  IF :NEW.ID IS NULL THEN
    SELECT SQ_FORMATS_ID.NEXTVAL INTO :NEW.ID FROM DUAL;
  END IF;
END;
/

CREATE UNIQUE INDEX S01.IX_FORMATS ON S01.FORMATS (TABLE_SCHEMA, TABLE_NAME);

CREATE TABLE S01.WORKBOOKS (
  ID NUMBER,
  NAME VARCHAR2(128) NOT NULL,
  TEMPLATE VARCHAR2(255),
  DEFINITION NCLOB NOT NULL,
  TABLE_SCHEMA VARCHAR2(30),
  CONSTRAINT PK_WORKBOOKS PRIMARY KEY (ID)
);

CREATE SEQUENCE S01.SQ_WORKBOOKS_ID
  INCREMENT BY 1
  START WITH 21
  MAXVALUE 1E28
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE TRIGGER S01.TR_WORKBOOKS_ID
  BEFORE INSERT OR UPDATE
  ON S01.WORKBOOKS
REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
BEGIN
  IF :NEW.ID IS NULL THEN
    SELECT SQ_WORKBOOKS_ID.NEXTVAL INTO :NEW.ID FROM DUAL;
  END IF;
END;
/

CREATE UNIQUE INDEX S01.IX_WORKBOOKS ON S01.WORKBOOKS (NAME);

CREATE VIEW S01.VIEW_CASHBOOK
AS
SELECT
    p.ID
    , p."DATE"
    , p.ACCOUNT
    , p.ITEM
    , p.COMPANY
    , p.DEBIT
    , p.CREDIT
FROM
    S01.CASHBOOK p
;

CREATE VIEW S01.XL_ACTIONS_ONLINE_HELP
AS
SELECT
    t.OWNER AS TABLE_SCHEMA
    , t.OBJECT_NAME AS TABLE_NAME
    , CAST(NULL AS VARCHAR2(30)) COLUMN_NAME
    , 'Actions' AS EVENT_NAME
    , t.OWNER AS HANDLER_SCHEMA
    , 'See Online Help' AS HANDLER_NAME
    , 'HTTP' AS HANDLER_TYPE
    , TO_NCLOB('https://www.savetodb.com/samples/sample' || SUBSTR(t.OWNER, 2, 2) || '-' || LOWER(t.OBJECT_NAME) || CASE WHEN USER LIKE 'sample%' THEN '_' || USER ELSE '' END) AS HANDLER_CODE
    , CAST(NULL AS VARCHAR(256)) AS TARGET_WORKSHEET
    , 1 AS MENU_ORDER
    , 0 AS EDIT_PARAMETERS
    , t.OBJECT_TYPE
FROM
    SYS.ALL_OBJECTS t
WHERE
    t.OWNER = 'S01'
    AND t.OBJECT_TYPE IN ('TABLE', 'VIEW', 'PROCEDURE')
    AND NOT t.OBJECT_NAME LIKE 'XL_%'
    AND NOT t.OBJECT_NAME LIKE '%_INSERT'
    AND NOT t.OBJECT_NAME LIKE '%_UPDATE'
    AND NOT t.OBJECT_NAME LIKE '%_DELETE'
    AND NOT t.OBJECT_NAME LIKE '%_CHANGE'
    AND NOT t.OBJECT_NAME LIKE '%_MERGE'
;

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK (
    ACCOUNT IN VARCHAR2
    , ITEM IN VARCHAR2
    , COMPANY IN VARCHAR2
    , DATA OUT SYS_REFCURSOR
    )
IS
BEGIN

OPEN DATA FOR
SELECT
    p.ID
    , p."DATE"
    , p.ACCOUNT
    , p.ITEM
    , p.COMPANY
    , p.DEBIT
    , p.CREDIT
FROM
    S01.CASHBOOK p
WHERE
    COALESCE(USP_CASHBOOK.ACCOUNT, p.ACCOUNT, ' ') = COALESCE(p.ACCOUNT, ' ')
    AND COALESCE(USP_CASHBOOK.ITEM, p.ITEM, ' ') = COALESCE(p.ITEM, ' ')
    AND COALESCE(USP_CASHBOOK.COMPANY, p.COMPANY, ' ') = COALESCE(p.COMPANY, ' ');

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK2 (
    ACCOUNT IN VARCHAR2
    , ITEM IN VARCHAR2
    , COMPANY IN VARCHAR2
    , DATA OUT SYS_REFCURSOR
    )
IS
BEGIN

OPEN DATA FOR
SELECT
    p.ID
    , p."DATE"
    , p.ACCOUNT
    , p.ITEM
    , p.COMPANY
    , p.DEBIT
    , p.CREDIT
FROM
    S01.CASHBOOK p
WHERE
    COALESCE(USP_CASHBOOK2.ACCOUNT, p.ACCOUNT, ' ') = COALESCE(p.ACCOUNT, ' ')
    AND COALESCE(USP_CASHBOOK2.ITEM, p.ITEM, ' ') = COALESCE(p.ITEM, ' ')
    AND COALESCE(USP_CASHBOOK2.COMPANY, p.COMPANY, ' ') = COALESCE(p.COMPANY, ' ');

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK3 (
    ACCOUNT IN VARCHAR2
    , ITEM IN VARCHAR2
    , COMPANY IN VARCHAR2
    , DATA OUT SYS_REFCURSOR
    )
IS
BEGIN

OPEN DATA FOR
SELECT
    p.ID
    , p."DATE"
    , p.ACCOUNT
    , p.ITEM
    , p.COMPANY
    , p.DEBIT
    , p.CREDIT
FROM
    S01.CASHBOOK p
WHERE
    COALESCE(USP_CASHBOOK3.ACCOUNT, p.ACCOUNT, ' ') = COALESCE(p.ACCOUNT, ' ')
    AND COALESCE(USP_CASHBOOK3.ITEM, p.ITEM, ' ') = COALESCE(p.ITEM, ' ')
    AND COALESCE(USP_CASHBOOK3.COMPANY, p.COMPANY, ' ') = COALESCE(p.COMPANY, ' ');

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK4 (
    ACCOUNT IN VARCHAR2
    , ITEM IN VARCHAR2
    , COMPANY IN VARCHAR2
    , DATA OUT SYS_REFCURSOR
    )
IS
BEGIN

OPEN DATA FOR
SELECT
    p.ID
    , p."DATE"
    , p.ACCOUNT
    , p.ITEM
    , p.COMPANY
    , p.DEBIT
    , p.CREDIT
FROM
    S01.CASHBOOK p
WHERE
    COALESCE(USP_CASHBOOK4.ACCOUNT, p.ACCOUNT, ' ') = COALESCE(p.ACCOUNT, ' ')
    AND COALESCE(USP_CASHBOOK4.ITEM, p.ITEM, ' ') = COALESCE(p.ITEM, ' ')
    AND COALESCE(USP_CASHBOOK4.COMPANY, p.COMPANY, ' ') = COALESCE(p.COMPANY, ' ');

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK2_INSERT (
    ID NUMBER,
    "DATE" DATE,
    ACCOUNT VARCHAR2,
    ITEM VARCHAR2,
    COMPANY VARCHAR2,
    DEBIT DOUBLE PRECISION,
    CREDIT DOUBLE PRECISION
    )
IS
BEGIN

INSERT INTO S01.CASHBOOK
    ( "DATE"
    , ACCOUNT
    , COMPANY
    , ITEM
    , DEBIT
    , CREDIT
    )
VALUES
    ( "DATE"
    , ACCOUNT
    , COMPANY
    , ITEM
    , DEBIT
    , CREDIT
    );

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK2_UPDATE (
    ID NUMBER,
    "DATE" DATE,
    ACCOUNT VARCHAR2,
    ITEM VARCHAR2,
    COMPANY VARCHAR2,
    DEBIT DOUBLE PRECISION,
    CREDIT DOUBLE PRECISION
    )
IS
BEGIN

UPDATE S01.CASHBOOK P
SET
    "DATE" = USP_CASHBOOK2_UPDATE."DATE"
    , ACCOUNT = USP_CASHBOOK2_UPDATE.ACCOUNT
    , COMPANY = USP_CASHBOOK2_UPDATE.COMPANY
    , ITEM = USP_CASHBOOK2_UPDATE.ITEM
    , DEBIT = USP_CASHBOOK2_UPDATE.DEBIT
    , CREDIT = USP_CASHBOOK2_UPDATE.CREDIT
WHERE
    P.ID = USP_CASHBOOK2_UPDATE.ID;

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK2_DELETE (
    ID NUMBER
    )
IS
BEGIN

DELETE FROM S01.CASHBOOK
WHERE
    ID = USP_CASHBOOK2_DELETE.ID;

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK3_CHANGE (
    COLUMN_NAME VARCHAR2
    , CELL_VALUE VARCHAR2
    , CELL_NUMBER_VALUE DOUBLE PRECISION
    , CELL_DATETIME_VALUE DATE
    , ID NUMBER
    )
IS
BEGIN

IF COLUMN_NAME = 'DATE' THEN

    UPDATE S01.CASHBOOK P
    SET
        "DATE" = CELL_DATETIME_VALUE
    WHERE
        P.ID = USP_CASHBOOK3_CHANGE.ID;

ELSIF COLUMN_NAME = 'DEBIT' THEN

    UPDATE S01.CASHBOOK P
    SET
        DEBIT = CELL_NUMBER_VALUE
    WHERE
        P.ID = USP_CASHBOOK3_CHANGE.ID;

ELSIF COLUMN_NAME = 'CREDIT' THEN

    UPDATE S01.CASHBOOK P
    SET
        CREDIT = CELL_NUMBER_VALUE
    WHERE
        P.ID = USP_CASHBOOK3_CHANGE.ID;

ELSIF COLUMN_NAME = 'ACCOUNT' THEN

    UPDATE S01.CASHBOOK P
    SET
        ACCOUNT = CELL_VALUE
    WHERE
        P.ID = USP_CASHBOOK3_CHANGE.ID;

ELSIF COLUMN_NAME = 'COMPANY' THEN

    UPDATE S01.CASHBOOK P
    SET
        COMPANY = CELL_VALUE
    WHERE
        P.ID = USP_CASHBOOK3_CHANGE.ID;

ELSIF COLUMN_NAME = 'ITEM' THEN

    UPDATE S01.CASHBOOK P
    SET
        ITEM = CELL_VALUE
    WHERE
        P.ID = USP_CASHBOOK3_CHANGE.ID;

END IF;

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASHBOOK4_MERGE (
    ID NUMBER,
    "DATE" DATE,
    ACCOUNT VARCHAR2,
    ITEM VARCHAR2,
    COMPANY VARCHAR2,
    DEBIT DOUBLE PRECISION,
    CREDIT DOUBLE PRECISION
    )
IS
BEGIN

MERGE INTO S01.CASHBOOK t
USING
    (SELECT
        USP_CASHBOOK4_MERGE.ID ID
        , USP_CASHBOOK4_MERGE."DATE"  "DATE"
        , USP_CASHBOOK4_MERGE.ACCOUNT ACCOUNT
        , USP_CASHBOOK4_MERGE.COMPANY COMPANY
        , USP_CASHBOOK4_MERGE.ITEM    ITEM
        , USP_CASHBOOK4_MERGE.DEBIT   DEBIT
        , USP_CASHBOOK4_MERGE.CREDIT  CREDIT
     FROM DUAL
    ) s
ON (t.ID = s.ID)
WHEN MATCHED THEN
    UPDATE SET
        "DATE" = s."DATE"
        , ACCOUNT = s.ACCOUNT
        , COMPANY = s.COMPANY
        , ITEM = s.ITEM
        , DEBIT = s.DEBIT
        , CREDIT = s.CREDIT
WHEN NOT MATCHED THEN
    INSERT ("DATE", ACCOUNT, COMPANY, ITEM, DEBIT, CREDIT) VALUES (s."DATE", s.ACCOUNT, s.COMPANY, s.ITEM, s.DEBIT, s.CREDIT);

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASH_BY_MONTHS (
    Year IN NUMBER
    , DATA OUT SYS_REFCURSOR
    )
IS
BEGIN

OPEN DATA FOR
SELECT
    ROW_NUMBER() OVER (ORDER BY p.SECTION, p.ITEM NULLS FIRST, p.COMPANY NULLS FIRST) AS SORT_ORDER
    , p.SECTION
    , MAX(p."LEVEL") AS "LEVEL"
    , p.ITEM
    , p.COMPANY
    , CASE WHEN p.COMPANY IS NOT NULL THEN CONCAT('  ', MAX(p.NAME)) ELSE MAX(p.NAME) END AS "Name"
    , CASE WHEN p.SECTION = 1 THEN SUM(p."Jan") WHEN p.SECTION = 5 THEN SUM(p."Dec") ELSE SUM(p.TOTAL) END AS "Total"
    , SUM(p."Jan") AS "Jan"
    , SUM(p."Feb") AS "Feb"
    , SUM(p."Mar") AS "Mar"
    , SUM(p."Apr") AS "Apr"
    , SUM(p."May") AS "May"
    , SUM(p."Jun") AS "Jun"
    , SUM(p."Jul") AS "Jul"
    , SUM(p."Aug") AS "Aug"
    , SUM(p."Sep") AS "Sep"
    , SUM(p."Oct") AS "Oct"
    , SUM(p."Nov") AS "Nov"
    , SUM(p."Dec") AS "Dec"
FROM
    (
    -- Companies
    SELECT
        p.SECTION
        , 2 AS "LEVEL"
        , p.ITEM
        , p.COMPANY
        , p.COMPANY AS NAME
        , p.PERIOD
        , p.AMOUNT AS TOTAL
        , CASE p.PERIOD WHEN  1 THEN p.AMOUNT ELSE 0 END AS "Jan"
        , CASE p.PERIOD WHEN  2 THEN p.AMOUNT ELSE 0 END AS "Feb"
        , CASE p.PERIOD WHEN  3 THEN p.AMOUNT ELSE 0 END AS "Mar"
        , CASE p.PERIOD WHEN  4 THEN p.AMOUNT ELSE 0 END AS "Apr"
        , CASE p.PERIOD WHEN  5 THEN p.AMOUNT ELSE 0 END AS "May"
        , CASE p.PERIOD WHEN  6 THEN p.AMOUNT ELSE 0 END AS "Jun"
        , CASE p.PERIOD WHEN  7 THEN p.AMOUNT ELSE 0 END AS "Jul"
        , CASE p.PERIOD WHEN  8 THEN p.AMOUNT ELSE 0 END AS "Aug"
        , CASE p.PERIOD WHEN  9 THEN p.AMOUNT ELSE 0 END AS "Sep"
        , CASE p.PERIOD WHEN 10 THEN p.AMOUNT ELSE 0 END AS "Oct"
        , CASE p.PERIOD WHEN 11 THEN p.AMOUNT ELSE 0 END AS "Nov"
        , CASE p.PERIOD WHEN 12 THEN p.AMOUNT ELSE 0 END AS "Dec"
    FROM
        (
        SELECT
            CAST(CASE WHEN p.CREDIT IS NOT NULL THEN 3 ELSE 2 END AS NUMBER) AS SECTION
            , CAST(CASE WHEN p.CREDIT IS NOT NULL THEN 'Expenses' ELSE 'Income' END AS VARCHAR2(255)) AS ITEM_TYPE
            , p.ITEM
            , p.COMPANY
            , EXTRACT(MONTH FROM p."DATE") AS PERIOD
            , CASE WHEN p.CREDIT IS NOT NULL THEN COALESCE(p.CREDIT, 0) - COALESCE(p.DEBIT, 0) ELSE COALESCE(p.DEBIT, 0) - COALESCE(p.CREDIT, 0) END AS AMOUNT
        FROM
            S01.CASHBOOK p
        WHERE
            p.COMPANY IS NOT NULL
            AND EXTRACT(YEAR FROM p."DATE") = Year
        ) p

    -- Total Items
    UNION ALL
    SELECT
        p.SECTION
        , 1 AS "LEVEL"
        , p.ITEM
        , NULL AS COMPANY
        , p.ITEM AS NAME
        , p.PERIOD
        , p.AMOUNT AS TOTAL
        , CASE p.PERIOD WHEN  1 THEN p.AMOUNT ELSE 0 END AS "Jan"
        , CASE p.PERIOD WHEN  2 THEN p.AMOUNT ELSE 0 END AS "Feb"
        , CASE p.PERIOD WHEN  3 THEN p.AMOUNT ELSE 0 END AS "Mar"
        , CASE p.PERIOD WHEN  4 THEN p.AMOUNT ELSE 0 END AS "Apr"
        , CASE p.PERIOD WHEN  5 THEN p.AMOUNT ELSE 0 END AS "May"
        , CASE p.PERIOD WHEN  6 THEN p.AMOUNT ELSE 0 END AS "Jun"
        , CASE p.PERIOD WHEN  7 THEN p.AMOUNT ELSE 0 END AS "Jul"
        , CASE p.PERIOD WHEN  8 THEN p.AMOUNT ELSE 0 END AS "Aug"
        , CASE p.PERIOD WHEN  9 THEN p.AMOUNT ELSE 0 END AS "Sep"
        , CASE p.PERIOD WHEN 10 THEN p.AMOUNT ELSE 0 END AS "Oct"
        , CASE p.PERIOD WHEN 11 THEN p.AMOUNT ELSE 0 END AS "Nov"
        , CASE p.PERIOD WHEN 12 THEN p.AMOUNT ELSE 0 END AS "Dec"
    FROM
        (
        SELECT
            CAST(CASE WHEN p.CREDIT IS NOT NULL THEN 3 ELSE 2 END AS NUMBER) AS SECTION
            , CAST(CASE WHEN p.CREDIT IS NOT NULL THEN 'Expenses' ELSE 'Income' END AS VARCHAR2(255)) AS ITEM_TYPE
            , p.ITEM
            , EXTRACT(MONTH FROM p."DATE") AS PERIOD
            , CASE WHEN p.CREDIT IS NOT NULL THEN COALESCE(p.CREDIT, 0) - COALESCE(p.DEBIT, 0) ELSE COALESCE(p.DEBIT, 0) - COALESCE(p.CREDIT, 0) END AS AMOUNT
        FROM
            S01.CASHBOOK p
        WHERE
            p.ITEM IS NOT NULL
            AND EXTRACT(YEAR FROM p."DATE") = Year
        ) p

    -- Total Income/Expenses
    UNION ALL
    SELECT
        p.SECTION
        , 0 AS "LEVEL"
        , NULL AS ITEM
        , NULL AS COMPANY
        , p.ITEM_TYPE AS NAME
        , p.PERIOD
        , p.AMOUNT AS TOTAL
        , CASE p.PERIOD WHEN  1 THEN p.AMOUNT ELSE 0 END AS "Jan"
        , CASE p.PERIOD WHEN  2 THEN p.AMOUNT ELSE 0 END AS "Feb"
        , CASE p.PERIOD WHEN  3 THEN p.AMOUNT ELSE 0 END AS "Mar"
        , CASE p.PERIOD WHEN  4 THEN p.AMOUNT ELSE 0 END AS "Apr"
        , CASE p.PERIOD WHEN  5 THEN p.AMOUNT ELSE 0 END AS "May"
        , CASE p.PERIOD WHEN  6 THEN p.AMOUNT ELSE 0 END AS "Jun"
        , CASE p.PERIOD WHEN  7 THEN p.AMOUNT ELSE 0 END AS "Jul"
        , CASE p.PERIOD WHEN  8 THEN p.AMOUNT ELSE 0 END AS "Aug"
        , CASE p.PERIOD WHEN  9 THEN p.AMOUNT ELSE 0 END AS "Sep"
        , CASE p.PERIOD WHEN 10 THEN p.AMOUNT ELSE 0 END AS "Oct"
        , CASE p.PERIOD WHEN 11 THEN p.AMOUNT ELSE 0 END AS "Nov"
        , CASE p.PERIOD WHEN 12 THEN p.AMOUNT ELSE 0 END AS "Dec"
    FROM
        (
        SELECT
            CAST(CASE WHEN p.CREDIT IS NOT NULL THEN 3 ELSE 2 END AS NUMBER) AS SECTION
            , CASE WHEN p.CREDIT IS NOT NULL THEN 'Total Expenses' ELSE 'Total Income' END AS ITEM_TYPE
            , EXTRACT(MONTH FROM p."DATE") AS PERIOD
            , CASE WHEN p.CREDIT IS NOT NULL THEN COALESCE(p.CREDIT, 0) - COALESCE(p.DEBIT, 0) ELSE COALESCE(p.DEBIT, 0) - COALESCE(p.CREDIT, 0) END AS AMOUNT
        FROM
            S01.CASHBOOK p
        WHERE
            EXTRACT(YEAR FROM p."DATE") = Year
        ) p

    -- Net Chanhge
    UNION ALL
    SELECT
        4 AS SECTION
        , 0 AS "LEVEL"
        , NULL AS ITEM
        , NULL AS COMPANY
        , 'Net Change' AS NAME
        , p.PERIOD
        , p.AMOUNT AS TOTAL
        , CASE p.PERIOD WHEN  1 THEN p.AMOUNT ELSE 0 END AS "Jan"
        , CASE p.PERIOD WHEN  2 THEN p.AMOUNT ELSE 0 END AS "Feb"
        , CASE p.PERIOD WHEN  3 THEN p.AMOUNT ELSE 0 END AS "Mar"
        , CASE p.PERIOD WHEN  4 THEN p.AMOUNT ELSE 0 END AS "Apr"
        , CASE p.PERIOD WHEN  5 THEN p.AMOUNT ELSE 0 END AS "May"
        , CASE p.PERIOD WHEN  6 THEN p.AMOUNT ELSE 0 END AS "Jun"
        , CASE p.PERIOD WHEN  7 THEN p.AMOUNT ELSE 0 END AS "Jul"
        , CASE p.PERIOD WHEN  8 THEN p.AMOUNT ELSE 0 END AS "Aug"
        , CASE p.PERIOD WHEN  9 THEN p.AMOUNT ELSE 0 END AS "Sep"
        , CASE p.PERIOD WHEN 10 THEN p.AMOUNT ELSE 0 END AS "Oct"
        , CASE p.PERIOD WHEN 11 THEN p.AMOUNT ELSE 0 END AS "Nov"
        , CASE p.PERIOD WHEN 12 THEN p.AMOUNT ELSE 0 END AS "Dec"
    FROM
        (
        SELECT
            EXTRACT(MONTH FROM p."DATE") AS PERIOD
            , CASE WHEN p.CREDIT IS NOT NULL THEN COALESCE(p.CREDIT, 0) - COALESCE(p.DEBIT, 0) ELSE COALESCE(p.DEBIT, 0) - COALESCE(p.CREDIT, 0) END AS AMOUNT
        FROM
            S01.CASHBOOK p
        WHERE
            EXTRACT(YEAR FROM p."DATE") = Year
        ) p

    -- Opening balance
    UNION ALL
    SELECT
        1 AS SECTION
        , 0 AS "LEVEL"
        , NULL AS ITEM
        , NULL AS COMPANY
        , 'Opening Balance' AS NAME
        , p.PERIOD
        , NULL AS TOTAL
        , CASE p.PERIOD WHEN  1 THEN p.AMOUNT ELSE 0 END AS "Jan"
        , CASE p.PERIOD WHEN  2 THEN p.AMOUNT ELSE 0 END AS "Feb"
        , CASE p.PERIOD WHEN  3 THEN p.AMOUNT ELSE 0 END AS "Mar"
        , CASE p.PERIOD WHEN  4 THEN p.AMOUNT ELSE 0 END AS "Apr"
        , CASE p.PERIOD WHEN  5 THEN p.AMOUNT ELSE 0 END AS "May"
        , CASE p.PERIOD WHEN  6 THEN p.AMOUNT ELSE 0 END AS "Jun"
        , CASE p.PERIOD WHEN  7 THEN p.AMOUNT ELSE 0 END AS "Jul"
        , CASE p.PERIOD WHEN  8 THEN p.AMOUNT ELSE 0 END AS "Aug"
        , CASE p.PERIOD WHEN  9 THEN p.AMOUNT ELSE 0 END AS "Sep"
        , CASE p.PERIOD WHEN 10 THEN p.AMOUNT ELSE 0 END AS "Oct"
        , CASE p.PERIOD WHEN 11 THEN p.AMOUNT ELSE 0 END AS "Nov"
        , CASE p.PERIOD WHEN 12 THEN p.AMOUNT ELSE 0 END AS "Dec"
    FROM
        (
        SELECT
            p.PERIOD
            , p.AMOUNT
        FROM
            (
            SELECT
                d.PERIOD
                , p."DATE" AS DATE1
                , COALESCE(P.DEBIT, 0) - COALESCE(P.CREDIT, 0) AS AMOUNT
            FROM
                (
                    SELECT 1 AS PERIOD FROM DUAL
                    UNION ALL SELECT 2 FROM DUAL
                    UNION ALL SELECT 3 FROM DUAL
                    UNION ALL SELECT 4 FROM DUAL
                    UNION ALL SELECT 5 FROM DUAL
                    UNION ALL SELECT 6 FROM DUAL
                    UNION ALL SELECT 7 FROM DUAL
                    UNION ALL SELECT 8 FROM DUAL
                    UNION ALL SELECT 9 FROM DUAL
                    UNION ALL SELECT 10 FROM DUAL
                    UNION ALL SELECT 11 FROM DUAL
                    UNION ALL SELECT 12 FROM DUAL
                ) d
                , S01.CASHBOOK p
            ) p
        WHERE
            EXTRACT(YEAR FROM p.DATE1) < Year
            OR (EXTRACT(YEAR FROM p.DATE1) = Year AND EXTRACT(MONTH FROM p.DATE1) < p.PERIOD)
        ) p

    -- Closing balance
    UNION ALL
    SELECT
        5 AS SECTION
        , 0 AS "LEVEL"
        , NULL AS ITEM
        , NULL AS COMPANY
        , 'Closing Balance' AS NAME
        , p.PERIOD
        , NULL AS TOTAL
        , CASE p.PERIOD WHEN  1 THEN p.AMOUNT ELSE 0 END AS "Jan"
        , CASE p.PERIOD WHEN  2 THEN p.AMOUNT ELSE 0 END AS "Feb"
        , CASE p.PERIOD WHEN  3 THEN p.AMOUNT ELSE 0 END AS "Mar"
        , CASE p.PERIOD WHEN  4 THEN p.AMOUNT ELSE 0 END AS "Apr"
        , CASE p.PERIOD WHEN  5 THEN p.AMOUNT ELSE 0 END AS "May"
        , CASE p.PERIOD WHEN  6 THEN p.AMOUNT ELSE 0 END AS "Jun"
        , CASE p.PERIOD WHEN  7 THEN p.AMOUNT ELSE 0 END AS "Jul"
        , CASE p.PERIOD WHEN  8 THEN p.AMOUNT ELSE 0 END AS "Aug"
        , CASE p.PERIOD WHEN  9 THEN p.AMOUNT ELSE 0 END AS "Sep"
        , CASE p.PERIOD WHEN 10 THEN p.AMOUNT ELSE 0 END AS "Oct"
        , CASE p.PERIOD WHEN 11 THEN p.AMOUNT ELSE 0 END AS "Nov"
        , CASE p.PERIOD WHEN 12 THEN p.AMOUNT ELSE 0 END AS "Dec"
    FROM
        (
        SELECT
            p.PERIOD
            , p.AMOUNT
        FROM
            (
            SELECT
                d.PERIOD
                , p."DATE" AS DATE1
                , COALESCE(P.DEBIT, 0) - COALESCE(P.CREDIT, 0) AS AMOUNT
            FROM
                (
                    SELECT 1 AS PERIOD FROM DUAL
                    UNION ALL SELECT 2 FROM DUAL
                    UNION ALL SELECT 3 FROM DUAL
                    UNION ALL SELECT 4 FROM DUAL
                    UNION ALL SELECT 5 FROM DUAL
                    UNION ALL SELECT 6 FROM DUAL
                    UNION ALL SELECT 7 FROM DUAL
                    UNION ALL SELECT 8 FROM DUAL
                    UNION ALL SELECT 9 FROM DUAL
                    UNION ALL SELECT 10 FROM DUAL
                    UNION ALL SELECT 11 FROM DUAL
                    UNION ALL SELECT 12 FROM DUAL
                ) d
                , S01.CASHBOOK p
            ) p
        WHERE
            EXTRACT(YEAR FROM p.DATE1) < Year
            OR (EXTRACT(YEAR FROM p.DATE1) = Year AND EXTRACT(MONTH FROM p.DATE1) <= p.PERIOD)
        ) p
    ) p
GROUP BY
    p.SECTION
    , p.ITEM
    , p.COMPANY
ORDER BY
    SORT_ORDER;

END;
/

CREATE OR REPLACE PROCEDURE S01.USP_CASH_BY_MONTHS_CHANGE (
    COLUMN_NAME VARCHAR2
    , CELL_NUMBER_VALUE NUMBER
    , SECTION NUMBER
    , ITEM VARCHAR2
    , COMPANY VARCHAR2
    , YEAR NUMBER
    )
AS
    month1 NUMBER;
    start_date DATE;
    end_date DATE;
    id1 NUMBER;
    count1 NUMBER;
    date1 DATE;
    account1 VARCHAR2(50);
BEGIN

month1 := INSTR('    Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ', ' ' || COLUMN_NAME || ' ') / 4;

IF month1 < 1 THEN RETURN; END IF;

start_date := ADD_MONTHS(COALESCE(start_date, TRUNC(CURRENT_DATE, 'YEAR')), month1 - 1);

end_date := ADD_MONTHS(TRUNC(start_date, 'YEAR'), month1) - INTERVAL '1' DAY;

SELECT
    MAX(id), COUNT(*)
INTO
    id1, count1
FROM
    S01.CASHBOOK t
WHERE
    t.ITEM = USP_CASH_BY_MONTHS_CHANGE.ITEM AND COALESCE(t.COMPANY, ' ') = COALESCE(USP_CASH_BY_MONTHS_CHANGE.COMPANY, ' ') AND t."DATE" BETWEEN start_date AND end_date;

IF count1 = 0 THEN
    IF ITEM IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'Select a row with an item');
        RETURN;
    END IF;

    SELECT
        MAX(ID)
    INTO
        id1
    FROM
        S01.CASHBOOK t
    WHERE
        t.ITEM = USP_CASH_BY_MONTHS_CHANGE.ITEM AND COALESCE(t.COMPANY, ' ') = COALESCE(USP_CASH_BY_MONTHS_CHANGE.COMPANY, ' ') AND t."DATE" < end_date;

    IF id1 IS NOT NULL THEN

        SELECT "DATE", ACCOUNT INTO date1, account1 FROM S01.CASHBOOK WHERE ID = id1;

        IF EXTRACT(DAY FROM date1) > EXTRACT(DAY FROM end_date) THEN
            date1 := end_date;
        ELSE
            date1 := ADD_MONTHS(ADD_MONTHS(date1, -EXTRACT(month FROM date1)), month1);
        END IF;
    ELSE
        date1 := end_date;
    END IF;

    INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT)
        VALUES (date1, account1, ITEM, COMPANY,
            CASE WHEN SECTION = 3 THEN NULL ELSE CELL_NUMBER_VALUE END,
            CASE WHEN SECTION = 3 THEN CELL_NUMBER_VALUE ELSE NULL END);

    RETURN;
END IF;

IF count1 > 1 THEN
    RAISE_APPLICATION_ERROR(-20101, 'The cell has more than one underlying record');
    RETURN;
END IF;

UPDATE S01.CASHBOOK
SET
    DEBIT = CASE WHEN SECTION = 3 THEN NULL ELSE CELL_NUMBER_VALUE END
    , CREDIT = CASE WHEN SECTION = 3 THEN CELL_NUMBER_VALUE ELSE NULL END
WHERE
    ID = id1;

END;
/

INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-01-10', 'Bank', 'Revenue', 'Customer C1', 200000, NULL);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-01-10', 'Bank', 'Expenses', 'Supplier S1', NULL, 50000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-01-31', 'Bank', 'Payroll', NULL, NULL, 85000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-01-31', 'Bank', 'Taxes', 'Individual Income Tax', NULL, 15000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-01-31', 'Bank', 'Taxes', 'Payroll Taxes', NULL, 15000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-02-10', 'Bank', 'Revenue', 'Customer C1', 300000, NULL);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-02-10', 'Bank', 'Revenue', 'Customer C2', 100000, NULL);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-02-10', 'Bank', 'Expenses', 'Supplier S1', NULL, 100000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-02-10', 'Bank', 'Expenses', 'Supplier S2', NULL, 50000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-02-28', 'Bank', 'Payroll', NULL, NULL, 85000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-02-28', 'Bank', 'Taxes', 'Individual Income Tax', NULL, 15000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-02-28', 'Bank', 'Taxes', 'Payroll Taxes', NULL, 15000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-10', 'Bank', 'Revenue', 'Customer C1', 300000, NULL);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-10', 'Bank', 'Revenue', 'Customer C2', 200000, NULL);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-10', 'Bank', 'Revenue', 'Customer C3', 100000, NULL);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-15', 'Bank', 'Taxes', 'Corporate Income Tax', NULL, 100000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-31', 'Bank', 'Payroll', NULL, NULL, 170000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-31', 'Bank', 'Taxes', 'Individual Income Tax', NULL, 30000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-31', 'Bank', 'Taxes', 'Payroll Taxes', NULL, 30000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-31', 'Bank', 'Expenses', 'Supplier S1', NULL, 100000);
INSERT INTO S01.CASHBOOK ("DATE", ACCOUNT, ITEM, COMPANY, DEBIT, CREDIT) VALUES ('2024-03-31', 'Bank', 'Expenses', 'Supplier S2', NULL, 50000);

DECLARE
    str VARCHAR2(32767);
BEGIN
    str := '<table name="s01.usp_cash_by_months"><columnFormats><column name="" property="ListObjectName" value="Sheet1_Table16" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium15" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="sort_order" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="sort_order" property="Address" value="$C$4" type="String"/><column name="sort_order" property="NumberFormat" value="General" type="String"/><column name="section" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="section" property="Address" value="$D$4" type="String"/><column name="section" property="NumberFormat" value="General" type="String"/><column name="level" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="level" property="Address" value="$E$4" type="String"/><column name="level" property="NumberFormat" value="General" type="String"/><column name="item" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="item" property="Address" value="$F$4" type="String"/><column name="item" property="NumberFormat" value="General" type="String"/><column name="company" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="company" property="Address" value="$G$4" type="String"/><column name="company" property="NumberFormat" value="General" type="String"/><column name="Name" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Name" property="Address" value="$H$4" type="String"/><column name="Name" property="ColumnWidth" value="21.43" type="Double"/><column name="Name" property="NumberFormat" value="General" type="String"/><column name="Total" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Total" property="Address" value="$I$4" type="String"/><column name="Total" property="ColumnWidth" value="8.43" type="Double"/><column name="Total" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Jan" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jan" property="Address" value="$J$4" type="String"/><column name="Jan" property="ColumnWidth" value="10" type="Double"/><column name="Jan" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Feb" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Feb" property="Address" value="$K$4" type="String"/><column name="Feb" property="ColumnWidth" value="10" type="Double"/><column name="Feb" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Mar" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Mar" property="Address" value="$L$4" type="String"/><column name="Mar" property="ColumnWidth" value="10" type="Double"/><column name="Mar" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Apr" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Apr" property="Address" value="$M$4" type="String"/><column name="Apr" property="ColumnWidth" value="10" type="Double"/><column name="Apr" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="May" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="May" property="Address" value="$N$4" type="String"/><column name="May" property="ColumnWidth" value="10" type="Double"/><column name="May" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Jun" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jun" property="Address" value="$O$4" type="String"/><column name="Jun" property="ColumnWidth" value="10" type="Double"/><column name="Jun" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Jul" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jul" property="Address" value="$P$4" type="String"/><column name="Jul" property="ColumnWidth" value="10" type="Double"/><column name="Jul" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Aug" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Aug" property="Address" value="$Q$4" type="String"/><column name="Aug" property="ColumnWidth" value="10" type="Double"/><column name="Aug" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Sep" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Sep" property="Address" value="$R$4" type="String"/><column name="Sep" property="ColumnWidth" value="10" type="Double"/><column name="Sep" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Oct" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Oct" property="Address" value="$S$4" type="String"/><column name="Oct" property="ColumnWidth" value="10" type="Double"/><column name="Oct" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Nov" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Nov" property="Address" value="$T$4" type="String"/><column name="Nov" property="ColumnWidth" value="10" type="Double"/><column name="Nov" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="Dec" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Dec" property="Address" value="$U$4" type="String"/><column name="Dec" property="ColumnWidth" value="10" type="Double"/><column name="Dec" property="NumberFormat" value="#,##0;[Red]-#,##0;" type="String"/><column name="_RowNum" property="FormatConditions(1).AppliesToTable" value="True" type="Boolean"/><column name="_RowNum" property="FormatConditions(1).AppliesTo.Address" value="$B$4:$U$20" type="String"/><column name="_RowNum" property="FormatConditions(1).Type" value="2" type="Double"/><column name="_RowNum" property="FormatConditions(1).Priority" value="3" type="Double"/><column name="_RowNum" property="FormatConditions(1).Formula1" value="=$E4&lt;2" type="String"/><column name="_RowNum" property="FormatConditions(1).Font.Bold" value="True" type="Boolean"/><column name="_RowNum" property="FormatConditions(2).AppliesToTable" value="True" type="Boolean"/><column name="_RowNum" property="FormatConditions(2).AppliesTo.Address" value="$B$4:$U$20" type="String"/><column name="_RowNum" property="FormatConditions(2).Type" value="2" type="Double"/><column name="_RowNum" property="FormatConditions(2).Priority" value="4" type="Double"/><column name="_RowNum" property="FormatConditions(2).Formula1" value="=AND($E4=0,$D4&gt;1,$D4&lt;5)" type="String"/><column name="_RowNum" property="FormatConditions(2).Font.Bold" value="True" type="Boolean"/><column name="_RowNum" property="FormatConditions(2).Font.Color" value="16777215" type="Double"/><column name="_RowNum" property="FormatConditions(2).Font.ThemeColor" value="1" type="Double"/><column name="_RowNum" property="FormatConditions(2).Font.TintAndShade" value="0" type="Double"/><column name="_RowNum" property="FormatConditions(2).Interior.Color" value="6773025" type="Double"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/></columnFormats><views><view name="All columns"><column name="" property="ListObjectName" value="cash_by_month" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="sort_order" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="section" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="level" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Name" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jan" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Feb" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Mar" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Apr" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="May" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jun" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jul" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Aug" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Sep" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Oct" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Nov" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Dec" property="EntireColumn.Hidden" value="False" type="Boolean"/></view><view name="Default"><column name="" property="ListObjectName" value="cash_by_month" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="sort_order" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="section" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="level" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="Name" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jan" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Feb" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Mar" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Apr" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="May" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jun" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Jul" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Aug" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Sep" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Oct" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Nov" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="Dec" property="EntireColumn.Hidden" value="False" type="Boolean"/></view></views></table>';
    INSERT INTO S01.FORMATS (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('S01', 'USP_CASH_BY_MONTHS', str);
    str := '<table name="s01.cashbook"><columnFormats><column name="" property="ListObjectName" value="cashbook" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium2" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="True" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="id" property="Address" value="$C$4" type="String"/><column name="id" property="ColumnWidth" value="4.29" type="Double"/><column name="id" property="NumberFormat" value="General" type="String"/><column name="id" property="Validation.Type" value="1" type="Double"/><column name="id" property="Validation.Operator" value="1" type="Double"/><column name="id" property="Validation.Formula1" value="-2147483648" type="String"/><column name="id" property="Validation.Formula2" value="2147483647" type="String"/><column name="id" property="Validation.AlertStyle" value="1" type="Double"/><column name="id" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="id" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="id" property="Validation.ShowInput" value="True" type="Boolean"/><column name="id" property="Validation.ShowError" value="True" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="Address" value="$D$4" type="String"/><column name="date" property="ColumnWidth" value="11.43" type="Double"/><column name="date" property="NumberFormat" value="m/d/yyyy" type="String"/><column name="date" property="Validation.Type" value="4" type="Double"/><column name="date" property="Validation.Operator" value="5" type="Double"/><column name="date" property="Validation.Formula1" value="12/31/1899" type="String"/><column name="date" property="Validation.AlertStyle" value="1" type="Double"/><column name="date" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="date" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="date" property="Validation.ShowInput" value="True" type="Boolean"/><column name="date" property="Validation.ShowError" value="True" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="Address" value="$E$4" type="String"/><column name="account" property="ColumnWidth" value="12.14" type="Double"/><column name="account" property="NumberFormat" value="General" type="String"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="Address" value="$F$4" type="String"/><column name="item" property="ColumnWidth" value="20.71" type="Double"/><column name="item" property="NumberFormat" value="General" type="String"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="Address" value="$G$4" type="String"/><column name="company" property="ColumnWidth" value="20.71" type="Double"/><column name="company" property="NumberFormat" value="General" type="String"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="Address" value="$H$4" type="String"/><column name="debit" property="ColumnWidth" value="11.43" type="Double"/><column name="debit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="debit" property="Validation.Type" value="2" type="Double"/><column name="debit" property="Validation.Operator" value="4" type="Double"/><column name="debit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="debit" property="Validation.AlertStyle" value="1" type="Double"/><column name="debit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="debit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="debit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="debit" property="Validation.ShowError" value="True" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="Address" value="$I$4" type="String"/><column name="credit" property="ColumnWidth" value="11.43" type="Double"/><column name="credit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="credit" property="Validation.Type" value="2" type="Double"/><column name="credit" property="Validation.Operator" value="4" type="Double"/><column name="credit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="credit" property="Validation.AlertStyle" value="1" type="Double"/><column name="credit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="credit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="credit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="credit" property="Validation.ShowError" value="True" type="Boolean"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/></columnFormats><views><view name="All rows"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/></view><view name="Incomes"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view><view name="Expenses"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view></views></table>';
    INSERT INTO S01.FORMATS (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('S01', 'CASHBOOK', str);
    str := '<table name="s01.view_cashbook"><columnFormats><column name="" property="ListObjectName" value="view_cashbook" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium2" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="True" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="id" property="Address" value="$C$4" type="String"/><column name="id" property="ColumnWidth" value="4.29" type="Double"/><column name="id" property="NumberFormat" value="General" type="String"/><column name="id" property="Validation.Type" value="1" type="Double"/><column name="id" property="Validation.Operator" value="1" type="Double"/><column name="id" property="Validation.Formula1" value="-2147483648" type="String"/><column name="id" property="Validation.Formula2" value="2147483647" type="String"/><column name="id" property="Validation.AlertStyle" value="1" type="Double"/><column name="id" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="id" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="id" property="Validation.ShowInput" value="True" type="Boolean"/><column name="id" property="Validation.ShowError" value="True" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="Address" value="$D$4" type="String"/><column name="date" property="ColumnWidth" value="11.43" type="Double"/><column name="date" property="NumberFormat" value="m/d/yyyy" type="String"/><column name="date" property="Validation.Type" value="4" type="Double"/><column name="date" property="Validation.Operator" value="5" type="Double"/><column name="date" property="Validation.Formula1" value="12/31/1899" type="String"/><column name="date" property="Validation.AlertStyle" value="1" type="Double"/><column name="date" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="date" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="date" property="Validation.ShowInput" value="True" type="Boolean"/><column name="date" property="Validation.ShowError" value="True" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="Address" value="$E$4" type="String"/><column name="account" property="ColumnWidth" value="12.14" type="Double"/><column name="account" property="NumberFormat" value="General" type="String"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="Address" value="$F$4" type="String"/><column name="item" property="ColumnWidth" value="20.71" type="Double"/><column name="item" property="NumberFormat" value="General" type="String"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="Address" value="$G$4" type="String"/><column name="company" property="ColumnWidth" value="20.71" type="Double"/><column name="company" property="NumberFormat" value="General" type="String"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="Address" value="$H$4" type="String"/><column name="debit" property="ColumnWidth" value="11.43" type="Double"/><column name="debit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="debit" property="Validation.Type" value="2" type="Double"/><column name="debit" property="Validation.Operator" value="4" type="Double"/><column name="debit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="debit" property="Validation.AlertStyle" value="1" type="Double"/><column name="debit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="debit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="debit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="debit" property="Validation.ShowError" value="True" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="Address" value="$I$4" type="String"/><column name="credit" property="ColumnWidth" value="11.43" type="Double"/><column name="credit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="credit" property="Validation.Type" value="2" type="Double"/><column name="credit" property="Validation.Operator" value="4" type="Double"/><column name="credit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="credit" property="Validation.AlertStyle" value="1" type="Double"/><column name="credit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="credit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="credit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="credit" property="Validation.ShowError" value="True" type="Boolean"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/></columnFormats><views><view name="All rows"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/></view><view name="Incomes"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view><view name="Expenses"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view></views></table>';
    INSERT INTO S01.FORMATS (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('S01', 'VIEW_CASHBOOK', str);
    str := '<table name="s01.usp_cashbook"><columnFormats><column name="" property="ListObjectName" value="usp_cashbook" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium2" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="True" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="id" property="Address" value="$C$4" type="String"/><column name="id" property="ColumnWidth" value="4.29" type="Double"/><column name="id" property="NumberFormat" value="General" type="String"/><column name="id" property="Validation.Type" value="1" type="Double"/><column name="id" property="Validation.Operator" value="1" type="Double"/><column name="id" property="Validation.Formula1" value="-2147483648" type="String"/><column name="id" property="Validation.Formula2" value="2147483647" type="String"/><column name="id" property="Validation.AlertStyle" value="1" type="Double"/><column name="id" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="id" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="id" property="Validation.ShowInput" value="True" type="Boolean"/><column name="id" property="Validation.ShowError" value="True" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="Address" value="$D$4" type="String"/><column name="date" property="ColumnWidth" value="11.43" type="Double"/><column name="date" property="NumberFormat" value="m/d/yyyy" type="String"/><column name="date" property="Validation.Type" value="4" type="Double"/><column name="date" property="Validation.Operator" value="5" type="Double"/><column name="date" property="Validation.Formula1" value="12/31/1899" type="String"/><column name="date" property="Validation.AlertStyle" value="1" type="Double"/><column name="date" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="date" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="date" property="Validation.ShowInput" value="True" type="Boolean"/><column name="date" property="Validation.ShowError" value="True" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="Address" value="$E$4" type="String"/><column name="account" property="ColumnWidth" value="12.14" type="Double"/><column name="account" property="NumberFormat" value="General" type="String"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="Address" value="$F$4" type="String"/><column name="item" property="ColumnWidth" value="20.71" type="Double"/><column name="item" property="NumberFormat" value="General" type="String"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="Address" value="$G$4" type="String"/><column name="company" property="ColumnWidth" value="20.71" type="Double"/><column name="company" property="NumberFormat" value="General" type="String"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="Address" value="$H$4" type="String"/><column name="debit" property="ColumnWidth" value="11.43" type="Double"/><column name="debit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="debit" property="Validation.Type" value="2" type="Double"/><column name="debit" property="Validation.Operator" value="4" type="Double"/><column name="debit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="debit" property="Validation.AlertStyle" value="1" type="Double"/><column name="debit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="debit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="debit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="debit" property="Validation.ShowError" value="True" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="Address" value="$I$4" type="String"/><column name="credit" property="ColumnWidth" value="11.43" type="Double"/><column name="credit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="credit" property="Validation.Type" value="2" type="Double"/><column name="credit" property="Validation.Operator" value="4" type="Double"/><column name="credit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="credit" property="Validation.AlertStyle" value="1" type="Double"/><column name="credit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="credit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="credit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="credit" property="Validation.ShowError" value="True" type="Boolean"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/></columnFormats><views><view name="All rows"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/></view><view name="Incomes"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view><view name="Expenses"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view></views></table>';
    INSERT INTO S01.FORMATS (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('S01', 'USP_CASHBOOK',  str);
    str := '<table name="s01.usp_cashbook2"><columnFormats><column name="" property="ListObjectName" value="usp_cashbook2" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium2" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="True" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="id" property="Address" value="$C$4" type="String"/><column name="id" property="ColumnWidth" value="4.29" type="Double"/><column name="id" property="NumberFormat" value="General" type="String"/><column name="id" property="Validation.Type" value="1" type="Double"/><column name="id" property="Validation.Operator" value="1" type="Double"/><column name="id" property="Validation.Formula1" value="-2147483648" type="String"/><column name="id" property="Validation.Formula2" value="2147483647" type="String"/><column name="id" property="Validation.AlertStyle" value="1" type="Double"/><column name="id" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="id" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="id" property="Validation.ShowInput" value="True" type="Boolean"/><column name="id" property="Validation.ShowError" value="True" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="Address" value="$D$4" type="String"/><column name="date" property="ColumnWidth" value="11.43" type="Double"/><column name="date" property="NumberFormat" value="m/d/yyyy" type="String"/><column name="date" property="Validation.Type" value="4" type="Double"/><column name="date" property="Validation.Operator" value="5" type="Double"/><column name="date" property="Validation.Formula1" value="12/31/1899" type="String"/><column name="date" property="Validation.AlertStyle" value="1" type="Double"/><column name="date" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="date" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="date" property="Validation.ShowInput" value="True" type="Boolean"/><column name="date" property="Validation.ShowError" value="True" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="Address" value="$E$4" type="String"/><column name="account" property="ColumnWidth" value="12.14" type="Double"/><column name="account" property="NumberFormat" value="General" type="String"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="Address" value="$F$4" type="String"/><column name="item" property="ColumnWidth" value="20.71" type="Double"/><column name="item" property="NumberFormat" value="General" type="String"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="Address" value="$G$4" type="String"/><column name="company" property="ColumnWidth" value="20.71" type="Double"/><column name="company" property="NumberFormat" value="General" type="String"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="Address" value="$H$4" type="String"/><column name="debit" property="ColumnWidth" value="11.43" type="Double"/><column name="debit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="debit" property="Validation.Type" value="2" type="Double"/><column name="debit" property="Validation.Operator" value="4" type="Double"/><column name="debit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="debit" property="Validation.AlertStyle" value="1" type="Double"/><column name="debit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="debit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="debit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="debit" property="Validation.ShowError" value="True" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="Address" value="$I$4" type="String"/><column name="credit" property="ColumnWidth" value="11.43" type="Double"/><column name="credit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="credit" property="Validation.Type" value="2" type="Double"/><column name="credit" property="Validation.Operator" value="4" type="Double"/><column name="credit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="credit" property="Validation.AlertStyle" value="1" type="Double"/><column name="credit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="credit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="credit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="credit" property="Validation.ShowError" value="True" type="Boolean"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/></columnFormats><views><view name="All rows"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/></view><view name="Incomes"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view><view name="Expenses"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view></views></table>';
    INSERT INTO S01.FORMATS (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('S01', 'USP_CASHBOOK2', str);
    str := '<table name="s01.usp_cashbook3"><columnFormats><column name="" property="ListObjectName" value="usp_cashbook3" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium2" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="True" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="id" property="Address" value="$C$4" type="String"/><column name="id" property="ColumnWidth" value="4.29" type="Double"/><column name="id" property="NumberFormat" value="General" type="String"/><column name="id" property="Validation.Type" value="1" type="Double"/><column name="id" property="Validation.Operator" value="1" type="Double"/><column name="id" property="Validation.Formula1" value="-2147483648" type="String"/><column name="id" property="Validation.Formula2" value="2147483647" type="String"/><column name="id" property="Validation.AlertStyle" value="1" type="Double"/><column name="id" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="id" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="id" property="Validation.ShowInput" value="True" type="Boolean"/><column name="id" property="Validation.ShowError" value="True" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="Address" value="$D$4" type="String"/><column name="date" property="ColumnWidth" value="11.43" type="Double"/><column name="date" property="NumberFormat" value="m/d/yyyy" type="String"/><column name="date" property="Validation.Type" value="4" type="Double"/><column name="date" property="Validation.Operator" value="5" type="Double"/><column name="date" property="Validation.Formula1" value="12/31/1899" type="String"/><column name="date" property="Validation.AlertStyle" value="1" type="Double"/><column name="date" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="date" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="date" property="Validation.ShowInput" value="True" type="Boolean"/><column name="date" property="Validation.ShowError" value="True" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="Address" value="$E$4" type="String"/><column name="account" property="ColumnWidth" value="12.14" type="Double"/><column name="account" property="NumberFormat" value="General" type="String"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="Address" value="$F$4" type="String"/><column name="item" property="ColumnWidth" value="20.71" type="Double"/><column name="item" property="NumberFormat" value="General" type="String"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="Address" value="$G$4" type="String"/><column name="company" property="ColumnWidth" value="20.71" type="Double"/><column name="company" property="NumberFormat" value="General" type="String"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="Address" value="$H$4" type="String"/><column name="debit" property="ColumnWidth" value="11.43" type="Double"/><column name="debit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="debit" property="Validation.Type" value="2" type="Double"/><column name="debit" property="Validation.Operator" value="4" type="Double"/><column name="debit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="debit" property="Validation.AlertStyle" value="1" type="Double"/><column name="debit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="debit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="debit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="debit" property="Validation.ShowError" value="True" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="Address" value="$I$4" type="String"/><column name="credit" property="ColumnWidth" value="11.43" type="Double"/><column name="credit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="credit" property="Validation.Type" value="2" type="Double"/><column name="credit" property="Validation.Operator" value="4" type="Double"/><column name="credit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="credit" property="Validation.AlertStyle" value="1" type="Double"/><column name="credit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="credit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="credit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="credit" property="Validation.ShowError" value="True" type="Boolean"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/></columnFormats><views><view name="All rows"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/></view><view name="Incomes"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view><view name="Expenses"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view></views></table>';
    INSERT INTO S01.FORMATS (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('S01', 'USP_CASHBOOK3', str);
    str := '<table name="s01.usp_cashbook4"><columnFormats><column name="" property="ListObjectName" value="usp_cashbook4" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="" property="TableStyle.Name" value="TableStyleMedium2" type="String"/><column name="" property="ShowTableStyleColumnStripes" value="False" type="Boolean"/><column name="" property="ShowTableStyleFirstColumn" value="False" type="Boolean"/><column name="" property="ShowShowTableStyleLastColumn" value="False" type="Boolean"/><column name="" property="ShowTableStyleRowStripes" value="True" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="_RowNum" property="Address" value="$B$4" type="String"/><column name="_RowNum" property="NumberFormat" value="General" type="String"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="id" property="Address" value="$C$4" type="String"/><column name="id" property="ColumnWidth" value="4.29" type="Double"/><column name="id" property="NumberFormat" value="General" type="String"/><column name="id" property="Validation.Type" value="1" type="Double"/><column name="id" property="Validation.Operator" value="1" type="Double"/><column name="id" property="Validation.Formula1" value="-2147483648" type="String"/><column name="id" property="Validation.Formula2" value="2147483647" type="String"/><column name="id" property="Validation.AlertStyle" value="1" type="Double"/><column name="id" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="id" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="id" property="Validation.ShowInput" value="True" type="Boolean"/><column name="id" property="Validation.ShowError" value="True" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="Address" value="$D$4" type="String"/><column name="date" property="ColumnWidth" value="11.43" type="Double"/><column name="date" property="NumberFormat" value="m/d/yyyy" type="String"/><column name="date" property="Validation.Type" value="4" type="Double"/><column name="date" property="Validation.Operator" value="5" type="Double"/><column name="date" property="Validation.Formula1" value="12/31/1899" type="String"/><column name="date" property="Validation.AlertStyle" value="1" type="Double"/><column name="date" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="date" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="date" property="Validation.ShowInput" value="True" type="Boolean"/><column name="date" property="Validation.ShowError" value="True" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="Address" value="$E$4" type="String"/><column name="account" property="ColumnWidth" value="12.14" type="Double"/><column name="account" property="NumberFormat" value="General" type="String"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="Address" value="$F$4" type="String"/><column name="item" property="ColumnWidth" value="20.71" type="Double"/><column name="item" property="NumberFormat" value="General" type="String"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="Address" value="$G$4" type="String"/><column name="company" property="ColumnWidth" value="20.71" type="Double"/><column name="company" property="NumberFormat" value="General" type="String"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="Address" value="$H$4" type="String"/><column name="debit" property="ColumnWidth" value="11.43" type="Double"/><column name="debit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="debit" property="Validation.Type" value="2" type="Double"/><column name="debit" property="Validation.Operator" value="4" type="Double"/><column name="debit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="debit" property="Validation.AlertStyle" value="1" type="Double"/><column name="debit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="debit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="debit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="debit" property="Validation.ShowError" value="True" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="Address" value="$I$4" type="String"/><column name="credit" property="ColumnWidth" value="11.43" type="Double"/><column name="credit" property="NumberFormat" value="#,##0.00_ ;[Red]-#,##0.00 " type="String"/><column name="credit" property="Validation.Type" value="2" type="Double"/><column name="credit" property="Validation.Operator" value="4" type="Double"/><column name="credit" property="Validation.Formula1" value="-1.11222333444555E+29" type="String"/><column name="credit" property="Validation.AlertStyle" value="1" type="Double"/><column name="credit" property="Validation.IgnoreBlank" value="True" type="Boolean"/><column name="credit" property="Validation.InCellDropdown" value="True" type="Boolean"/><column name="credit" property="Validation.ShowInput" value="True" type="Boolean"/><column name="credit" property="Validation.ShowError" value="True" type="Boolean"/><column name="" property="ActiveWindow.DisplayGridlines" value="False" type="Boolean"/><column name="" property="ActiveWindow.FreezePanes" value="True" type="Boolean"/><column name="" property="ActiveWindow.Split" value="True" type="Boolean"/><column name="" property="ActiveWindow.SplitRow" value="0" type="Double"/><column name="" property="ActiveWindow.SplitColumn" value="-2" type="Double"/><column name="" property="PageSetup.Orientation" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesWide" value="1" type="Double"/><column name="" property="PageSetup.FitToPagesTall" value="1" type="Double"/></columnFormats><views><view name="All rows"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/></view><view name="Incomes"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view><view name="Expenses"><column name="" property="ListObjectName" value="cash_book" type="String"/><column name="" property="ShowTotals" value="False" type="Boolean"/><column name="_RowNum" property="EntireColumn.Hidden" value="True" type="Boolean"/><column name="id" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="date" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="account" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="item" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="company" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="debit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="EntireColumn.Hidden" value="False" type="Boolean"/><column name="credit" property="AutoFilter.Criteria1" value="&lt;&gt;" type="String"/></view></views></table>';
    INSERT INTO S01.FORMATS (TABLE_SCHEMA, TABLE_NAME, TABLE_EXCEL_FORMAT_XML) VALUES ('S01', 'USP_CASHBOOK4', str);
END;
/

INSERT INTO S01.WORKBOOKS (NAME, TEMPLATE, DEFINITION, TABLE_SCHEMA) VALUES ('Sample 01 - Basic Features - User1.xlsx', 'https://www.savetodb.com/downloads/v10/sample01-user1.xlsx', '
cashbook=S01.CASHBOOK,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"cashbook"}
view_cashbook=S01.VIEW_CASHBOOK,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"view_cashbook"}
usp_cashbook=S01.USP_CASHBOOK,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook"}
usp_cashbook2=S01.USP_CASHBOOK2,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook2"}
usp_cashbook3=S01.USP_CASHBOOK3,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook3"}
usp_cashbook4=S01.USP_CASHBOOK4,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook4"}
cash_by_months=S01.USP_CASH_BY_MONTHS,(Default),False,$B$3,,{"Parameters":{"year":2021},"ListObjectName":"cash_by_months"}
', 'S01');

INSERT INTO S01.WORKBOOKS (NAME, TEMPLATE, DEFINITION, TABLE_SCHEMA) VALUES ('Sample 01 - Basic Features - User2 (Restricted).xlsx', 'https://www.savetodb.com/downloads/v10/sample01-user2.xlsx', '
cashbook=S01.CASHBOOK,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"cashbook"}
view_cashbook=S01.VIEW_CASHBOOK,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"view_cashbook"}
usp_cashbook=S01.USP_CASHBOOK,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook"}
usp_cashbook2=S01.USP_CASHBOOK2,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook2"}
usp_cashbook3=S01.USP_CASHBOOK3,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook3"}
usp_cashbook4=S01.USP_CASHBOOK4,(Default),False,$B$3,,{"Parameters":{"account":null,"item":null,"company":null},"ListObjectName":"usp_cashbook4"}
cash_by_months=S01.USP_CASH_BY_MONTHS,(Default),False,$B$3,,{"Parameters":{"year":2021},"ListObjectName":"cash_by_months"}
', 'S01');

prompt Application installed
