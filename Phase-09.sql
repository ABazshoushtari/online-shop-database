alter table online_shop.sp add index sp_quantity_index (quantity);
alter table customer add index phoneNumber_index (phone_number);
alter table brand add index brandName_index (name);
alter table product add index weight_index (weight);
