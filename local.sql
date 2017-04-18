Prior to the undermentioned  tables employee, device, name_gender, team and project were created. Unfortunately, no record of that remained..

insert into name_gender values (
'Kamil', 'male');
insert into name_gender values (
'Tomasz', 'male');
insert into name_gender values (
'Dominik', 'male');
insert into name_gender values (
'Ewa', 'female');

alter table employee
add (name varchar(20) )
add (constraint name_gender_const foreign key (name) references name_gender(name));

alter table name_gender
add (constraint name_gender_pk_const primary key (name));

create table device(
device_id int not null primary key,
type varchar(20),
owner int,
foreign key (owner) references employee(employee_id) on delete set null)

alter table employee
drop column gender;

alter table employee
drop column pesel;

select * from name_gender;

alter table works_on
drop constraint SYS_C007028;

alter table works_on
drop constraint SYS_C007027;

alter table works_on
add (constraint project_fk foreign key (project) references project(project_id) on delete cascade);

alter table works_on
add (constraint employee_fk foreign key (employee) references employee(employee_id) on delete cascade);

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

insert into manager values (
TO_DATE('11/11/2011', 'DD/MM/YYYY'), 1);

insert into manager values (
TO_DATE('11/11/2011', 'DD/MM/YYYY'), 2);

/*Manager manages one Team. Every Team has a Manager. Not every Manager manages a Team.*/
alter table manager 
add (team_id int unique);

alter table manager
add (constraint manager_team_fk foreign key (team_id) references team(team_id));