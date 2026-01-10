import 'package:flutter/material.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/dispatch_page.dart';
import 'package:warehouse/pages/order_shiped.dart';
import 'package:warehouse/pages/product_list_page.dart';
import 'package:warehouse/pages/view_bill_page.dart';
import 'package:warehouse/utils/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _summary;

  @override
  void initState() {
    super.initState();
    initSummary();
  }

  initSummary() async {
    ApiResponse response = await postService(URL_SUMMARY, {});

    if (response.isSuccess) {
      setState(() {
        _summary = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(
        title: 'Home',
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => ViewBillPage(
                pdfUrl:
                    'https://ssc.nic.in/Downloads/portal/english/Syllabus-JE%20Eamination.pdf',
              ),
            ),
          ),
          child: Icon(Icons.view_agenda),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () => openProductList(),
            child: Card(
              margin: CONTENT_PADDING,
              child: Padding(
                padding: CONTENT_PADDING * 3,
                child: Row(
                  children: [
                    Text("Products", style: getTextTheme().headlineMedium),
                    Spacer(),
                    if (_summary != null)
                      Badge(
                        backgroundColor: COLOR_PRIMARY,
                        padding: CONTENT_PADDING,
                        textStyle: getTextTheme().titleMedium,
                        label: Text('${_summary['product_count']}'),
                      ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => moveToDispatch(),
            child: Card(
              margin: CONTENT_PADDING,
              child: Padding(
                padding: CONTENT_PADDING * 3,
                child: Row(
                  children: [
                    Text("Incomming", style: getTextTheme().headlineMedium),
                    Spacer(),
                    if (_summary != null)
                      Badge(
                        backgroundColor: COLOR_PRIMARY,
                        padding: CONTENT_PADDING,
                        textStyle: getTextTheme().titleMedium,
                        label: Text('${_summary['registered_orders']}'),
                      ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => openShippedOrderList(),
            child: Card(
              margin: CONTENT_PADDING,
              child: Padding(
                padding: CONTENT_PADDING * 3,
                child: Row(
                  children: [
                    Text("Packed Order", style: getTextTheme().headlineMedium),
                    Spacer(),
                    if (_summary != null)
                      Badge(
                        backgroundColor: COLOR_PRIMARY,
                        padding: CONTENT_PADDING,
                        textStyle: getTextTheme().titleMedium,
                        label: Text('${_summary['dispatched']}'),
                      ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  moveToDispatch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => DispatchPage()),
    );
    initSummary();
  }

  openShippedOrderList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => OrderShiped()),
    );
  }

  openProductList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => ProductListPage()),
    );
  }
}
