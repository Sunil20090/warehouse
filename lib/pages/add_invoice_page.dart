import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse/components/global_components/choose_file.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';
import 'package:warehouse/utils/user_service.dart';

class AddInvoicePage extends StatefulWidget {
  const AddInvoicePage({super.key});

  @override
  State<AddInvoicePage> createState() => _AddInvoicePageState();
}

class _AddInvoicePageState extends State<AddInvoicePage> {
  bool _uploadingPdf = false, _creatingOrder = false;

  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Add Invoice'),
      body: Column(
        children: [
          addVerticalSpace(),
          ChooseFile(
            fileExtension: 'pdf',
            onBytesRead: (bytes) {
              setState(() {
                _pdfBytes = bytes;
              });
            },
          ),
          addVerticalSpace(60),

          Divider(),

          if (_pdfBytes != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LoadableButton(
                  name: 'Update Label and Invoice',
                  onClicked: addInvoice,
                  isLoading: _uploadingPdf,
                ),

                LoadableButton(
                  name: 'Create Order',
                  onClicked: createOrderWithPdf,
                  isLoading: _creatingOrder,
                ),
              ],
            ),
        ],
      ),
    );
  }

  addInvoice() async {
    setState(() {
      _uploadingPdf = true;
    });
    ApiResponse response = await postBytesService(URL_ADD_INVOICE, _pdfBytes!);

    setState(() {
      _uploadingPdf = false;
    });

    if (response.isSuccess) {
      showAlert(context, response.body['heading'], response.body['message']);
    } else {
      showApiError(context);
    }
  }

  createOrderWithPdf() async {
    // String base64 = await fileToBase64(pdfFle!);

    // var body = {
    //   "user_id": await getUserId(),
    //   "base64": base64,
    //   "file_name": getFileName(pdfFle!),
    // };

    // setState(() {
    //   _creatingOrder = true;
    // });

    // ApiResponse response = await postService(URL_ADD_INVOICE, body);

    // setState(() {
    //   _creatingOrder = false;
    // });
  }
}
