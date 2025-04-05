/*
Views:-
is a database object that has no values.
Its contents are based on the base table.
It is a virtual table created by a query

simplify complex query
increase the reusability
help in data security
enable backward compatibility
*/

create view `children` as
select customerkey, firstname,lastname,totalchildren
from customers;

select * from children;

/*
Altering the view already created
*/
desc customers;

alter view children as 
select customerkey, firstname,lastname,totalchildren
from customers
where totalchildren>3;

select * from children;

drop view if exists children;