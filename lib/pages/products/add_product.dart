import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/choose_image.dart';
import 'package:warehouse/components/global_components/floating_label_edit_box.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/inventory/choose_items.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';
import 'package:warehouse/utils/user_service.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _shortNameController = TextEditingController();
  TextEditingController _skuIdController = TextEditingController();
  TextEditingController _bankSettlementController = TextEditingController();

  bool _addingProduct = false;

  var choosenItems = [];

  var platforms = [];
  var choosenPlatform;
  bool _loadingPlatform = false;

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();

    initPlatforms();
  }

  initPlatforms() async {
    var body = {};

    setState(() {
      _loadingPlatform = true;
    });
    ApiResponse response = await postService(URL_GET_PLATFORMS, body);

    setState(() {
      _loadingPlatform = false;
    });

    if (response.isSuccess) {
      setState(() {
        platforms = response.body;
        choosenPlatform = platforms[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Add Product'),
      body: Column(
        children: [
          addVerticalSpace(),
          FloatingLabelEditBox(labelText: 'Name', controller: _nameController),
          addVerticalSpace(),
          FloatingLabelEditBox(
            labelText: 'Short Name',
            controller: _shortNameController,
          ),
          addVerticalSpace(),
          FloatingLabelEditBox(
            labelText: 'SKU Name',
            controller: _skuIdController,
          ),
          addVerticalSpace(),

          FloatingLabelEditBox(
            labelText: 'Bank Settlement',
            controller: _bankSettlementController,
            textInputType: TextInputType.number,
          ),
          addVerticalSpace(),

          Divider(),

          Row(
            children: [
              Text(
                'Items (${choosenItems.length})',
                style: getTextTheme().titleMedium,
              ),
              IconButton(onPressed: openChooseItemPage, icon: Icon(Icons.add)),
            ],
          ),

          ...choosenItems.map((item) {
            return ListTile(
              title: Row(
                children: [
                  Card(
                    margin: EdgeInsets.all(9),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          RoundedRectImage(
                            thumbnail_url: item['url'],
                            fit: BoxFit.contain,
                          ),
                          addHorizontalSpace(),
                          Container(
                            padding: CONTENT_PADDING,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(width: 0.2),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '0${item['quantity']}',
                                  style: getTextTheme().headlineMedium,
                                ),
                                Text(
                                  'Required',
                                  style: getTextTheme().titleSmall,
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              var index = choosenItems.indexWhere(
                                (element) => element['id'] == item['id'],
                              );

                              setState(() {
                                choosenItems.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.delete, color: COLOR_RED),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Platforms ', style: getTextTheme().titleSmall),
              if (_loadingPlatform) ProgressCircular(),
            ],
          ),
          ...platforms.map((platform) {
            return Row(
              children: [
                Radio(
                  value: platform['name'],
                  groupValue: choosenPlatform['name'],
                  onChanged: (value) {
                    setState(() {
                      choosenPlatform = platforms.firstWhere(
                        (el) => el['id'] == platform['id'],
                      );
                    });
                  },
                ),
                Text(platform['name']),
              ],
            );
          }).toList(),

          Divider(),

          ChooseImage(
            onBytesRead: (bytesRecieved) {
              _imageBytes = bytesRecieved;
            },
          ),
          addVerticalSpace(),

          LoadableButton(
            name: 'ADD Product',
            isLoading: _addingProduct,
            onClicked: addProductApi,
          ),
        ],
      ),
    );
  }

  addProductApi() async {
    if (_nameController.text.trim().length < 6) {
      showAlert(context, 'Error!', 'Name is too short');
      return;
    }
    if (_skuIdController.text.trim().isEmpty) {
      showAlert(context, 'Empty!', 'SKU is empty');
      return;
    }

    if (_imageBytes == null) {
      showAlert(context, 'Error!', 'Image not attached');
      return;
    }

    var body = {
      "user_id": await getUserId(),
      "name": _nameController.text,
      "sku_name": _skuIdController.text,
      "short_name": _shortNameController.text,
      "bank_settlement": double.parse(_bankSettlementController.text),
      "platform_id": choosenPlatform['id'],
      "items": choosenItems
          .map((el) => {"id": el['id'], "quantity": el['quantity']})
          .toList(),
    };

    setState(() {
      _addingProduct = true;
    });

    ApiResponse response = await postBytesService(URL_ADD_PRODUCT, _imageBytes!, jsonBody: body);

    setState(() {
      _addingProduct = false;
    });

    if (response.isSuccess) {
      if (response.body['status'] == "OK") {
        showAlert(context, response.body['heading'], response.body['message']);
        // Navigator.pop(context, true);
      }
    }
  }

  openChooseItemPage() async {
    var itemChoosed = await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => ChooseItems()),
    );

    if (itemChoosed != null) {
      setState(() {
        choosenItems.add(itemChoosed);
      });
    }
  }
}
