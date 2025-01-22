SELECT * FROM bakery.customer_sweepstakes;


# alter table customer_sweepstakes rename column `ï»¿sweepstake_id` to `sweepstake_id`;


select * from customer_sweepstakes;

select customer_id, count(customer_id) 
from customer_sweepstakes
group by customer_id
having count(customer_id) > 1;

select * from
(
select customer_id,
row_number() over(PARTITION BY customer_id order by customer_id) as row_num
from customer_sweepstakes) as row_table
where row_num > 1;

delete from customer_sweepstakes
where sweepstake_id IN(
select sweepstake_id from(
select sweepstake_id,
row_number() over(PARTITION BY customer_id order by customer_id) as row_num
from customer_sweepstakes
) as row_table
where row_num>1
);

select * from customer_sweepstakes;


select phone, regexp_replace(phone,'[()-/+]','')
from customer_sweepstakes;

update customer_sweepstakes
set phone = regexp_replace(phone,'[()-/+]','');


select phone, concat(substring(phone,1,3),'-', substring(phone, 4,3),'-', substring(phone, 7,4))
from customer_sweepstakes;

update customer_sweepstakes
set phone = concat(substring(phone,1,3),'-', substring(phone, 4,3),'-', substring(phone, 7,4))
where phone <>'';


select * from customer_sweepstakes;


select birth_date,
if(str_to_date(birth_date,"%m/%d/%Y") is not null,str_to_date(birth_date,"%m/%d/%Y"),str_to_date(birth_date,"%Y/%d/%m")),
str_to_date(birth_date,"%m/%d/%Y"),
str_to_date(birth_date,"%Y/%d/%m")
from customer_sweepstakes;

update customer_sweepstakes
set birth_date = if(str_to_date(birth_date,"%m/%d/%Y") is not null,str_to_date(birth_date,"%m/%d/%Y"),str_to_date(birth_date,"%Y/%d/%m"));

select * from customer_sweepstakes;

select birth_date,
concat(substring(birth_date,9,2),'/' ,substring(birth_date,6,2),'/',substring(birth_date,1,4))
from customer_sweepstakes;


update customer_sweepstakes
set birth_date = concat(substring(birth_date,9,2),'/' ,substring(birth_date,6,2),'/',substring(birth_date,1,4))
where sweepstake_id IN (9,11);


update customer_sweepstakes
set birth_date = str_to_date(birth_date,"%m/%d/%Y");


select * from customer_sweepstakes;



select `Are you over 18?`,
case  
 when `Are you over 18?` ="Yes" then "Y"
 when  `Are you over 18?`="No" then "N"
 else  `Are you over 18?`
end as age

from customer_sweepstakes;

update customer_sweepstakes
set `Are you over 18?` = case  
 when `Are you over 18?` ="Yes" then "Y"
 when  `Are you over 18?`="No" then "N"
 else  `Are you over 18?`
end;

select * from customer_sweepstakes;


select address, substring_index(address,',',1) as street, 
substring_index(substring_index(address,',',2),',',-1) as city,
substring_index(address,',',-1) as state
 from customer_sweepstakes;


select * from customer_sweepstakes;

ALTER table customer_sweepstakes
ADD column street varchar(50) After address;

ALTER TABLE customer_sweepstakes
ADD COLUMN city varchar(50) AFTER street; 

ALTER TABLE customer_sweepstakes
ADD COLUMN state varchar(50) AFTER city;


update customer_sweepstakes
set city = substring_index(substring_index(address,',',2),',',-1);

update customer_sweepstakes
set state = substring_index(address,',',-1);

update customer_sweepstakes
set state = upper(state);


update customer_sweepstakes
set city = trim(city);


select * from customer_sweepstakes;

#working with null values


select * from customers;

select count(customer_id),count(phone) from customers;

select count(sweepstake_id),count(phone) from customer_sweepstakes;

select * from customer_sweepstakes;

update customer_sweepstakes
set phone = null
where phone = '';


update customer_sweepstakes
set income = null
where income = '';

select avg(coalesce(income,0)) from customer_sweepstakes
;




select birth_date, `Are you over 18?` from customer_sweepstakes
where (year(now()) - 20 ) < year(birth_date);


update customer_sweepstakes
set `Are you over 18?` = 'N'
where  (year(now()) - 20 ) < year(birth_date);


select * from customer_sweepstakes;

update custsubstring omer_sweepstakes
set `Are you over 18?` = 'Y'
where  (year(now()) - 20 ) > year(birth_date);



select * from customer_sweepstakes;

update customer_sweepstakes
set birth_date = '2006-07-06'
where birth_date = "N";


Alter table customer_sweepstakes
drop column address;


Alter table customer_sweepstakes
drop column favorite_color;
