create table employee(
pesel int primary key not null check ( pesel > 11111111111 and pesel < 99999999999), /*both pesel and gender dropped beneath*/
gender varchar(6),
address varchar(30),
salary int check (salary > 2000),
bonus int check ( bonus > 100 and bonus < 20000))

alter table employee
drop column gender;

alter table employee
drop column pesel;

create table name_gender(
name varchar(20) not null primary key,
gender varchar(6) not null)

alter table name_gender
add (constraint name_gender_pk primary key (name));

alter table employee
add (name varchar(20) not null)
add (constraint name_gender_const foreign key (name) references name_gender(name));

insert into name_gender values (
'Kamil', 'male');
insert into name_gender values (
'Tomasz', 'male');
insert into name_gender values (
'Dominik', 'male');
insert into name_gender values (
'Ewa', 'female');

create table device(
device_id int not null primary key,
type varchar(20),
owner int,
foreign key (owner) references employee(employee_id) on delete set null)

select * from name_gender;

alter table works_on
drop constraint SYS_C007028;

alter table works_on
drop constraint SYS_C007027;

create table works_on(
employee int not null,
project int not null,
hours int check (hours > 20))

alter table works_on
add (constraint project_workson_fk foreign key (project) references project(project_id) on delete cascade);

alter table works_on
add (constraint employee_workson_fk foreign key (employee) references employee(employee_id) on delete cascade);

insert into employee values(
'strasse', 2200, 200, 3, 'Dominik');
insert into employee values(
'strasse', 2500, 300, 2, 'Ewa');
insert into employee values(
'strasse', 2200, 2100, 1, 'Kamil');

insert into device values(
3, 'M-B GLA', 1);
insert into device values(
2, 'laptop', 1);
insert into device values(
1, 'smartphone', 1);

insert all 
into project (project_id, project_name) values (1, 'ICT-DB')
into project (project_id, project_name) values (2, 'SOI')
into project (project_id, project_name) values (3, 'PROZ')
select * from dual;

insert all 
into team (team_id, team_name) values (1, 'team1')
into team (team_id, team_name) values (2, 'team2')
into team (team_id, team_name) values (3, 'teamt_hree')
select * from dual;

insert all 
into works_on (employee, project, hours) values (1, 1, 40)
into works_on (employee, project, hours) values (2, 2, 40)
into works_on (employee, project, hours) values (1, 2, 40)
select * from dual;

/*Requires ISA relatoinship*/
create table manager(
promotion_date date)

alter table manager
add (employee_id int not null references employee(employee_id))
add (constraint manager_isa_pk primary key (employee_id));

/*Manager manages one Team. Every Team has a Manager. Not every Manager manages a Team.*/
alter table manager 
add (team_id int unique);

alter table manager
add (constraint manager_team_fk foreign key (team_id) references team(team_id));

/*Here TEAM_ID also needs to be inserted*/
insert into manager values (
TO_DATE('11/11/2011', 'DD/MM/YYYY'), 1);

insert into manager values (
TO_DATE('11/11/2011', 'DD/MM/YYYY'), 2);

/*Selecting employees which are managers*/
create view show_managers as
select employee.*, manager.PROMOTION_DATE, manager.TEAM_ID
from employee, manager
where employee.employee_id=manager.employee_id;
/*from employee
join manager
as employee.employee_id=manager.employee_id;*/


/*Descending id employees select. Polish names of columns.*/
select ADDRESS as adres, SALARY as pensja, BONUS as premia, EMPLOYEE_ID as id, NAME as imie  from employee
order by EMPLOYEE_ID DESC;

create sequence employee_id
start with 1
increment by 1
cache 5000;

create sequence team_id
start with 1
increment by 1
cache 5000;

create view show_managers_w_gender as
select employee.*, manager.PROMOTION_DATE, manager.TEAM_ID, name_gender.GENDER
from employee, manager, name_gender
where employee.employee_id=manager.employee_id and employee.NAME=name_gender.NAME;

create view projects as
select employee.NAME, employee.employee_id, works_on.hours, project.project_name
from employee, works_on, project
where employee.employee_id=works_on.employee;
