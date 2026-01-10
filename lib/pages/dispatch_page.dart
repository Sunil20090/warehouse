import 'package:flutter/material.dart';
import 'package:warehouse/components/colored_button.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class DispatchPage extends StatefulWidget {
  const DispatchPage({super.key});

  @override
  State<DispatchPage> createState() => _DispatchPageState();
}

class _DispatchPageState extends State<DispatchPage> {
  bool _fetchingDetails = false;

  var _orderLists = [];

  bool _dispatching = false;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Dispatch here'),
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
              Text("Orders: ", style: getTextTheme().titleMedium),
              if (_fetchingDetails)
                ProgressCircular(color: COLOR_BLACK, width: 20, height: 20),
              Spacer(),
              ColoredButton(
                onPressed: (!_dispatching)
                ? () {
                  // dipatchAll();
                } : null,
                child: (!_dispatching)
                ? Text(
                  "Dispatch all",
                  style: getTextTheme(color: COLOR_BASE).titleMedium,
                ) : ProgressCircular(width: 20, height: 20, color: COLOR_BASE,),
              ),
            ],
          ),
          addVerticalSpace(DEFAULT_LARGE_SPACE),
          ..._orderLists.map((order) {
            return ItemOrder(
              order: order,
              onDeleteClicked: (order) => deleteOrder(order),
            );
          }).toList(),
        ],
      ),
    );
  }

  fetchOrderDetails(String trackingId) async {
    var body = {"tracking_id": trackingId};

    setState(() {
      _fetchingDetails = true;
    });

    ApiResponse response = await postService(URL_ORDER_DETAILS, body);

    setState(() {
      _fetchingDetails = false;
    });

    if (response.isSuccess) {
      if (response.body.length > 0) {
        setState(() {
          _orderLists.add(response.body[0]);
        });
      } else {
        showAlert(context, "Failed!", "Item not found!");
      }
    }
  }

  void deleteOrder(order) {
    print('deleting');
    int index = _orderLists.indexWhere(
      (el) => el['tracking_id'] == order['tracking_id'],
    );

    print(index);
    if (index != -1) {
      setState(() {
        _orderLists.removeAt(index);
      });
    }
  }

  // void dipatchAll() async {
  //   var body = {
  //     "tracking_id_list": _orderLists.map((el) => el['tracking_id']).toList(),
  //   };

  //   setState(() {
  //     _dispatching = true;
  //   });

  //   ApiResponse response = await postService(URL_MARK_DISPATCH, body);

  //   setState(() {
  //     _dispatching = false;
  //   });


  //   if (response.isSuccess) {
  //     // showAlert(context, response.body['heading']
  //     //, response.body['message']);
  //   }
  // }
}
