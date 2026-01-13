import 'package:flutter/material.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class RegisterOrderPage extends StatefulWidget {
  const RegisterOrderPage({super.key});

  @override
  State<RegisterOrderPage> createState() => _RegisterOrderPageState();
}

class _RegisterOrderPageState extends State<RegisterOrderPage> {


  var _orderList = [];

  bool loading = false;


  @override
  void initState() {
    super.initState();

    initOrderList();
  }

  initOrderList() async {

    var body = {};

    setState(() {
      loading = true;
    });
    ApiResponse response = await postService(URL_GET_REGISTERED_ORDERS, body);
    setState(() {
      loading = false;
    });

    if(response.isSuccess){
      setState(() {
        _orderList = response.body;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(titleBar: ScreenActionBar(title: 'Registered Orders'),
      body: (!loading)
      ? Column(
        children: [
          ..._orderList.map((order) {
            return Column(
              children: [
                ItemOrder(order: order, isDeletable: false,),
                Divider()
              ],
            );
          }).toList()
        ],
      ) : Column(
        children: [
          addVerticalSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressCircular()
            ],
          ),
        ],
      ),
    );
  }
}