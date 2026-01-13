import 'dart:io';

import 'package:flutter/material.dart';
import 'package:warehouse/components/choose_image.dart';
import 'package:warehouse/components/colored_button.dart';
import 'package:warehouse/components/floating_label_edit_box.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
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
  TextEditingController _priceController = TextEditingController();
  TextEditingController _bankSettlementController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Add Product'),
      body: Column(
        children: [
          addVerticalSpace(),
          FloatingLabelEditBox(labelText: 'Name', controller: _nameController),
          addVerticalSpace(),
          FloatingLabelEditBox(labelText: 'Short Name', controller: _shortNameController),
          addVerticalSpace(),
          FloatingLabelEditBox(labelText: 'SKU ID', controller: _skuIdController),
          addVerticalSpace(),
          FloatingLabelEditBox(labelText: 'Buying price', controller: _priceController, textInputType: TextInputType.number,),
          addVerticalSpace(),
          
          FloatingLabelEditBox(
            labelText: 'Bank Settlement',
            controller: _bankSettlementController,
            textInputType: TextInputType.number,
          ),
          addVerticalSpace(),
          ChooseImage(
            onFileSelected: (imageFile) {
              _imageFile = imageFile;
            },
          ),
          addVerticalSpace(),
          ColoredButton(
            onPressed: () {
              addProductApi();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ADD',
                  style: getTextTheme(color: COLOR_WHITE).titleMedium,
                ),
              ],
            ),
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

    if (_priceController.text.trim().isEmpty || _bankSettlementController.text.trim().isEmpty) {
      showAlert(context, 'Empty!', 'prices is empty');
      return;
    }

    if (_imageFile == null) {
      showAlert(context, 'Error!', 'Image not attached');
      return;
    }

    String base64 = await fileToBase64(_imageFile!);
    var body = {
      "user_id": await getUserId(),
      "name": _nameController.text,
      "sku_name": _skuIdController.text,
      "short_name" : _shortNameController.text,
      "buying_price" : double.parse(_priceController.text),
      "bank_settlement" : double.parse(_bankSettlementController.text),
      "product_image": base64,
    };

    ApiResponse response = await postService(URL_ADD_PRODUCT, body);
    if (response.isSuccess) {
      if (response.body['status'] == "OK") {
        Navigator.pop(context, true);
      }
    }
  }
}
