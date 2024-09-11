insert into online_shop.customer values ('1234567810', 'Harry', 'Kane', '44796268462', 'London', 'London', '212 Baker');

insert into online_shop.orders values (86, '1234567810', '2023-06-26 11:30:00');
insert into online_shop.basket values (86, 10, 3), (86, 78, 5);

update customer
set phone_number = '44734278008'
where national_id = '1234567810';

delete from customer as C
where not exists(select O.customer_id
                 from orders as O
                 where C.national_id = O.customer_id)