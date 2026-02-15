import 'package:flutter/material.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/project_components/edit_and_scan.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/summaries/summary_order_page.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class RegisteredHistoryPage extends StatefulWidget {
  const RegisteredHistoryPage({super.key});

  @override
  State<RegisteredHistoryPage> createState() => _RegisteredHistoryPageState();
}

class _RegisteredHistoryPageState extends State<RegisteredHistoryPage> {
  var _orderList = [];
  var _flitered_order = [];
  bool _getting_orders = false;

  String _currentFilterValue = "";

  @override
  void initState() {
    super.initState();
    initRegisterOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Label Created (${_flitered_order.length})'),
        actions: [
          IconButton(
            onPressed: () {
              openSummaryPage(1);
            },
            icon: Icon(Icons.summarize),
          ),
        ],
      ),

      body: Column(
        children: [
          FiltersByUrl(
            filterFor: "packed_list",
            onClicked: (choosenValue) {
              _currentFilterValue = choosenValue;
              initRegisterOrders();
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
          addVerticalSpace(),

          Expanded(
            flex: 8,
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
                              timeAgo(
                                order['packed_on'],
                                timezoneOffset: Duration(hours: 5, minutes: 30),
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
    );
  }

  initRegisterOrders() async {
    setState(() {
      _getting_orders = true;
    });
    ApiResponse response = await postService(URL_GET_REGISTERED_ORDERS, {
      "filter_type": _currentFilterValue,
    });

    setState(() {
      _getting_orders = false;
    });

    if (response.isSuccess) {
      setState(() {
        _orderList = response.body;
        _flitered_order = _orderList;
      });
    }
  }

  openSummaryPage(level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) =>
            SummaryOrderPage(level: level, levelName: 'Label'),
      ),
    );
  }
}
