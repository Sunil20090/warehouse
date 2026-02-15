import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/floating_label_edit_box.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class AddSkuPage extends StatefulWidget {
  final int product_id;
  final String product_name;
  final String product_url;
  const AddSkuPage({super.key, required this.product_id, required this.product_name, required this.product_url});

  @override
  State<AddSkuPage> createState() => _AddSkuPageState();
}

class _AddSkuPageState extends State<AddSkuPage> {
  TextEditingController _skuNameController = TextEditingController();
  TextEditingController _bankSettlementController = TextEditingController();

  bool _isAdding = false, _loadingPlatform = false;

  var platforms = [];

  var choosenPlatform;

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
      titleBar: ScreenActionBar(title: 'Add SKU'),
      body: Column(
        children: [
          addVerticalSpace(DEFAULT_LARGE_SPACE),

          RoundedRectImage(thumbnail_url: widget.product_url, width: 100, height:100,),
              addHorizontalSpace(),
              Text(widget.product_name),
          addVerticalSpace(DEFAULT_LARGE_SPACE),

          Divider(),

          addVerticalSpace(DEFAULT_LARGE_SPACE),
          FloatingLabelEditBox(
            labelText: 'SKU name',
            controller: _skuNameController,
          ),

          addVerticalSpace(DEFAULT_LARGE_SPACE),

          FloatingLabelEditBox(
            textInputType: TextInputType.number,
            labelText: 'Bank Settlement',
            controller: _bankSettlementController,
          ),

          addVerticalSpace(DEFAULT_LARGE_SPACE),

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

          LoadableButton(
            name: 'Add',
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
      "platform_id": choosenPlatform['id'],
      "bank_settlement": double.parse(_bankSettlementController.text),
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
