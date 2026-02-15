select * from warehouse_products;
select * from warehouse_products_images;
select * from warehouse_products_orders;
select * from warehouse_sku_of_product;
select * from warehouse_stages;
select * from warehouse_stages_of_orders;
select * from warehouse_users;
select * from warehouse_packets;
select * from warehouse_packing_materials;
select * from warehouse_packing_types;

select * from warehouse_item_inventory;


select * from warehouse_items_in_product;

--PRODUCT DETAILS
select 
*
from warehouse_sku_of_product wsop
LEFT JOIN (
    SELECT id, name, buying_price FROM warehouse_products

) as wp ON wp.id = wsop.product_id

LEFT JOIN (
    SELECT product_id, thumbnail_url FROM warehouse_products_images
) as wpi ON wpi.product_id = wp.id




