import 'package:flutter/material.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/loadable_button.dart';
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
              scanAndFetch();
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
                return Container(
                  padding: CONTENT_PADDING,
                  color: order['stage_id'] == 1
                      ? const Color.fromARGB(255, 220, 255, 238)
                      : const Color.fromARGB(255, 247, 224, 224),
                  child: ItemOrder(order: order),
                );
              }).toList(),
              Divider(),
            ],
          ),
          addVerticalSpace(DEFAULT_LARGE_SPACE),
        ],
      ),
    );
  }

  fetchOrderDetails(String trackingId) async {
    var body = {"tracking_id": trackingId};

    final items = _packable_order_list
        .where((element) => element['tracking_id'] == trackingId)
        .toList();

    if (items.isNotEmpty) {
      showAlert(
        context,
        "Already!",
        "Already scanned \t\n \"${items[0]['custumer_name']}\"",
      );
      return;
    }

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
          // _packable_order_list.add(response.body[0]);
          var item = response.body[0];

          _packable_order_list.insert(0, item);
        });
      } else {
        showAlert(context, "Failed!", "Item not found!");
      }
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
      // _packable_order_list.

      _packable_order_list.forEach((order) {
        List response_tracking_ids = response.body;
        if (response_tracking_ids.any(
          (elment) => elment['tracking_id'] == order['tracking_id'],
        )) {
          order['stage_id'] = 2;
        }
      });
    } else {
      showAlert(context, "Failed!", "Failed to packing");
    }
  }

  scanAndFetch() async {
    final tracking_id = await getScanValue();
    if (tracking_id != "") {
      scanAndFetch();
      fetchOrderDetails(tracking_id);
    }
  }
}
