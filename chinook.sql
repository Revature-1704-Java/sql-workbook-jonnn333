/*
Assignment Workbook - SQL
*/


-- 2.1 SELECT
Select * from Employee;
Select * from Employee where lastname = 'King';
Select * from Employee where firstname = 'Andrew' and reportsto is null; 

-- 2.2 ORDER BY
Select * from Album order by title DESC; 
Select firstname from Customer order by city ASC;

-- 2.3 INSERT INTO
Insert into Genre (genreid, name) values (61, 'someGuy');
Insert into Genre values (62, 'someOtherGuy');

Insert into Employee (employeeid, lastname, firstname) values (24, 'twenty-four', 'hundred');
Insert into Employee (employeeid, lastname, firstname) values (25, 'twenty-five', 'hundred');

Insert into Customer (customerid, firstname, lastname, email) values (401, 'k retirement', 'options', 'robin@chirpmail.com' );
Insert into Customer (customerid, firstname, lastname, email) values (529, '4 the kids', 'college_funds', 'danceMarathonPro@geemail.com');

-- 2.4 Update
Update Customer Set firstname = 'Robert', lastname = 'Walter' 
where firstname = 'Aaron' and lastname = 'Mitchell';

Update Artist Set name = 'CCR' where name = 'Creedence Clearwater Revival';

-- 2.5 Like
Select * from Invoice where billingaddress like 'T%';

-- 2.6 Between
Select * from Invoice where total between 15 and 30;
Select * from Employee where hiredate between TO_DATE('01-JUN-2003') and TO_DATE('01-MAR-2004');

-- 2.7 Delete
-- NEED TO DELETE THE ENTRIES THAT FOREIGN KEYS POINT TO IN OTHER TABLES
Delete from Customer where firstname = 'Robert' and lastname = 'Walter';
-- FIX THIS with delete trigger?

-- 3.1 System defined functions
CREATE OR REPLACE FUNCTION current_time
    return TIMESTAMP WITH LOCAL TIME ZONE is l_sysdate TIMESTAMP WITH LOCAL TIME ZONE;
    
    Begin
        --select CURRENT_TIME 
        --into l_sysdate
        --from dual;
    return (CURRENT_TIMESTAMP);
    End; 
/

SELECT current_time
FROM dual;

-- 
--CREATE OR REPLACE FUNCTION length_of_mediatype
--    return number IS the_result_set number;
--        cursor c1 is
--        Select name
--        From MEDIATYPE;
--    Begin
--        open c1;
--        fetch c1 into the_result_set;
--        return LENGTH(the_result_set);
--    End;
--/

-- problems with this 12/15/17
CREATE OR REPLACE FUNCTION length_of_mediatype
    return number is the_result_set number := 0;
 --   CURSOR c1 is
 --       Select SUM(LENGTH(name))
 --       From MEDIATYPE;
    Begin
--        for answer in c1 LOOP
        the_result_set := (Select SUM(LENGTH(name)) from MEDIATYPE)     
--        END LOOP;
        RETURN the_result_set;
    End;
/

Select length_of_mediatype
From MEDIATYPE;
