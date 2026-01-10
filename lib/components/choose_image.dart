import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warehouse/components/colored_button.dart';
import 'package:warehouse/constants/image_constant.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';

class ChooseImage extends StatefulWidget {
  Function(File imageFile) onFileSelected;
  ChooseImage({super.key, required this.onFileSelected});

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addVerticalSpace(),
          Text("Add Image", style: getTextTheme().titleSmall),
          Row(
            children: [
              (_imageFile == null)
                  ? Image.asset(
                      IMAGE_VOTING_ICON,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      _imageFile!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
              Spacer(),
              ColoredButton(
                child: Text('Choose', style: TextStyle(color: COLOR_WHITE)),
                onPressed: () {
                  pickImage();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  pickImage() async {
    final file = await getLocalImage(ImageSource.gallery);

    if (file != null) {
      setState(() {
        widget.onFileSelected(file);
        _imageFile = file;
      });
    }
  }
}
