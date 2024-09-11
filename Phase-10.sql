create user 'john_stones'@'localhost' identified by 'johnstones2000john';
grant select on online_shop.* to 'john_stones'@'localhost';
flush privileges;