



desc warehouse_item_inventory;
alter table warehouse_item_inventory add column cost decimal(10, 2) DEFAULT 0.0 not null;



update warehouse_item_inventory set cost = 160 where id = 4;


select product_id, thumbnail_url from warehouse_products_images;


UPDATE warehouse_item_inventory set url = 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_166omUUEPK.jpg' where id = 3;

+----+------------+-----------------|----------------------------------------------------------+--------------+------------+----------------------------------------------------------------------------------------+
| id | product_id | name            |bank_settlement  name                                     | buying_price | product_id | thumbnail_url                                                                          |
+----+------------+-----------------|----------------------------------------------------------+--------------+------------+----------------------------------------------------------------------------------------+
|  1 |          4 | m_ftdA3A        |         133.00  FT23RL USB TO TTL 3.3V/5V FTDI           |        90.00 |          4 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_7VPydiubom.jpg |
|  2 |          5 | V6RYlJIS        |         256.00  Arduino Nano R3 Development Board        |       160.00 |          5 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_Kw9HMolWq0.jpg |
|  3 |          6 | t58xbOZr        |         349.00  Arduino UNO R3 DIP                       |       250.00 |          6 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_lgDF7ra6Mi.jpg |
|  4 |          7 | b6IedtJl        |         146.00  SG90 9G Micro Digital Servo Motor        |        65.00 |          7 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_0Lbq7tn4ju.jpg |
|  5 |          8 | iUDCivqz        |         199.00  OLED Display I2C 128x64 Module 0.96 inch |       110.00 |          8 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_h36SGx03TH.jpg |
|  6 |          9 | Uvluu64H        |         262.00  Arduino Uno SMD Development              |       170.00 |          9 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_btc9ex15ls.jpg |
|  7 |         10 | H8pwIXQr        |          46.00  TP4056 1A Li Ion Lithium battery USB - C |        16.11 |         10 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_1B4nkK9aw3.jpg |
|  8 |          6 | modulcircuit003 |         329.00  Arduino UNO R3 DIP                       |       250.00 |          6 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_lgDF7ra6Mi.jpg |
| 10 |         12 | W1D2zWuS        |          52.00  USB-B For Arduino UNO                    |        10.00 |         12 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_zb0UW0D8V7.jpg |
| 11 |         13 | 2ukiiFLy        |         232.00  LCD 16X2 Character Display Module        |        65.00 |         13 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_45zQQfCl3E.jpg |
| 12 |         14 | z8uaRh3V        |         257.00  HC-05 Bluetooth Module                   |       150.00 |         14 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_166omUUEPK.jpg |
| 13 |         15 | rxr7SAz4        |         156.00  Breadboard Solderless Prototyping Board  |        65.00 |         15 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_NH08QewAM9.jpg |
| 14 |          8 | modulecircuit008|         183.00  OLED Display I2C 128x64 Module 0.96 inch |       110.00 |          8 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_h36SGx03TH.jpg |
| 15 |         16 | HLQTXYSl        |         359.00  USB-B For Arduino UNO With CABLE         |       270.00 |         16 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_Sl6IvDO3rd.jpg |
| 16 |         17 | Zp6cGH67        |         237.00  Node MCU ESP8266                         |       150.00 |         17 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_RmHvuun1HK.jpg |
| 17 |         18 | 93CQGaQ-        |         345.00  Arduino UNO with jumper and cable        |       280.00 |         18 | https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_mj0ZViRBBg.jpg |
+----+------------+-----------------|----------------------------------------------------------+--------------+------------+----------------------------------------------------------------------------------------+

update warehouse_item_inventory set url = 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_btc9ex15ls.jpg' where id = 

