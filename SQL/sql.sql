create table Associate(
associateId number,
firstName varchar2(50)not null,
lastName varchar2(50)not null,
yearlyInvestmentUnder80C number,
department varchar2(50)not null,
designation varchar2(50)not null,
pancard varchar2(50)not null,
emailId varchar2(50)not null
);
--------------------------------------------------------------------------------
desc Associate;
--------------------------------------------------------------------------------
drop table Associate;
--------------------------------------------------------------------------------
alter table Associate
  add constraint PK_AssociateID
    primary key(associateId);
--------------------------------------------------------------------------------
alter table Associate
  add constraint UK_EmailId
    unique(emailId);
--------------------------------------------------------------------------------
CREATE TABLE SALARY(
BASICSALARY NUMBER,
HRA NUMBER,
CONVEYENCEALLOWANCE NUMBER,
OTHERALLOWANCE NUMBER,
PERSONALALLOWANCE NUMBER,
MONTHLYTAX NUMBER,
EPF NUMBER,
COMPANYPF NUMBER,
GROSSSALARY NUMBER,
NETSALARY NUMBER
);
--------------------------------------------------------------------------------
alter table Salary
  add associateId number;
--------------------------------------------------------------------------------
alter table Salary
  add constraint FK_AssociateID
    foreign key (associateId)REFERENCES Associate(associateId);
--------------------------------------------------------------------------------
drop table Salary;
--------------------------------------------------------------------------------
CREATE TABLE BANKDETAILS(
ACCOUNTNUMBER NUMBER,
BANKNAME VARCHAR2(50),
IFSCCODE VARCHAR2(50)
);
--------------------------------------------------------------------------------
alter table BANKDETAILS
  add associateId number;
--------------------------------------------------------------------------------
alter table BANKDETAILS
  add constraint AssociateID_FK
    foreign key (associateId)REFERENCES Associate(associateId);
--------------------------------------------------------------------------------
select * from Associate;
--------------------------------------------------------------------------------
select sysdate
  from dual;
--------------------------------------------------------------------------------
select ADD_MONTHS(sysdate,10)
  from dual;
--------------------------------------------------------------------------------
select MONTHS_BETWEEN(sysdate,'11-aug-97')
  from dual;
--------------------------------------------------------------------------------
select extract(year from sysdate)
  from dual;
--------------------------------------------------------------------------------
select extract(month from date '2011-04-01')
  from dual;
--------------------------------------------------------------------------------
select extract (month from book_issue_date)
  from book_transaction;
--------------------------------------------------------------------------------
select to_char(sysdate,'dd month, yyyy') 
  from dual;
--------------------------------------------------------------------------------
select to_char(sysdate,'ddth month,yyyy')
  from dual;
--------------------------------------------------------------------------------
select to_char(17000,'$99,999.00')
  from dual;
--------------------------------------------------------------------------------
select a.associateId,a.firstName,a.lastName,s.basicSalary,s.netSalary,b.bankName
  from Associate a,Salary s, BankDetails b
    where a.associateId=s.associateId and a.associateId=b.associateId;
--------------------------------------------------------------------------------
select a.associateId,a.firstName,a.lastName,s.basicSalary,s.netSalary,b.bankName
  from Associate a,Salary s, BankDetails b
    where a.associateId(+)=s.associateId;
--------------------------------------------------------------------------------
select * 
  from Associate,Salary,BankDetails
    where Associate.yearlyInvestmentUnder80C>50000
--------------------------------------------------------------------------------
select a.firstName,a.lastName,s.basicSalary
  from Associate a, Salary s
    where s.basicSalary >(select min(s.BASICSALARY) from Salary s);
--------------------------------------------------------------------------------
create view AssociateBankDetails
  As 
    select a.associateId,a.firstName,a.lastName,b.bankName,b.ifscCode
      from Associate a,BankDetails b
        where a.associateId=b.associateId;
        
select * from AssociateBankDetails
--------------------------------------------------------------------------------
declare 
  vename varchar2(20) not null:= 'Kuldeep';
  id number;
Begin
 veName:='Kuldeep';
  DBMS_OUTPUT.PUT_LINE(veName||''||id);
END;
--------------------------------------------------------------------------------
DECLARE
  aId number;
  fName varchar(50);
  lName varchar(50);
