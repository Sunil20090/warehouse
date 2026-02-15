import 'package:flutter/material.dart';
import 'package:warehouse/components/colored_button.dart';
import 'package:warehouse/components/global_components/floating_label_edit_box.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/project_components/item.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/user_service.dart';

class ChooseItems extends StatefulWidget {
  const ChooseItems({super.key});

  @override
  State<ChooseItems> createState() => _ChooseItemsState();
}

class _ChooseItemsState extends State<ChooseItems> {
  bool _loading = false;
  var items;

  @override
  void initState() {
    super.initState();
    initItems();
  }

  initItems() async {
    var body = {"user_id": await getUserId()};

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postService(URL_GET_ITEMS, body);

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      setState(() {
        items = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Item')),
      body: SafeArea(
        child: Container(
          child: (items != null)
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        showAskAlert(items[index]);
                      },
                      title: Item(item: items[index]),
                    );
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ProgressCircular()],
                ),
        ),
      ),
    );
  }

  void showAskAlert(item) {
    TextEditingController controller = TextEditingController(text: "1");
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text('Quantity?'),

          actions: [
            ColoredButton(
              onPressed: () {
                Navigator.pop(context);
                item['quantity'] = int.parse(controller.text);
                Navigator.pop(context, item);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OK',
                    style: getTextTheme(color: COLOR_BASE).titleMedium,
                  ),
                ],
              ),
            ),
          ],
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity required for: ${item['name']}'),
                Text('${item['name']}', style: getTextTheme().titleSmall),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Enter Quantity'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
