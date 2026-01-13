import 'package:flutter/material.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class PackOrdersPage extends StatefulWidget {
  const PackOrdersPage({super.key});

  @override
  State<PackOrdersPage> createState() => _PackOrdersPageState();
}

class _PackOrdersPageState extends State<PackOrdersPage> {
  var _orderList = [];
  var _packable_order_list = [];

  bool _packing_orders = false;

  bool _getting_orders = false;

  bool _fetching_orderDetails = false;

  @override
  void initState() {
    super.initState();
    initPackedOrders();
  }

  initPackedOrders() async {
    setState(() {
      _getting_orders = true;
    });
    ApiResponse response = await postService(URL_GET_PACKED_ORDERS, {});

    setState(() {
      _getting_orders = false;
    });

    if (response.isSuccess) {
      setState(() {
        _orderList = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Pack Order'),
      body: Column(
        children: [
          addVerticalSpace(),
          InkWell(
            onTap: () async {
              final tracking_id = await getScanValue();
              if (tracking_id != "") {
                fetchOrderDetails(tracking_id);
              }
            },
            child: Card(
              child: Column(
                children: [
                  Icon(Icons.qr_code_scanner, color: COLOR_PRIMARY, size: 100),
                  addVerticalSpace(),
                ],
              ),
            ),
          ),
          addVerticalSpace(),

          Row(
            children: [
              Text(
                "Orders Scanned: (${_packable_order_list.length})",
                style: getTextTheme().titleMedium,
              ),
              // if (_getting_order)
              //   ProgressCircular(color: COLOR_BLACK, width: 20, height: 20),
              Spacer(),

              LoadableButton(
                name: 'Clear All',
                onClicked: () {
                  setState(() {
                    _packable_order_list.clear();
                  });
                },
              ),

              LoadableButton(
                name: 'Pack All',
                onClicked: packProductApi,
                isLoading: _packing_orders,
              ),
            ],
          ),

          Column(
            children: [
              ..._packable_order_list.map((order) {
                return ItemOrder(order: order, onDeleteClicked: deleteOrder);
              }).toList(),
              Divider(),
            ],
          ),
          addVerticalSpace(DEFAULT_LARGE_SPACE),

          Divider(),
          Row(
            children: [
              Text('Paked Orders (History) (${_orderList.length}):'),
              addHorizontalSpace(),
              if (_getting_orders) ProgressCircular(),
            ],
          ),

          addVerticalSpace(),

          ..._orderList.map((order) {
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
          }).toList(),
        ],
      ),
    );
  }

  fetchOrderDetails(String trackingId) async {
    var body = {"tracking_id": trackingId};

    setState(() {
      _fetching_orderDetails = true;
    });

    ApiResponse response = await postService(URL_ORDER_DETAILS, body);

    setState(() {
      _fetching_orderDetails = false;
    });

    if (response.isSuccess) {
      if (response.body.length > 0) {
        setState(() {
          _packable_order_list.add(response.body[0]);
        });
      } else {
        showAlert(context, "Failed!", "Item not found!");
      }
    }
  }

  void deleteOrder(order) {
    print('deleting');
    int index = _packable_order_list.indexWhere(
      (el) => el['tracking_id'] == order['tracking_id'],
    );

    print(index);
    if (index != -1) {
      setState(() {
        _packable_order_list.removeAt(index);
      });
    }
  }

  packProductApi() async {
    if (_packable_order_list.isEmpty) {
      showAlert(context, 'Error!', "No item to pack");
      return;
    }

    var body = {
      "tracking_ids": _packable_order_list
          .map((order) => order['tracking_id'])
          .toList(),
    };

    setState(() {
      _packing_orders = true;
    });

    ApiResponse response = await postService(URL_PACK_ORDER, body);

    setState(() {
      _packing_orders = false;
    });

    if (response.isSuccess) {
      if (response.body['status'] == 'OK') {
        showAlert(context, response.body['heading'], response.body['message']);
        initPackedOrders();
      }
    } else {
      showAlert(context, "Failed!", "Item not found!");
    }
  }
}
