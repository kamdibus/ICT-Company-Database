create table names_gender(
first_name varchar2(8) not null primary key,
gender char(7)
);

create table employees(
employee_id integer primary key,
pesel number(11,0) not null,
first_name varchar2(8),
foreign key (first_name) references names_gender(first_name),
last_name varchar2(8),
salary number(6,0) check (salary > 1000),
address varchar2(20)
);

create table managers(
promotion_date date,
bonus number(6,0)
);

alter table managers /* relation Manager ISA Employee */
add (employee_id int not null references employees(employee_id))
add (constraint manager_isa_pk primary key (employee_id));

create table devices(
device_id int not null primary key,
device_name varchar(20),
owner int, /* relation Employee OWNS Device */
foreign key (owner) references employees(employee_id) on delete set null
);

create table teams(
team_id integer not null primary key,
team_name varchar2(20),
manager_id int not null, /* relation Manager MANAGES Team */
foreign key(manager_id) references managers(employee_id)
);

create table clients(
client_id int not null primary key,
client_name varchar2(20)
);

create table projects(
project_id int not null primary key,
project_name varchar2(20),
team_id int not null, /* relation Team CONTROLS Project */
foreign key(team_id) references teams(team_id),
client_id int not null, /* relation Client ORDERED Project */
foreign key(client_id) references clients(client_id)
);

create table works_on( /* relation N:M WORKS_ON */
employee_id int not null,
foreign key (employee_id) references employees(employee_id) on delete cascade,
project_id int not null,
foreign key (project_id) references projects(project_id) on delete cascade,
hours int
);

insert into names_gender values (
'Kamil', 'male');
insert into names_gender values (
'Tomasz', 'male');
insert into names_gender values (
'Dominik', 'male');
insert into names_gender values (
'Ewa', 'female');