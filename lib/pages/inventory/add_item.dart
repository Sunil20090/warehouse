import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/choose_image.dart';
import 'package:warehouse/components/global_components/floating_label_edit_box.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class AddItem extends StatefulWidget {
  var itemObj;
  AddItem({super.key, this.itemObj});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool _loading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _availableCountController = TextEditingController();
  TextEditingController _costController = TextEditingController();

  Uint8List? _imageBytes;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _availableCountController.dispose();
    _costController.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.itemObj != null) {
      _nameController.text = widget.itemObj['name'];
      _costController.text = widget.itemObj['cost'].toString();
      _availableCountController.text = widget.itemObj['available_count']
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Or Update Item')),
      body: SafeArea(
        child: Container(
          padding: SCREEN_PADDING,
          child: Column(
            children: [
              addVerticalSpace(DEFAULT_LARGE_SPACE),
              (widget.itemObj == null)
                  ? ChooseImage(
                      onBytesRead: (bytesRecieved) {
                        _imageBytes = bytesRecieved;
                      },
                    )
                  : RoundedRectImage(
                      thumbnail_url: widget.itemObj['url'],
                      width: 201,
                      height: 200,
                    ),
              addVerticalSpace(),
              FloatingLabelEditBox(
                labelText: 'Name',
                controller: _nameController,
              ),
              addVerticalSpace(),
              FloatingLabelEditBox(
                textInputType: TextInputType.number,
                labelText: 'Cost',
                controller: _costController,
              ),
              addVerticalSpace(),
              FloatingLabelEditBox(
                textInputType: TextInputType.number,
                labelText: 'Available Stock',
                controller: _availableCountController,
              ),
              addVerticalSpace(),

              (widget.itemObj == null)
                  ? LoadableButton(
                      name: 'Add',
                      isLoading: _loading,
                      onClicked: addItem,
                    )
                  : LoadableButton(
                      name: 'Update',
                      isLoading: _loading,
                      onClicked: updateItem,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  addItem() async {
    var body = {
      "name": _nameController.text,
      "available_count": int.parse(_availableCountController.text),
      "cost": double.parse(_costController.text),
    };

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postBytesService(
      URL_ADD_ITEM,
      _imageBytes!,
      jsonBody: body,
    );

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      Navigator.pop(context, true);
    }
  }

  updateItem() async {
    var body = {
      "name": _nameController.text,
      "available_count": int.parse(_availableCountController.text),
      "cost": double.parse(_costController.text),
      "item_id": widget.itemObj['id'],
    };

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postService(URL_UPDATE_ITEM, body);

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      Navigator.pop(context, true);
    }
  }
}
