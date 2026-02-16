import 'package:flutter/material.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/project_components/edit_and_scan.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/summaries/summary_order_page.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class OrderListPage extends StatefulWidget {
  final int level;
  final String screenName;
  const OrderListPage({
    super.key,
    required this.level,
    required this.screenName,
  });

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final TextEditingController _searchController = TextEditingController();

  var _orderList = [];
  var _flitered_order = [];
  bool _getting_orders = false;

  var _currentFilterType = "";

  initOrders() async {
    setState(() {
      _getting_orders = true;
    });
    ApiResponse response = await postService(URL_ORDER_LIST_AT_STAGE, {
      "level": widget.level,
      "filter_type": _currentFilterType,
    });

    setState(() {
      _getting_orders = false;
    });

    if (response.isSuccess) {
      setState(() {
        _orderList = response.body;
        _flitered_order = [];
        _flitered_order = _orderList;
      });
    }
  }

  openSummaryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) =>
            SummaryOrderPage(level: widget.level, levelName: widget.screenName),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('${widget.screenName} Orders (${_flitered_order.length})'),
            addHorizontalSpace(),
            if (_getting_orders) ProgressCircular(),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              openSummaryPage();
            },
            icon: Icon(Icons.summarize),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: CONTENT_PADDING,
          child: Column(
            children: [
              FiltersByUrl(
                filterFor: "order_list",
                onClicked: (value) {
                  _currentFilterType = value;
                  initOrders();
                },
              ),

              EditAndScan(
                onChange: (value) {
                  setState(() {
                    _flitered_order = filterItemBy(_orderList, value);
                  });
                },

                onScanComplete: (scannedValue) {
                  setState(() {
                    _flitered_order = filterItemBy(_orderList, scannedValue);
                  });
                },
              ),
              // addVerticalSpace(),
              Expanded(
                flex: 6,
                child:GridView.builder(

                  itemCount: _flitered_order.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (MediaQuery.of(context).size.width / 480).toInt(), // number of columns
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8, // adjust height/width ratio
                  ),
                  itemBuilder: (context, index) {
                    final order = _flitered_order[index];
                    return Column(
                      children: [
                        ItemOrder(
                          order: order,
                          isDeletable: false,
                          children: [
                            Row(
                              children: [
                                Text("Packed On:"),
                                addHorizontalSpace(),
                                Text(
                                  standardDate(
                                    order['packed_on'],
                                    timezoneOffset: Duration(
                                      hours: 5,
                                      minutes: 30,
                                    ),
                                  ),
                                  style: getTextTheme().titleSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  filterItemBy(List _order_list, String value) {
    if (value == "") {
      return _order_list;
    }
    return _order_list.where((order) {
      return ('${order['custumer_name']}'.toLowerCase()).contains(
            value.toLowerCase(),
          ) ||
          ('${order['tracking_id']}'.toLowerCase()).contains(
            value.toLowerCase(),
          ) ||
          ('${order['delivery_partener']}'.toLowerCase()).contains(
            value.toLowerCase(),
          ) ||
          ('${order['sku_name']}'.toLowerCase()).contains(
            value.toLowerCase(),
          ) ||
          ('${order['actual_status']}'.toLowerCase()).contains(
            value.toLowerCase(),
          ) ||
          ('${order['order_number']}'.toLowerCase()).contains(
            value.toLowerCase(),
          ) ||
          ('${order['product_name']}'.toLowerCase()).contains(
            value.toLowerCase(),
          );
    }).toList();
  }
}
