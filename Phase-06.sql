create view distributor_distributes as
select s.*, p.*
from (online_shop.sp join online_shop.supplier s on s.username = sp.supplier_username)
         join online_shop.product as p on sp.product_barcode = p.barcode;

create view customer_orders as
select c.*, o.id, o.date, sp.product_barcode, b.quantity
from ((customer as c join orders as o on c.national_id = o.customer_id) join basket as b on o.id = b.order_id)
         join sp on sp.id;

create view product_type_brand_company as
select product.*,
       pt.category_name as category,
       b.creation_date  as brand_launch_date,
       c.license        as company_license,
       c.name           as company_name,
       c.creation_date  as company_est_date,
       c.province,
       c.city,
       c.street
from ((product
    join product_types pt on product.barcode = pt.product_barcode)
    join brand b on b.name = product.brand_name)
         join company c on c.license = b.company_id