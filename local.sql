create table employee(
pesel int primary key not null check ( pesel > 11111111111 and pesel < 99999999999),
gender varchar(6),
address varchar(30),
salary int check (salary > 2000),
bonus int check ( bonus > 100 and bonus < 20000)
) 
