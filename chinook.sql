/*
Assignment Workbook - SQL
Cheng J
*/

-- 2.0 SQL Queries
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

    -- Note: not all fields for each row inserted; going for columns that do not accept null values
Insert into Employee (employeeid, lastname, firstname) values (24, 'twenty-four', 'hundred');
Insert into Employee (employeeid, lastname, firstname) values (25, 'twenty-five', 'hundred');

    -- same as previous two lines above
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
-- need to delete entries in a way so that no orphans exist
-- need to disable the foreign key links so that our command isn't 
alter table invoice add constraint FK_invoicecustomerID
    foreign key (customerID) references customer (customerID) on delete cascade;
alter table invoiceline drop constraint FK_invoicelineinvoiceid;
alter table invoiceline add constraint FK_invoicelineinvoiceid foreign key (invoiceID) 
references invoice (invoiceID) on delete cascade;
delete from customer where firstname = 'Robert' and lastname = 'Walter';

-- 3.0 SQL Functions
-- 3.1 System defined functions
CREATE OR REPLACE FUNCTION current_time
    return TIMESTAMP is getTime TIMESTAMP;
    
    Begin
        select current_timestamp 
        into getTime
        from dual;
    return (getTime);
    End; 
/
--SELECT current_time
--FROM dual;

create or replace function getMedialength(input in varchar2) 
return integer as final_ans varchar(50);
begin 
    final_ans := length(input);
    return final_ans;
end;
/
--select getMedialength('MPEG audio file') 
--from mediatype;

-- 3.2 System defined aggregate function
create or replace function average_invoice
return number as average_ans number; 
begin 
        select SUM(x.total)/COUNT(x.total)
        into average_ans
        from invoice x;   
    return average_ans;
end;
/
select average_invoice
from invoice
group by average_invoice;

create or replace function most_expensive_track
return track.name%type as some_name track.name%type;
begin
    select track.name
    into some_name
    from track
    where unitprice = (select max(unitprice)
                        from track)
    and rownum = 1;
    return some_name;
end;
/
--select most_expensive_track
--from track
--group by most_expensive_track;

-- 3.3 User Defined Functions
create or replace function avg_invoice_price
return number as average number;
    counter number := 0; total number := 0;
begin
    for iterThrough in (select * from invoiceline)
    loop
        counter := counter + 1;
        total := total + iterThrough.unitprice;
    end loop;
    average := total/counter;
    return average;
end;
/
--select avg_invoice_price
--from invoiceline
--group by avg_invoice_price;

-- 3.4 User Defined Table Valued Functions
create or replace function born_after_1968
return sys_refcursor as some_cursor sys_refcursor;

begin 
    open some_cursor for select distinct firstname, lastname
                          from employee
                          where birthdate > '31-DEC-1968';
    return some_cursor;
end;    

select born_after_1968
from employee;

-- 4.0 Stored Procedures
-- 4.1 Basic Stored Procedure


-- 5.0 Transactions


-- 6.0 Triggers...After/For
create or replace trigger triggerEmployee
after insert on employee
begin
    DBMS_OUTPUT.PUT_LINE('New employee record inserted');
end;
/

create or replace trigger triggerAlbum
after update on album 
begin
    DBMS_output.put_line('The Album table was updated');
end;
/

create or replace trigger triggerCustomer
after delete on customer 
begin
    DBMS_output.put_line('A row in Customer was deleted');
end;
/

-- 7.0 Joins
-- 7.1 inner join
select cust.firstname, inv.invoiceid 
from customer cust 
inner join invoice inv 
on cust.customerid = inv.customerid;

-- 7.2 outer join
select cust.firstname, cust.lastname, inv.invoiceid, inv.total 
from customer cust 
left outer join invoice inv 
on cust.customerid = inv.customerid;

-- 7.3 right join
select arr.name, alb.title 
from artist arr 
right join album alb 
on arr.artistid = alb.artistid;

-- 7.4 cross join
select arr.name 
from artist arr
cross join album alb 
where arr.artistid = alb.artistid 
order by arr.name ASC;

-- 7.5 self join
select * 
from employee emp_one 
join employee emp_two 
on emp_two.reportsto = emp_one.employeeid;

-- 7.6 complicated join assignment 
select * from ((employee emp inner join customer cust 
                on emp.employeeid = cust.supportrepid) 
                inner join (invoice inv inner join invoiceline iline 
                            on inv.invoiceid = iline.invoiceid) 
                            on cust.customerid = inv.customerid)
                inner join ((((genre g inner join track t 
                                on g.genreid = t.genreid)
                                inner join (album alb inner join artist art 
                                     on alb.artistid = art.artistid)
                                on t.albumid = alb.albumid) 
                                inner join (playlist p_list inner join playlisttrack p_track 
                                    on p_track.playlistid = p_list.playlistid) 
                                on p_track.trackid = t.trackid) 
                                inner join mediatype med on med.mediatypeid = t.mediatypeid) 
                on iline.trackid = t.trackid;