insert into warehouse_item_inventory (name, available_count, url, cost)
values 
('FT23RL USB TO TTL 3.3V/5V FTDI', 6, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_7VPydiubom.jpg', 90),
('OLED Display I2C 128x64 Module 0.96 inch', 6, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_h36SGx03TH.jpg', 110),
('Arduino Uno SMD Development', 44, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_lgDF7ra6Mi.jpg', 170),
('TP4056 1A Li Ion Lithium battery USB - C', 116, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_1B4nkK9aw3.jpg', 16.11),
('USB-B TO USB A Type', 44, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_zb0UW0D8V7.jpg', 15),
('LCD 16X2 Character Display Module', 20, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_45zQQfCl3E.jpg', 65),
('Breadboard Solderless Prototyping Board', 10, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_NH08QewAM9.jpg', 65),
('Node MCU ESP8266', 6, 'https://sunil20090.pythonanywhere.com/assets/images/warehouse/thumbnail_RmHvuun1HK.jpg', 150);
('Male to Male Jumper', 320, '', 65),




INSERT INTO warehouse_items_in_product (item_id, product_id) 
values (2, 7);

desc warehouse_items_in_product;


update warehouse_items_in_product set quantity_used = 1;

select 
    wii.id,
    wii.name,
    wiip.quantity_used,
    wp.name
from warehouse_items_in_product wiip

LEFT JOIN (
    SELECT id, name, url from warehouse_item_inventory
) as wii ON wii.id = wiip.item_id

LEFT JOIN (
    select id, name from warehouse_products 
) as wp on wp.id = wiip.product_id

where wiip.product_id = 6

select * from warehouse_items_in_product;


+----+---------+------------------------------------------+---------------------+--------------+------------+
| id | user_id | name                                     | created_on          | buying_price | short_name |
+----+---------+------------------------------------------+---------------------+--------------+------------+
|  4 |       1 | FT23RL USB TO TTL 3.3V/5V FTDI           | 2026-01-06 06:25:55 |        90.00 | FT23RL     |
|  5 |       1 | Arduino Nano R3 Development Board        | 2026-01-06 17:50:32 |       160.00 | Nano       |
|  6 |       1 | Arduino UNO R3 DIP                       | 2026-01-06 17:52:08 |       250.00 | DIP        |
|  7 |       1 | SG90 9G Micro Digital Servo Motor        | 2026-01-06 17:54:58 |        65.00 | Servo      |
|  8 |       1 | OLED Display I2C 128x64 Module 0.96 inch | 2026-01-06 17:56:18 |       110.00 | OLED       |
|  9 |       1 | Arduino Uno SMD Development              | 2026-01-07 14:06:04 |       170.00 | SMD        |
| 10 |       1 | TP4056 1A Li Ion Lithium battery USB - C | 2026-01-10 05:40:57 |        16.11 | TP4056     |
| 12 |       1 | USB-B For Arduino UNO                    | 2026-01-14 07:11:46 |        10.00 | USB-B      |
| 13 |       1 | LCD 16X2 Character Display Module        | 2026-01-14 17:18:51 |        65.00 | LCD        |
| 14 |       1 | HC-05 Bluetooth Module                   | 2026-01-14 17:26:00 |       150.00 | HC-05      |
| 15 |       1 | Breadboard Solderless Prototyping Board  | 2026-01-14 17:27:49 |        65.00 | Breadboard |
| 16 |       1 | USB-B For Arduino UNO With CABLE         | 2026-01-21 08:57:44 |       270.00 | UNO & CBL  |
| 17 |       1 | Node MCU ESP8266                         | 2026-01-25 09:31:55 |       150.00 | Node       |
| 18 |       1 | Arduino UNO with jumper and cable        | 2026-02-01 17:56:51 |       280.00 | UNO-CA-JUM |
+----+---------+------------------------------------------+---------------------+--------------+------------+
14 rows in set (0.01 sec)
mysql> select * from warehouse_sku_of_product;
|-----------+------------------+---------------------+----------+-----------------+-------------+
|product_id | name             | created_on          | source   | bank_settlement | platform_id |
|-----------+------------------+---------------------+----------+-----------------+-------------+
|         4 | m_ftdA3A         | 2026-01-10 20:00:25 | 1        |          133.00 |           1 |
|         5 | V6RYlJIS         | 2026-01-10 20:00:25 | 1        |          256.00 |           1 |
|         6 | t58xbOZr         | 2026-01-10 20:00:25 | 1        |          349.00 |           1 |
|         7 | b6IedtJl         | 2026-01-10 20:00:25 | 1        |          146.00 |           1 |
|         8 | iUDCivqz         | 2026-01-10 20:00:25 | 1        |          199.00 |           1 |
|         9 | Uvluu64H         | 2026-01-10 20:00:25 | 2        |          262.00 |           1 |
|        10 | H8pwIXQr         | 2026-01-10 20:00:25 | 1        |           46.00 |           1 |
|         6 | modulcircuit003  | 2026-01-11 12:59:47 | 1        |          329.00 |           2 |
|        12 | W1D2zWuS         | 2026-01-14 07:11:46 | 1        |           52.00 |           1 |
|        13 | 2ukiiFLy         | 2026-01-14 17:18:51 | meesho   |          232.00 |           1 |
|        14 | z8uaRh3V         | 2026-01-14 17:26:00 |          |          257.00 |           1 |
|        15 | rxr7SAz4         | 2026-01-14 17:27:49 |          |          156.00 |           1 |
|         8 | modulecircuit008 | 2026-01-15 04:01:11 | flipkart |          183.00 |           2 |
|        16 | HLQTXYSl         | 2026-01-21 08:57:44 |          |          359.00 |           1 |
|        17 | Zp6cGH67         | 2026-01-25 09:31:55 |          |          237.00 |           1 |
|        18 | 93CQGaQ-         | 2026-02-01 17:56:51 |          |          345.00 |           1 |
|-----------+------------------+---------------------+----------+-----------------+-------------+



items
+----+------------------------------------------+------------------+--------+
| id | name                                     | available_count  | cost   |
+----+------------------------------------------+------------------+--------+
|  1 | Arduino UNO R3 DIP                       |              48  | 270.00 |
|  2 | SG90 9G Micro Digital Servo Motor        |              24  |  70.00 |
|  3 | HC-05 Bluetooth Module                   |              16  | 150.00 |
|  4 | Arduino Nano R3 Development Board        |              14  | 160.00 |
|  8 | FT23RL USB TO TTL 3.3V/5V FTDI           |               6  |  90.00 |
|  9 | OLED Display I2C 128x64 Module 0.96 inch |               6  | 110.00 |
| 10 | Arduino Uno SMD Development              |              44  | 170.00 |
| 11 | TP4056 1A Li Ion Lithium battery USB - C |             116  |  16.11 |
| 12 | USB-B TO USB A Type                      |              44  |  15.00 |
| 13 | LCD 16X2 Character Display Module        |              20  |  65.00 |
| 14 | Breadboard Solderless Prototyping Board  |              10  |  65.00 |
| 15 | Node MCU ESP8266                         |               6  | 150.00 |
| 16 | Male to Male Jumper Wire                 |             320  |   1.00 |
+----+------------------------------------------+------------------+--------+


insert into warehouse_items_in_product 
(product_id, item_id, quantity_used)
values
(21, 10, 1),
(21, 12, 1);


 update warehouse_sku_of_product set bank_settlement =  280 where id = 19;



update warehouse_item_inventory wii 
join 
(
    select item_id, quantity_used from warehouse_items_in_product where product_id = %s
) as wiip ON wiip.item_id = wii.id

set wii.available_count = wii.available_count - wiip.quantity_used;