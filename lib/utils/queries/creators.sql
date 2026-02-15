


CREATE TABLE warehouse_users(
    id int PRIMARY KEY auto_increment,
    user_id int,
    name varchar(100),
    password varchar(100),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouse_products(
    id int PRIMARY KEY auto_increment,
    user_id int,
    name varchar(100),
    FOREIGN KEY (user_id) references warehouse_users(id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouse_products_images(
    id int PRIMARY KEY auto_increment,
    product_id int,
    image_url varchar(100),
    thumbnail_url varchar(100),
    FOREIGN KEY (product_id) references warehouse_products(id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouse_products_orders(
    id int PRIMARY KEY auto_increment,
    product_id int,
    tracking_id varchar(100) not null unique,
    order_id varchar(100) not null unique,
    FOREIGN KEY (product_id) references warehouse_products(id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE warehouse_stages (
    id INT PRIMARY KEY AUTO_INCREMENT,  
    name varchar(100) not null unique,
    value int not null unique,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);  


CREATE TABLE warehouse_stages_of_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id int,
    stage_id int,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES warehouse_products_orders(id),
    FOREIGN KEY (stage_id) REFERENCES warehouse_stages(id)
);

CREATE TABLE warehouse_sku_of_product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id int,
    name varchar(100),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES warehouse_products(id)
);

CREATE TABLE warehouse_platforms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(50),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE warehouse_packing_materials (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(50),
    cost decimal(10, 2),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouse_packing_types(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(50),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE warehouse_packets(
    id INT PRIMARY KEY AUTO_INCREMENT,
    packing_type_id int,
    material_id int,
    FOREIGN KEY (packing_type_id) REFERENCES warehouse_packing_types(id),
    FOREIGN KEY (material_id) REFERENCES warehouse_packing_materials(id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE warehouse_invoices(
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id int,
    uploaded_by int,
    page_number int,
    url varchar(200),
    FOREIGN KEY (uploaded_by) REFERENCES warehouse_users(id),
    FOREIGN KEY (order_id) REFERENCES warehouse_products_orders(id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouse_item_inventory(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(200),
    available_count int,
    url varchar(200),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



CREATE TABLE warehouse_items_in_product(
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id int,
    item_id int,
    quantity_used int,
    FOREIGN KEY (product_id) REFERENCES warehouse_products(id),
    FOREIGN KEY (item_id) REFERENCES warehouse_item_inventory(id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);




CREATE TABLE warehouse_actual_status(
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id int unique not null,
    status varchar(100),
    FOREIGN KEY (order_id) REFERENCES warehouse_products_orders(id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);