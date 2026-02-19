import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/choose_file.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class AddOrdersPayments extends StatefulWidget {
  const AddOrdersPayments({super.key});

  @override
  State<AddOrdersPayments> createState() => _AddOrdersPaymentsState();
}

class _AddOrdersPaymentsState extends State<AddOrdersPayments> {
  Uint8List? _csvBytes;

  bool _isLoading = false;

  String _currentFilterValue = "";

  var _summary;

  @override
  void initState() {
    super.initState();

    initProfit();
  }

  initProfit() async {
    var body = {"filter_type": _currentFilterValue};

    ApiResponse response = await postService(URL_ACTUAL_PROFIT, body);

    if (response.isSuccess) {
      setState(() {
        if(response.body['profit'] != null){
          _summary = response.body;
        }
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Payment update'),
      body: Column(
        children: [
          ChooseFile(
            onBytesRead: (bytes) {
              setState(() {
                _csvBytes = bytes;
              });
            },
            fileExtension: 'zip',
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
          addVerticalSpace(40),
          Divider(),

          if (_summary != null) Container(
            padding: CONTENT_PADDING,
            child: Column(
              children: [
                FiltersByUrl(
                  filterFor: "payment",
                  onClicked: (value) {
                    _currentFilterValue = value;
                    initProfit();
                  },
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: [
                      _buildCard(
                        "Pending",
                        _summary['not_updated'],
                        Icons.pending,
                        Colors.red,
                      ),

                      _buildCard(
                          "Total Orders",
                          _summary['total'],
                          Icons.inventory_2,
                          Colors.blue,
                        ),
                      _buildCard(
                        "Delivered",
                        _summary['delivered'],
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildCard(
                        "Canceled",
                        _summary['canceled'],
                        Icons.cancel,
                        Colors.red,
                      ),
                      _buildCard(
                        "Returned",
                        _summary['returned'],
                        Icons.undo,
                        Colors.orange,
                      ),
                      _buildCard(
                        "Profit",
                        (_summary['profit']).toStringAsFixed(2),
                        Icons.wallet_membership,
                        _summary['profit'] >= 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  updateStatusBy() async {
    // print(_csvBytes!);
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await postBytesService(
      URL_UPDATE_ACTUAL_PAYMENTS,
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

  Widget _buildCard(String title, dynamic value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
