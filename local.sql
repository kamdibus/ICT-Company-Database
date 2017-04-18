create table employees(
emp_id integer primary key,
pesel number(11,0) not null,
name varchar2(8),
last_name varchar2(8),
salary number(6,0) check (salary > 1000),
address varchar2(20)
);

create table name_gender(
name varchar2(8) not null primary key,
gender char(7)
);

create table devices(
device_id int not null primary key,
type varchar(20),
owner int,
foreign key (owner) references employee(employee_id) on delete set null
);

alter table employees
add (constraint name_gender_const foreign key (name) references name_gender(name));

insert into name_gender values (
'Kamil', 'male');
insert into name_gender values (
'Tomasz', 'male');
insert into name_gender values (
'Dominik', 'male');
insert into name_gender values (
'Ewa', 'female');