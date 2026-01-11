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

CREATE TABLE warehouse_sku_of_product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id int,
    name varchar(100),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES warehouse_products(id)
);



+-------------------------------------+
| Tables_in_Sunil20090$gov            |
+-------------------------------------+
| applications_for_problem            |
| comments                            |
| election_choices                    |
| election_forms                      |
| election_nominations                |
| election_users                      |
| election_votings                    |
| employees_of_problems               |
| images_of_problems                  |
| jmusic_album_favourites             |
| jmusic_albums                       |
| jmusic_albums_of_songs              |
| jmusic_favourites                   |
| jmusic_screen_log                   |
| jmusic_songs                        |
| jmusic_users                        |
| likes_of_comments                   |
| notifications_for_comments          |
| notifications_for_problems_tracking |
| otp_codes                           |
| problems                            |
| profiles_of_users                   |
| reason_master                       |
| requirements_of_problems            |
| screen_report                       |
| search_queries                      |
| skill_requirement_master            |
| skills_of_users                     |
| tracking_of_problems                |
| users                               |
| warehouse_products                  |
| warehouse_products_images           |
| warehouse_products_orders           |
| warehouse_sku_of_product            |
| warehouse_stages                    |
| warehouse_stages_of_orders          |
| warehouse_stocks_of_products        |
| warehouse_users                     |
+-------------------------------------+


select * from warehouse_products;           
select * from warehouse_products_images;    
select * from warehouse_products_orders;    
select * from warehouse_sku_of_product;     
select * from warehouse_stages;             
select * from warehouse_stages_of_orders;   
select * from warehouse_stocks_of_products; 
select * from warehouse_users;              
