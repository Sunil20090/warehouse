import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/products/add_product.dart';
import 'package:warehouse/pages/products/add_sku_page.dart';
import 'package:warehouse/pages/products/edit_product.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';
import 'package:warehouse/utils/user_service.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  var _productList = [];

  var isLoading = false;

  String _currentFilter = "";

  @override
  void initState() {
    super.initState();

    initProducts();
  }

  initProducts() async {
    var body = {"user_id": await getUserId(), "filter": _currentFilter};

    setState(() {
      isLoading = true;
    });

    ApiResponse response = await postService(URL_GET_PRODUCTS, body);

    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      setState(() {
        _productList = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(
        title: 'Product List (${_productList.length})',
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                openAddProductPage();
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
      body:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FiltersByUrl(
                  filterFor: "product",
                  onClicked: (filter) {
                    _currentFilter = filter;
                    initProducts();
                  },
                ),
                addVerticalSpace(),
                !isLoading
            ?Column(
                  children: _productList.map((product) {
                    return ListTile(
                      onTap: () {
                        openProductDetails(product['sku_id']);
                      },
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      RoundedRectImage(
                                        fit: BoxFit.contain,
                                        thumbnail_url: product['thumbnail_url'],
                                        image_url: product['image_url'],
                                        width: 100,
                                        height: 80,
                                      ),
                                      Positioned(
                                        left: 4,
                                        top: 4,
                                        child: Image.network(
                                          product['platform_url'],
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  addVerticalSpace(),
                                ],
                              ),
                              addHorizontalSpace(20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      softWrap: true,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Product Id:',
                                          style: getTextTheme().titleSmall,
                                        ),
                                        addHorizontalSpace(),
                                        Text('${product['id']}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Buying price',
                                          style: getTextTheme().titleSmall,
                                        ),
                                        addHorizontalSpace(),
                                        Text('₹${product['buying_price']}'),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          'Bank Settlement',
                                          style: getTextTheme().titleSmall,
                                        ),
                                        addHorizontalSpace(),
                                        Text('₹${product['bank_settlement']}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'SKU Id:',
                                          style: getTextTheme().titleSmall,
                                        ),
                                        addHorizontalSpace(),
                                        Row(
                                          children: [
                                            Text('${product['sku_id']}'),
                                            
                                            
                                          ],
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          'SKU Name:',
                                          style: getTextTheme().titleSmall,
                                        ),
                                        addHorizontalSpace(),
                                        Row(
                                          children: [
                                            Text('${product['sku_name']}'),
                                            addHorizontalSpace(),
                                            InkWell(
                                              onTap: () {
                                                addSKU(product);
                                              },
                                              child: Container(
                                                color: COLOR_BASE,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 36,
                                                  color: COLOR_PRIMARY,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(),

                          Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                ): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressCircular(width: 32, height: 32, color: COLOR_BLACK),
              ],
            ),
              ],
            )
          
    );
  }

  openAddProductPage() async {
    bool isRefressable = await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => AddProduct()),
    );

    if (isRefressable) {
      initProducts();
    }
  }

  Future updateStocks(int product_id, int quantity) async {
    var body = {"product_id": product_id, "quantity": quantity};

    ApiResponse response = await postService(URL_UPDATE_STOCK, body);
    if (response.isSuccess) {
      setState(() {
        _productList.firstWhere((p) => p['id'] == product_id)['quantity'] =
            quantity;
      });
    }
  }

  addSKU(product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => AddSkuPage(
          product_id: product['id'],
          product_name: product['name'],
          product_url: product['thumbnail_url'],
        ),
      ),
    );
  }

  openProductDetails(int sku_id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => EditProduct(sku_id: sku_id),
      ),
    );
  }
}
