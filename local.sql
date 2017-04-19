create table names_gender(
first_name varchar2(8) not null primary key,
gender char(7)
);

create table employees(
employee_id integer primary key,
pesel number(11,0) not null unique,
first_name varchar2(8),
foreign key (first_name) references names_gender(first_name),
last_name varchar2(8),
salary number(6,0) check (salary > 1000),
address varchar2(20)
);
/* alter table employees add constraint unique_pesel unique(pesel); - not needed */

/* auto-generated employee_id */
create sequence seq_employees
minvalue 1
start with 1
increment by 1
cache 8;

create table managers(
promotion_date date,
bonus number(6,0)
);

alter table managers /* relation Manager ISA Employee */
add (employee_id int not null references employees(employee_id))
add (constraint manager_isa_pk primary key (employee_id));

create table devices(
device_id int not null primary key,
device_name varchar2(20),
owner int, /* relation Employee OWNS Device */
foreign key (owner) references employees(employee_id) on delete set null
);

/* auto-generated device_id */
create sequence seq_devices
minvalue 1
start with 1
increment by 1
cache 8;

create table teams(
team_id int not null primary key,
team_name varchar2(20),
manager_id int not null, /* relation Manager MANAGES Team */
foreign key(manager_id) references managers(employee_id)
);

/* auto-generated team_id */
create sequence seq_teams
minvalue 1
start with 1
increment by 1
cache 8;

create table clients(
client_id int not null primary key,
client_name varchar2(20)
);

/* auto-generated client_id */
create sequence seq_clients
minvalue 1
start with 1
increment by 1
cache 8;

create table projects(
project_id int not null primary key,
project_name varchar2(20),
team_id int not null, /* relation Team CONTROLS Project */
foreign key(team_id) references teams(team_id),
client_id int not null, /* relation Client ORDERED Project */
foreign key(client_id) references clients(client_id)
);

/* auto-generated project_id */
create sequence seq_projects
minvalue 1
start with 1
increment by 1
cache 8;

create table works_on( /* relation N:M WORKS_ON */
employee_id int not null,
foreign key (employee_id) references employees(employee_id) on delete cascade,
project_id int not null,
foreign key (project_id) references projects(project_id) on delete cascade,
hours int
);

insert into names_gender values ('Kamil', 'male');
insert into names_gender values ('Tomasz', 'male');
insert into names_gender values ('Anna', 'female');

insert into employees values (seq_employees.nextval, 96123100001, 'Tomasz', 'Nowak', 4100, 'Warszawa...');
insert into employees values (seq_employees.nextval, 96123100002, 'Kamil', 'Biduś', 4100, 'Warszawa...');
insert into employees values (seq_employees.nextval, 96123100003, 'Anna', 'Kowalska', 4200, 'Kraków...');
insert into employees values (seq_employees.nextval, 96123100004, 'Tomasz', 'Kowalski', 4000, 'Kraków...');

/* 'non-trivial' insert */
insert into devices SELECT seq_devices.nextval, 'Nokia xxx', employee_id FROM employees WHERE last_name='Kowalska';
insert into devices SELECT seq_devices.nextval, 'ASUS R556L', employee_id FROM employees WHERE address='Warszawa...';