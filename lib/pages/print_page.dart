import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/choose_file.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  Uint8List? _pdfBytes;

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Status update'),
      body: Column(
        children: [
          ChooseFile(
            onBytesRead: (bytes) {
              setState(() {
                _pdfBytes = bytes;
              });
            },
            fileExtension: 'pdf',
          ),
          addVerticalSpace(40),

          if (_pdfBytes != null)
            LoadableButton(
              name: 'Crop PDF',
              isLoading: _isLoading,
              onClicked: cropPdfs,
            ),
        ],
      ),
    );
  }

  cropPdfs() async {

    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await postBytesService(URL_GET_PRINTABLE_LABLES, _pdfBytes!);

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      openPdf(await base64ToPdf(response.body, 'cropped'));
    }
  }
}
