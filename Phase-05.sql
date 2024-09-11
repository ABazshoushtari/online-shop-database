-- query1
with supplier_products as
         (select sp.supplier_username,
                 p.name,
                 p.barcode,
                 SUM(b.quantity) as total_sold,
                 ROW_NUMBER() over (partition by sp.supplier_username order by SUM(b.quantity) desc) as row_num
          from (online_shop.basket as b join online_shop.sp on sp.id = b.sp_id)
                   join online_shop.product as p on sp.product_barcode = p.barcode
          group by sp.supplier_username, p.name, p.barcode)
select supplier_username, name, barcode, total_sold
from supplier_products
where row_num <= 10;

-- query2
with city_products as
        (select city, p.name as product_name, p.barcode, sum(b.quantity) as total_sales,
                ROW_NUMBER() over (partition by city order by sum(b.quantity) desc) as row_num
         from (((customer as c join orders o on c.national_id = o.customer_id)
                join basket as b on b.order_id = o.id)
                join sp on sp.id = b.sp_id)
                join product as p on sp.product_barcode = p.barcode
         group by city, p.name, p.barcode)
select city, product_name, barcode, total_sales
from city_products
where row_num <= 10;

-- query 3
select supplier_username, sum(sp.quantity) as total_sales
from (online_shop.basket join online_shop.sp on basket.sp_id = sp.id)
         join online_shop.orders on orders.id = basket.order_id
where YEAR(orders.date) = YEAR(curdate())
group by supplier_username
order by total_sales desc
limit 5;

-- query 4
select count(*)
from (select supplier_username, p.name, sum(b.quantity) as total_sales
      from (online_shop.basket as b join online_shop.sp on b.sp_id = sp.id)
               join online_shop.product as p on p.barcode = sp.product_barcode
      where p.name = 'Gol-Mohammadi'
      group by supplier_username, p.name) as snt,
     (select supplier_username, p.name, sum(b.quantity) as total_sales
      from (online_shop.basket as b join online_shop.sp on b.sp_id = sp.id)
               join online_shop.product as p on p.barcode = sp.product_barcode
      where p.name = 'Croissant'
      group by supplier_username, p.name) as snt2
where snt.supplier_username = snt2.supplier_username
  and snt.total_sales > snt2.total_sales;

-- query 5
select pt.category_name
from (basket as b join sp on sp.id = b.sp_id)
        join product_types as pt on pt.product_barcode = sp.product_barcode
where b.order_id in (select b2.order_id
                     from (basket as b2 join sp as sp2 on b2.sp_id = sp2.id)
                            join product_types as pt2 on pt2.product_barcode = sp2.product_barcode
                     where pt2.category_name = 'Milk') and pt.category_name != 'Milk'
group by pt.category_name
order by sum(b.quantity) desc
limit 3;
