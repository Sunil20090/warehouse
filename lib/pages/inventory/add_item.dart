import 'dart:io';

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
  File? _file;

  bool _loading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _availableCountController = TextEditingController();
  TextEditingController _costController = TextEditingController();

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
                      onFileSelected: (file) {
                        _file = file;
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

              LoadableButton(
                name: 'Add or Update',
                isLoading: _loading,
                onClicked: addOrUpdateItem,
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrUpdateItem() async {
  
    var body = {
      "name": _nameController.text,
      "available_count": int.parse(_availableCountController.text),
      "cost": double.parse(_costController.text),
      "image_base64": (_file != null) ? await fileToBase64(_file!) : null,
      "purpose": widget.itemObj == null ? 'add' : 'update',
      "item_id": widget.itemObj != null ? widget.itemObj['id'] : 0,
    };

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postService(URL_ADD_ITEM, body);

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      Navigator.pop(context, true);
    }
  }
}
