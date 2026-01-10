import 'package:flutter/material.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';

class OrderShiped extends StatefulWidget {
  const OrderShiped({super.key});

  @override
  State<OrderShiped> createState() => _OrderShipedState();
}

class _OrderShipedState extends State<OrderShiped> {
  var _shippedOrderList = [];

  @override
  void initState() {
    super.initState();
    // initShippedOrders();
  }

  // initShippedOrders() async {
  //   var body = {};

  //   ApiResponse response = await postService(URL_SHIPPED_ORDERS, body);

  //   if (response.isSuccess) {
  //     setState(() {
  //       _shippedOrderList = response.body;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Shipped'),
      body: Column(
        children: _shippedOrderList.map((order) {
          return ItemOrder(order: order, isDeletable:  false,);
        }).toList(),
      ),
    );
  }
}
