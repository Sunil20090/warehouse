import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warehouse/components/colored_button.dart';
import 'package:warehouse/constants/image_constant.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';

class ChooseImage extends StatefulWidget {
  // Function(File imageFile) onFileSelected;
  Function(Uint8List bytesRecieved)? onBytesRead;
  ChooseImage({super.key, this.onBytesRead});

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  Uint8List? _imageBytes;

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
          Divider(),
          addVerticalSpace(),
          Text("Add Image", style: getTextTheme().titleSmall),
          addVerticalSpace(),
          Row(
            children: [
              (_imageBytes == null)
                  ? Image.asset(
                      IMAGE_VOTING_ICON,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  : Image.memory(
                      _imageBytes!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
              Spacer(),
              ColoredButton(
                child: Text(
                  'Choose',
                  style: getTextTheme(color: COLOR_BASE).titleMedium,
                ),
                onPressed: () {
                  chooseFile();
                },
              ),
              addHorizontalSpace(),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      if (kIsWeb) {
        Uint8List? bytes = file.bytes;
          setState(() {  
             _imageBytes = bytes;
          });

        if (bytes != null && widget.onBytesRead != null) {
          widget.onBytesRead!(bytes);
        }
      } else {
        File selectedFile = File(file.path!);

        if (widget.onBytesRead != null) {
          setState(() async {
            _imageBytes = await selectedFile.readAsBytes();
            widget.onBytesRead!(_imageBytes!);
          });
        }
      }
    }
  }
}
