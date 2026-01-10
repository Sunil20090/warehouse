import 'package:flutter/material.dart';
import 'package:warehouse/components/choise_button.dart';
import 'package:warehouse/components/counter.dart';
import 'package:warehouse/components/filter_choice.dart';
import 'package:warehouse/components/floating_label_edit_box.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/add_product.dart';
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

  @override
  void initState() {
    super.initState();

    initProducts();
  }

  initProducts() async {
    var body = {"user_id": await getUserId()};

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
        title: 'Product List',
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
      body: !isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Filter:'),
                    FilterChoice(
                      onChosen: (appliedModals) {
                        print(appliedModals);
                      },
                      filterOptions: [
                        FilterModal(value: 'Out of stock'),
                        FilterModal(value: 'Low Stock', isApplied: true),
                      ],
                    ),
                  ],
                ),
                addVerticalSpace(),
                Column(
                  children: _productList.map((product) {
                    final TextEditingController _controller =
                        TextEditingController(text: '${product['quantity']}');

                    return ListTile(
                      contentPadding: CONTENT_PADDING,
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  RoundedRectImage(
                                    fit: BoxFit.contain,
                                    thumbnail_url: product['thumbnail_url'],
                                    width: 100,
                                    height: 80,
                                  ),
                                  addVerticalSpace(),
                                  (product['quantity'] == 0)
                                      ? Text(
                                          'Out of Stock',
                                          style: getTextTheme(
                                            color: COLOR_BASE_ERROR,
                                          ).titleMedium,
                                        )
                                      : Text(
                                          'Stock: ${product['quantity']}',
                                          style: getTextTheme().titleMedium,
                                        ),
                                ],
                              ),
                              addHorizontalSpace(20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                          'SKU Id:',
                                          style: getTextTheme().titleSmall,
                                        ),
                                        addHorizontalSpace(),
                                        Text('${product['sku_id']}'),
                                      ],
                                    ),

                                    Text(
                                      product['name'],
                                      softWrap: true,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: TextField(
                                            controller: _controller,
                                            decoration: InputDecoration(
                                              hintText: 'Count',
                                            ),
                                          ),
                                          // FloatingLabelEditBox(
                                          //   labelText: 'count',
                                          //   controller: _controller,
                                          // ),
                                        ),

                                        addHorizontalSpace(),

                                        InkWell(
                                          onTap: () {
                                            updateStocks(
                                              product['id'],
                                              int.parse(_controller.text),
                                            );
                                          },
                                          child: Badge(
                                            padding: CONTENT_PADDING,
                                            label: Icon(
                                              Icons.check,
                                              color: COLOR_BASE,
                                            ),
                                          ),
                                        ),

                                        addHorizontalSpace(),
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
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressCircular(
                    width: 32,
                    height: 32,
                    color: COLOR_BLACK,
                  ),
                ),
              ],
            ),
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
}
