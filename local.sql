select * from name_gender;

insert into employee values(
'strasse', 2200, 1, 'Kamil', 2100); %eror

alter table employee
drop column pesel;

alter table employee
drop column gender;

create table device(
device_id int not null primary key,
type varchar(20),
owner int,
foreign key (owner) references employee(employee_id) on delete set null)

alter table name_gender
add (constraint name_gender_pk_const primary key (name));

alter table employee
add (name varchar(20) )
add (constraint name_gender_const foreign key (name) references name_gender(name));

insert into name_gender values (
'Kamil', 'male');
insert into name_gender values (
'Tomasz', 'male');
insert into name_gender values (
'Dominik', 'male');
insert into name_gender values (
'Ewa', 'female');