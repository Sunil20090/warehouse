import 'package:flutter/material.dart';
import 'package:warehouse/components/item_order.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/project_components/edit_and_scan.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class SearchOrders extends StatefulWidget {
  const SearchOrders({super.key});

  @override
  State<SearchOrders> createState() => _SearchOrdersState();
}

class _SearchOrdersState extends State<SearchOrders> {
  String _searchKey = "";

  bool _searching = false;

  var _orderList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              EditAndScan(
                onChange: (value) {
                  _searchKey = value;
                  searchGlobaly();
                },
              ),

              addVerticalSpace(40),

              LoadableButton(
                name: 'Search',
                onClicked: searchGlobaly,
                isLoading: _searching,
              ),

              Divider(),

              addVerticalSpace(),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  addHorizontalSpace(),
                  Text(
                    'Found: (${_orderList.length})',
                    style: getTextTheme().titleSmall,
                  ),
                ],
              ),
              addVerticalSpace(),
              Expanded(
                flex: 6,
                child: ListView.builder(
                  itemCount: _orderList.length,
                  itemBuilder: (context, index) {
                    final order = _orderList[index];
                    return Column(
                      children: [ItemOrder(order: order, isDeletable: false)],
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

  searchGlobaly() async {
    var body = {"key": _searchKey.toLowerCase()};

    setState(() {
      _searching = true;
    });

    ApiResponse response = await postService(URL_SEARCH_ORDER, body);

    setState(() {
      _searching = false;
    });

    if (response.isSuccess) {
      setState(() {
        _orderList = response.body;
      });
    }
  }
}
