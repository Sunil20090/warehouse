import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ChooseFile extends StatefulWidget {
  Function(Uint8List? bytes)? onBytesRead;
  String fileExtension;
  ChooseFile({
    super.key,
    required this.onBytesRead,
    required this.fileExtension,
  });

  @override
  State<ChooseFile> createState() => _ChoosePdfFileState();
}

class _ChoosePdfFileState extends State<ChooseFile> {
  String _currentFileName = 'No file Choosen';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CONTENT_PADDING,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("File Name:", style: getTextTheme().titleSmall),
                Text(
                  _currentFileName,
                  style: getTextTheme().bodySmall,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          LoadableButton(name: 'Choose', onClicked: choosePdf),
        ],
      ),
    );
  }

  choosePdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [widget.fileExtension],
      withData: true,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _currentFileName = file.name;
      });
      if (kIsWeb) {
        Uint8List? bytes = file.bytes;

        if (bytes != null && widget.onBytesRead != null) {
          widget.onBytesRead!(bytes);
        }
      } else {
        File selectedFile = File(file.path!);

        if (widget.onBytesRead != null) {
          widget.onBytesRead!(await selectedFile.readAsBytes());
        }
      }
    }
  }
}
