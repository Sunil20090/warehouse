import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class OrderDeepDetailsPage extends StatefulWidget {
  final order_id;
  const OrderDeepDetailsPage({super.key, required this.order_id});

  @override
  State<OrderDeepDetailsPage> createState() => _OrderDeepDetailsPageState();
}

class _OrderDeepDetailsPageState extends State<OrderDeepDetailsPage> {
  var order;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    initOrderDetails();
  }

  initOrderDetails() async {
    var body = {"order_id": widget.order_id};

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postService(URL_ORDER_DEEP_DETAILS, body);

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      setState(() {
        order = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: (!_loading && order != null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                RoundedRectImage(
                                  thumbnail_url: order['thumbnail_url'],
                                  fit: BoxFit.contain,
                                  width: 100,
                                  height: 100,
                                ),
                                addHorizontalSpace(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order['product_name'],
                                        style: getTextTheme().titleSmall,
                                      ),
                                      Text(order['sku_name']),
                                      addVerticalSpace(),

                                      Divider(),
                                      Text(
                                        'Items ',
                                        style: getTextTheme().titleSmall,
                                      ),

                                      Row(
                                        spacing: 4,
                                        children: [
                                          ...order['items_used'].map((item) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                RoundedRectImage(
                                                  width: 50,
                                                  height: 50,
                                                  thumbnail_url:
                                                      item['thumbnail_url'],
                                                ),
                                                Container(
                                                  padding: CONTENT_PADDING,
                                                  decoration: BoxDecoration(
                                                    color: COLOR_BASE,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '${item['quantity_used']}',
                                                    style: getTextTheme()
                                                        .titleSmall,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            addVerticalSpace(),
                            Text(
                              "Order #${order['order_number']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Customer: ${order['custumer_name']}"),
                            Text("Actual Status: ${order['actual_status']}"),
                            Text(
                              "Delivery Partner: ${order['delivery_partener']}",
                            ),
                            Text("Tracking ID: ${order['tracking_id']}"),
                            Text("Platform: ${order['platform_name']}"),
                            Column(
                              children: [
                                RoundedRectImage(
                                  thumbnail_url: order['platform_url'],
                                  width: 40,
                                  height: 40,
                                ),
                              ],
                            ),

                            Text(
                              "Created On: ${standardDate(order['created_on'])}",
                            ),
                          ],
                        ),
                      ),
                    ),
                    addVerticalSpace(),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pricing Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // _priceRow("Price", '₹${order['price']}', ),
                            _priceRow(
                              "Buying Price",
                              '₹${order['buying_price']}',
                            ),
                            _priceRow("GST Price (18%)", '₹${order['gst_price']}'),
                            _priceRow(
                              "Packaging",
                              '₹${order['packaging_cost']}',
                            ),
                            _priceRow(
                              "Quantity",
                              order['quantity'],
                              color: COLOR_BLACK,
                            ),
                            Divider(),

                            (order['actual_bank_settlement'] == null)
                                ? _priceRow(
                                    'Assumed Bank Settlement',
                                    '${order['current_bank_settlement']}',
                                    color: COLOR_BASE_SUCCESS,
                                  )
                                : _priceRow(
                                    'Actual Bank Settlement',

                                    order['actual_bank_settlement'] >= 0
                                        ? '₹${order['actual_bank_settlement']}'
                                        : '-₹${order['actual_bank_settlement'].abs().toStringAsFixed(2)}',
                                    color: COLOR_BASE_SUCCESS,
                                  ),

                            _priceRow("Total Expence", '-₹${order['expence']}'),

                            Divider(),

                            (order['actual_profit'] == null)
                                ? _priceRow(
                                    "Assumed Profit",
                                    order['profit'] >= 0
                                        ? '₹${order['profit'].abs().toStringAsFixed(2)}'
                                        : '-₹${order['profit'].abs().toStringAsFixed(2)}',
                                    color: order['profit'] >= 0
                                        ? COLOR_BASE_SUCCESS
                                        : COLOR_RED,
                                  )
                                : _priceRow(
                                    "Actual Profit",
                                    order['actual_profit'] >= 0
                                        ? '₹${order['actual_profit'].abs().toStringAsFixed(2)}'
                                        : '-₹${order['actual_profit'].abs().toStringAsFixed(2)}',
                                    color: order['actual_profit'] >= 0
                                        ? COLOR_BASE_SUCCESS
                                        : COLOR_RED,
                                  ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Tracking History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...order['trackings'].map((tracking) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: Text(tracking['name'] ?? ''),
                          subtitle: Text(standardDate(tracking['created_on'])),
                        ),
                      );
                    }).toList(),
                  ],
                )
              : Row(children: [ProgressCircular()]),
        ),
      ),
    );
  }

  Widget _priceRow(String title, dynamic value, {color = COLOR_RED}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: getTextTheme(color: color).titleSmall),
          Text("$value", style: getTextTheme(color: color).bodySmall),
        ],
      ),
    );
  }
}
