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

CREATE TABLE warehouse_stocks_of_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES warehouse_products(id)
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