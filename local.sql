/* create all tables */
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
/* END - create all tables */

/* trivial insert */
insert into names_gender values ('Kamil', 'male');
insert into names_gender values ('Tomasz', 'male');
insert into names_gender values ('Anna', 'female');

insert into employees values (seq_employees.nextval, 96123100001, 'Tomasz', 'Nowak', 4100, 'Warszawa...');
insert into employees values (seq_employees.nextval, 96123100002, 'Kamil', 'Bidu?', 4100, 'Warszawa...');
insert into employees values (seq_employees.nextval, 96123100003, 'Anna', 'Kowalska', 4200, 'Krak?w...');
insert into employees values (seq_employees.nextval, 96123100004, 'Tomasz', 'Kowalski', 4000, 'Krak?w...');

insert into clients values (seq_clients.nextval, 'klient 1 a');
insert into clients values (seq_clients.nextval, 'klient 2 b');
insert into clients values (seq_clients.nextval, 'klient 3 c');
/* END - trivial insert */

/* non-trivial insert */
insert into managers select to_date('11/11/2011', 'DD/MM/YYYY'), 1000, employee_id FROM employees WHERE last_name='Kowalski';
insert into managers select to_date('11/11/2011', 'DD/MM/YYYY'), 1000, employee_id FROM employees WHERE last_name='Kowalska';

insert into devices select seq_devices.nextval, 'Nokia xxx', employee_id FROM employees WHERE last_name='Kowalska';
insert into devices select seq_devices.nextval, 'ASUS R556L', employee_id FROM employees WHERE address='Warszawa...';
/* END - non-trivial insert */

/* simple views */
create view employees_gender as
select employees.*, names_gender.gender 
from employees inner join names_gender on names_gender.first_name = employees.first_name;

create view male_employees as
select employee_id, pesel, first_name, last_name, salary, address
from employees_gender
where gender='male';

create view female_employees as
select employee_id, pesel, first_name, last_name, salary, address
from employees_gender
where gender='female';

create view managers_all_data as
select employees_gender.*, managers.promotion_date, managers.bonus
from employees_gender inner join managers on employees_gender.employee_id = managers.employee_id;
/* END - simple views */

/* non-trivial insert (continuation) */
insert into teams select seq_teams.nextval, 'zesp 1', employee_id from managers_all_data where last_name='Kowalski';
insert into teams select seq_teams.nextval, 'zesp 2', employee_id from managers_all_data where last_name='Kowalska';

/*
create view tmp as
select teams.team_id, clients.client_id from teams
left outer join clients on client_name='klient 1 a';
select * from tmp;
drop view tmp;
*/

insert into projects values(seq_projects.nextval, 'projekt 1', 2, 2);
insert into projects select seq_projects.nextval, 'projekt 2', teams.team_id, clients.client_id 
from teams, clients where team_name='zesp 2' and client_name='klient 2 b';

insert into works_on select employees.employee_id, projects.project_id, 15
from employees, projects where last_name='Nowak' and project_name='projekt 1';

insert into works_on select employees.employee_id, projects.project_id, 11
from employees, projects where last_name='Bidu?' and project_name='projekt 1';

insert into works_on select employees.employee_id, projects.project_id, 11
from employees, projects where last_name='Kowalska' and project_name='projekt 2';

select * from clients;
select * from devices;
select * from employees_gender;
select * from managers_all_data;
select * from projects;
select * from teams;
select * from works_on;

/* transaction */
begin
update managers set bonus = bonus + 200;
update employees set salary = salary + 100;
commit;
end;
/

/* procedure - 0.5p */
create or replace procedure change_salary(emp_id in int, amount in int) is
new_salary employees.salary%type;
begin
  select salary into new_salary from employees where employee_id = emp_id;
  new_salary := new_salary + amount;
  if new_salary < 0 then
    raise_application_error (-20001, 'WRONG DATA');
  end if;
  update employees set salary = new_salary where employee_id = emp_id;
  exception
  when no_data_found then
    raise_application_error (-20001, 'WRONG DATA');
end change_salary;
/

execute change_salary(2,-50);

/* package declaration */
create or replace package default_functionality is

/* parsing function, when flag=1 returns first word before ' ' when flag=2 returns second */
function parse_value(pValue varchar2, flag number) return varchar2;
/* procedure that has one argument, returns value, has substantial meaning, processes data from 3 tables */
procedure promote(employee in varchar2, bonus in NUMBER, teamname in varchar2 default null);
end;
/
/* package body */
create or replace package body default_functionality is

function parse_value (pValue varchar2, flag number)
   return varchar2
is
   v_pos number;
   v_pos2 number;
begin
  if flag=1 then
    v_pos2 := INSTR (pValue, ' ', 1) - 1; /* +1? */
    v_pos := 1;
  else
    v_pos := INSTR (pValue, ' ', 1) + 1;
    v_pos2 := LENGTH(pValue) - v_pos +1;
  end if;
  return SUBSTR (pValue, v_pos, v_pos2);
end parse_value;

procedure promote(
employee in varchar2, bonus in NUMBER, teamname in varchar2 default null) is
id_employee EMPLOYEES.EMPLOYEE_ID%type;
begin
  select employee_id into id_employee from employees where FIRST_NAME = parse_value(employee, 1) and LAST_NAME = parse_value(employee, 2);
  insert into MANAGERS
  values (SYSDATE, bonus, id_employee);
  if teamname is not null then
    update teams
    set manager_id = id_employee
    where team_name = teamname;
  end if;
end promote;
end;
/
execute DEFAULT_FUNCTIONALITY.promote ('Kamil Biduœ', 200, 'zesp 1');

/* check how the parser works */
/*begin
dbms_output.put_line(DEFAULT_FUNCTIONALITY.PARSE_VALUE('Kamil Biduœ', 1));
end;*/
/*begin
dbms_output.put_line(DEFAULT_FUNCTIONALITY.PARSE_VALUE('Kamil Biduœ', 2));
end;
*/

/* procedure fulfilling b), c) and d) criteria */
create or replace procedure confirm_project(
company in varchar2, 
project_name in varchar2,
team in varchar2) is
id_team teams.team_id%type;
id_client clients.client_id%type;
begin
  declare
    any_rows_found1 number;
  begin
    select count(*) into any_rows_found1 from teams where rownum=1 and team_name = team;
  if any_rows_found1=1 then
      select team_id into id_team from teams where team_name = team;
  else
      raise_application_error (-20001, 'WRONG DATA');
  end if;
  end;
  
  declare
  any_rows_found2 number;
  begin
    select count(*) into any_rows_found2 from clients where rownum=1 and client_name = company;
  if not any_rows_found2=1 then
      insert into clients
      values (seq_clients.nextval, company);
  end if;
  end;
  
  select client_id into id_client from clients where client_name = company;
  
  insert into projects
  values( seq_projects.nextval, project_name, id_team, id_client);
  
  exception
  when no_data_found then
    raise_application_error (-20001, 'WRONG DATA');
    rollback;
    
  commit;
end confirm_project;
/
execute confirm_project('Millenium', 'Security', 'zesp 1');

/* cursor with a loop */
declare
cursor get_clietns_projects(client number) is
select * from projects where client_id=client;
wiersz projects%rowtype;
begin
for wiersz in get_clietns_projects(4) loop
dbms_output.put_line('pobrano kolejny wiersz, projekt: '|| wiersz.project_name);
end loop;
end;

