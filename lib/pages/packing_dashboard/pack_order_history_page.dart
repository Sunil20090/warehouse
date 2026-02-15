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

class PackOrderHistoryPage extends StatefulWidget {
  const PackOrderHistoryPage({super.key});

  @override
  State<PackOrderHistoryPage> createState() => _PackOrderHistoryPageState();
}

class _PackOrderHistoryPageState extends State<PackOrderHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  var _orderList = [];
  var _flitered_order = [];
  bool _getting_orders = false;

  var _currentFilterType = "";

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPackedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Packed Orders (${_flitered_order.length})'),
            addHorizontalSpace(),
            if (_getting_orders) ProgressCircular(),
          ],
        ),
        actions: [
          

          IconButton(
            onPressed: () {
              openSummaryPage(2);
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
                filterFor: "packed_list",
                onClicked: (value) {
                  _currentFilterType = value;
                  initPackedOrders();
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
                child: ListView.builder(
                  itemCount: _flitered_order.length,
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

  initPackedOrders() async {
    setState(() {
      _getting_orders = true;
    });
    ApiResponse response = await postService(URL_GET_PACKED_ORDERS, {"filter_type" : _currentFilterType});

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

  openSummaryPage(level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) =>
            SummaryOrderPage(level: level, levelName: 'Packed'),
      ),
    );
  }
}
