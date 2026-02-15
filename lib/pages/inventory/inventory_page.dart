import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/inventory/add_item.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';
import 'package:warehouse/utils/user_service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool _loading = false;

  String _currentFilter = "";

  var items;

  double totalCost = 0;

  @override
  void initState() {
    super.initState();
    initItems();
  }

  initItems() async {
    var body = {"user_id": await getUserId(), "filter_type": _currentFilter};

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postService(URL_GET_ITEMS, body);

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      setState(() {
        items = response.body as List;
        totalCost = (items as List)
            .map((el) => items['cost'])
            .reduce((value, element) => value + element);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: const [Text('Stocks')]),
        actions: [
          IconButton(
            onPressed: () => openAddItemPage(null),
            icon: const Icon(Icons.add),
          ),
          addHorizontalSpace(),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: CONTENT_PADDING,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FiltersByUrl(
                filterFor: "inventory",
                onClicked: (choosenValue) {
                  _currentFilter = choosenValue;
                  initItems();
                },
              ),

              SizedBox(
                height: 100,
                width: double.infinity,
                child: Container(
                  padding: CONTENT_PADDING,
                  color: COLOR_BASE,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Total Cost: '), Text('$totalCost', style: getTextTheme(color: COLOR_PRIMARY).headlineMedium,)],
                  ),
                ),
              ),

              (!_loading && items != null)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            onTap: () => openAddItemPage(item),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: RoundedRectImage(
                                    thumbnail_url: item['url'],
                                    height: 100,
                                  ),
                                ),
                                addHorizontalSpace(),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['name']),
                                      addVerticalSpace(),

                                      Text('Cost: ${item['cost']}'),
                                      addVerticalSpace(),
                                      Row(
                                        children: [
                                          Text("Available"),
                                          addHorizontalSpace(),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(width: 0.1),
                                              color: COLOR_BASE,
                                            ),
                                            child: Text(
                                              '${item['available_count']}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ProgressCircular()],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  openAddItemPage(item) async {
    var edited = await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => AddItem(itemObj: item)),
    );

    if (edited) {
      initItems();
    }
  }
}