begin
  select associateId,firstName,lastName INTO aId,fName,lName
    from Associate
      where associateId=&aId;
  DBMS_OUTPUT.PUT_LINE(aId||''||fName||''||lName);
end;
--------------------------------------------------------------------------------
DECLARE
  aId ASSOCIATE.ASSOCIATEID%TYPE;
  fName ASSOCIATE.FIRSTNAME%TYPE;
  lName ASSOCIATE.LASTNAME%TYPE;
begin
  select associateId,firstName,lastName INTO aId,fName,lName
    from Associate
      where associateId=&aId;
  DBMS_OUTPUT.PUT_LINE(aId||''||fName||''||lName);
end;
--------------------------------------------------------------------------------
DECLARE
  associateRow ASSOCIATE%ROWTYPE;
begin
  select * INTO associateRow
    from Associate
      where associateId=&aId;
  DBMS_OUTPUT.PUT_LINE(associateRow.ASSOCIATEID||' '||associateRow.FIRSTNAME);
end;
--------------------------------------------------------------------------------
DECLARE
  CURSOR associateCursor is select * from Associate;
  associateRow ASSOCIATE%ROWTYPE;
begin
  OPEN associateCursor;
  LOOP 
  FETCH associateCursor INTO associateRow;
    DBMS_OUTPUT.PUT_LINE(associateRow.ASSOCIATEID||' '||associateRow.FIRSTNAME||' '||associateRow.LASTNAME);
    EXIT WHEN associateCursor%NOTFOUND;
    
   END LOOP;
 CLOSE associateCursor;
end;
--------------------------------------------------------------------------------
DECLARE
  aId ASSOCIATE.ASSOCIATEID%TYPE;
  fName ASSOCIATE.FIRSTNAME%TYPE;
  lName ASSOCIATE.LASTNAME%TYPE;
begin
  select associateId,firstName,lastName INTO aId,fName,lName
    from Associate
      where associateId=&aId;
  DBMS_OUTPUT.PUT_LINE(aId||''||fName||''||lName);
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No employee exists');
   WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many records found');
end;
--------------------------------------------------------------------------------
DECLARE
  CURSOR associateCursor is select * from Associate
              where YEARLYINVESTMENTUNDER80C>=&YEARLYINVESTMENTUNDER80C;
  associateRow ASSOCIATE%ROWTYPE;
  NO_Records_Found EXCEPTION;
begin
  OPEN associateCursor;
  FETCH associateCursor INTO associateRow;
  IF associateRow%ROWCOUNT>0
   THEN
    LOOP 
     FETCH associateCursor INTO associateRow;
      DBMS_OUTPUT.PUT_LINE(associateRow.ASSOCIATEID||''||associateRow.FIRSTNAME||''||associateRow.LASTNAME);
     EXIT WHEN associateCursor%NOTFOUND;
    END LOOP;
   ELSE
    RAISE NO_Records_Found;
  END IF;
 CLOSE asociateCursor;

 EXCEPTION
   WHEN NO_Records_Found THEN
    DBMS_OUTPUT.PUT_LINE('No Details Found');
end;
--------------------------------------------------------------------------------
create or replace PROCEDURE sp_FindAssociateDetails
AS CURSOR associateCursor is select * from Associate
              where YEARLYINVESTMENTUNDER80C>=&YEARLYINVESTMENTUNDER80C;
  associateRow ASSOCIATE%ROWTYPE;
  NO_Records_Found EXCEPTION;
begin
  OPEN associateCursor;
  FETCH associateCursor INTO associateRow;
  IF associateRow%ROWCOUNT>0
   THEN
    LOOP 
     FETCH associateCursor INTO associateRow;
      DBMS_OUTPUT.PUT_LINE(associateRow.ASSOCIATEID||''||associateRow.FIRSTNAME||''||associateRow.LASTNAME);
     EXIT WHEN associateCursor%NOTFOUND;
    END LOOP;
   ELSE
    RAISE NO_Records_Found;
  END IF;
 CLOSE asociateCursor;

 EXCEPTION
   WHEN NO_Records_Found THEN
    DBMS_OUTPUT.PUT_LINE('No Details Found');
end sp_FindAssociateDetails;