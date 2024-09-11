alter table online_shop.product add is_sold boolean default false;

insert into product values ('210000000000', 'Khaviar', 10, 'Kale', false);
insert into sp
select (select count(*) from sp) + 1, 'Amirfazel', '210000000000', 20, 9999;


update product
set product.is_sold = true
where product.barcode in (select product_barcode
                          from basket join sp on basket.sp_id = sp.id);

start transaction;

insert into orders
select (select count(*) from orders) + 1, '0000000001', '2023-01-01 21:00:00';

INSERT INTO basket
SELECT (SELECT COUNT(*) FROM orders), sp.id, 1
FROM sp JOIN product p ON sp.product_barcode = p.barcode
WHERE p.is_sold = false
LIMIT 1;

update sp
set quantity = quantity - 1
where sp.id = (select basket.sp_id
               from basket
               order by basket.order_id desc
               limit 1);
update product
set product.is_sold = true
where product.barcode = (select sp.product_barcode
                         from sp
                         where sp.id = (select basket.sp_id
                                        from basket
                                        order by basket.order_id desc
                                        limit 1));
commit;