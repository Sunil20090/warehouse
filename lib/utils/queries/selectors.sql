



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
| warehouse_packets                   |
| warehouse_packing_materials         |
| warehouse_packing_types             |
| warehouse_platforms                 |
| warehouse_products                  |
| warehouse_products_images           |
| warehouse_products_orders           |
| warehouse_sku_of_product            |
| warehouse_stages                    |
| warehouse_stages_of_orders          |
|                                     |
| warehouse_users                     |
+-------------------------------------+


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
select * from warehouse_platforms;


select * from warehouse_stages_of_orders where order_id = 4;

delete from warehouse_stages_of_orders where order_id = 317 and stage_id = 2;