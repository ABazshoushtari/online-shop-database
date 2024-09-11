DELIMITER //
create trigger barcode_brand
    before insert on online_shop.product
    for each row
    begin
        declare brand_count int;

        select count(*) into brand_count
        from online_shop.product
        where barcode = NEW.barcode and brand_name != NEW.brand_name;

        if brand_count > 0 then
            signal sqlstate '45000' set message_text = 'Duplicate barcode with different brand_name';
        end if;
    end//
DELIMITER ;

# insert into product values ('200000000001', 'sferfr', 20, 'Panda');

DELIMITER //
create trigger no_product_in_multiple_orders
    before insert on basket
    for each row
    begin
        declare newProduct_barcode char(12);
        declare existing_order_id int;
#         declare product_order_count int;

        select product_barcode into newProduct_barcode
        from sp
        where NEW.sp_id = id
        limit 1;

        select basket.order_id into existing_order_id
        from basket join sp on basket.sp_id = sp.id
        where newProduct_barcode = sp.product_barcode and NEW.order_id != basket.order_id
        limit 1;

        if existing_order_id is not null then
            signal sqlstate '45000' set message_text  = 'Duplicate product found in another order.';
        end if;

#       ravesh 2:
#         select count(*) into product_order_count
#         from basket join sp on basket.sp_id = sp.id
#         where product_barcode = newProduct_barcode and NEW.order_id != basket.order_id
#
#         if product_order_count > 1 then
#             signal sqlstate '45000' set message_text ='Duplicate product found in another order.';
#         end if;

    end //
DELIMITER ;

# insert into basket values (12, 1, 2)