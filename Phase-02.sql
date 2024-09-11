create table customer (
    national_id char(10),
    first_name varchar(20),
    last_name varchar(20),
    phone_number char(11),
    province varchar(20),
    city varchar(20),
    street varchar(20),
    primary key (national_id)
);
create table company (
    license char(18),
    name varchar(20),
    creation_date date,
    province varchar(20),
    city varchar(20),
    street varchar(20),
    primary key (license)
);
create table brand (
    name varchar(20),
    company_id char(18),
    creation_date date,
    primary key (name),
    foreign key (company_id) references company(license)
);
create table category (
    name varchar(20),
    brand_name varchar(20),
    primary key (name, brand_name),
    foreign key (brand_name) references brand(name)
);
create table product (
    barcode char(12),
    name varchar(20),
    weight numeric(6,2),
    brand_name varchar(20),
    primary key (barcode),
    foreign key (brand_name) references brand(name)
);
create table product_types (
    product_barcode char(12),
    category_name varchar(20),
    primary key (product_barcode, category_name),
    foreign key (product_barcode) references product(barcode),
    foreign key (category_name) references category(name)
);
create table supplier (
    username varchar(20),
    mail varchar(30),
    working_hours varchar(2),
    province varchar(20),
    city varchar(20),
    street varchar(20),
    primary key (username)
);
create table sp (
    id int,
    supplier_username varchar(20),
    product_barcode char(12),
    quantity int,
    price numeric(6,2),
    primary key (id),
    foreign key (supplier_username) references supplier(username),
    foreign key (product_barcode) references product(barcode),
    constraint unique_supplier_product unique (supplier_username, product_barcode)
);
create table orders (
    id int,
    customer_id char(10),
    date datetime,
    primary key (id),
    foreign key (customer_id) references customer(national_id)
);
create table basket (
    order_id int,
    sp_id int,
    quantity int,
    primary key (order_id, sp_id),
    foreign key (order_id) references orders(id),
    foreign key (sp_id) references sp(id)
);