import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewBillPage extends StatefulWidget {

  final String pdfUrl;
  const ViewBillPage({super.key, required this.pdfUrl});

  @override
  State<ViewBillPage> createState() => _ViewBillPageState();
}

class _ViewBillPageState extends State<ViewBillPage> {

   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('View Bill-'),
    ),
     body: SafeArea(child: SfPdfViewer.network(widget.pdfUrl, key: _pdfViewerKey,)),);
  }
}