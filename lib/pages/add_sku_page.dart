import 'package:flutter/material.dart';
import 'package:warehouse/components/colored_button.dart';
import 'package:warehouse/components/floating_label_edit_box.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class AddSkuPage extends StatefulWidget {
  final int product_id;
  const AddSkuPage({super.key, required this.product_id});

  @override
  State<AddSkuPage> createState() => _AddSkuPageState();
}

class _AddSkuPageState extends State<AddSkuPage> {
  TextEditingController _skuNameController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();

  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Add SKU'),
      body: Column(
        children: [
          addVerticalSpace(),
          FloatingLabelEditBox(
            labelText: 'SKU name',
            controller: _skuNameController,
          ),
          addVerticalSpace(),
          FloatingLabelEditBox(
            labelText: 'source',
            controller: _sourceController,
          ),

          addVerticalSpace(DEFAULT_LARGE_SPACE),

          LoadableButton(
            name: 'Add Sku',
            isLoading: _isAdding,
            onClicked: () => addSkuApi(),
          ),
        ],
      ),
    );
  }

  addSkuApi() async {
    var body = {
      "product_id": widget.product_id,
      "sku_name": _skuNameController.text,
      "source": _sourceController.text,
    };

    setState(() {
      _isAdding = true;
    });

    ApiResponse response = await postService(URL_ADD_SKU, body);

    setState(() {
      _isAdding = false;
    });

    if (response.isSuccess) {
      if (response.body['status'] == "OK") {
        Navigator.pop(context);
      } else {
        showAlert(context, response.body['heading'], response.body['message']);
      }
    }
  }
}
