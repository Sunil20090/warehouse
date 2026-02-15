import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/floating_label_edit_box.dart';
import 'package:warehouse/components/scan_qr.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';

class EditAndScan extends StatefulWidget {
  Function(String scannedValue)? onScanComplete;
  Function(String value)? onChange;
  EditAndScan({super.key, this.onChange, this.onScanComplete});

  @override
  State<EditAndScan> createState() => _EditAndScanState();
}

class _EditAndScanState extends State<EditAndScan> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CONTENT_PADDING,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: FloatingLabelEditBox(
              labelText: 'Search..',
              clearable: true,
              controller: _searchController,
              onChange: widget.onChange,
              // (value) {
              //   _flitered_order = filterItemBy(_orderList, value);
              //   setState(() {});
              // },
            ),
          ),
          addHorizontalSpace(),
          ScanQr(
            onScanComplete: (scannedValue) {
              _searchController.text = scannedValue;
              if (widget.onScanComplete != null) {
                widget.onScanComplete!(scannedValue);
              }
              if (widget.onChange != null) {
                widget.onChange!(scannedValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
