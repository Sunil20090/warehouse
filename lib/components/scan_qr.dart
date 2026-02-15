import 'package:flutter/material.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';

class ScanQr extends StatelessWidget {
  final Function(String scannedValue) onScanComplete;
  const ScanQr({super.key, required this.onScanComplete});

 @override
  Widget build(BuildContext context) {
    return Container(
      padding: CONTENT_PADDING,
      child: IconButton(
        onPressed: scanByCamera,
        icon: Icon(Icons.qr_code_scanner, color: COLOR_PRIMARY,),
      ),
    );
  }

  scanByCamera() async {
    final value = await getScanValue();
    onScanComplete(value);
  }
}

