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

class OrderStatusUpdate extends StatefulWidget {
  const OrderStatusUpdate({super.key});

  @override
  State<OrderStatusUpdate> createState() => _OrderStatusUpdateState();
}

class _OrderStatusUpdateState extends State<OrderStatusUpdate> {
  Uint8List? _csvBytes;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Status update'),
      body: Column(
        children: [
          ChooseFile(
            onBytesRead: (bytes) {
              setState(() {
                _csvBytes = bytes;
              });
            },
            fileExtension: 'csv',
          ),
          addVerticalSpace(40),

          if (_csvBytes != null)
            Row(
              children: [
                LoadableButton(
                  name: 'Upload CSV',
                  isLoading: _isLoading,
                  onClicked: updateStatusBy,
                ),
              ],
            ),
        ],
      ),
    );
  }

  updateStatusBy() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await postBytesService(
      URL_UPDATE_ACTUAL_STATUS_OF_ORDERS,
      _csvBytes!,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      if (response.body['status'] == "OK") {
        showAlert(context, response.body['heading'], response.body['message']);
      }
    } else {
      showApiError(context);
    }
  }
}
