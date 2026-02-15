import 'package:flutter/material.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/constants/theme_constant.dart';

class CancelOrderPage extends StatefulWidget {
  const CancelOrderPage({super.key});

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: CONTENT_PADDING,
          child: Column(
            children: [
              FiltersByUrl(
                filterFor: "shipping",
                onClicked: (value) {
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
