import 'package:flutter/material.dart';
import 'package:warehouse/components/card_with_badge.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/dashboard_page.dart';
import 'package:warehouse/pages/dispatch_page.dart';
import 'package:warehouse/pages/order_shiped.dart';
import 'package:warehouse/pages/pack_orders_page.dart';
import 'package:warehouse/pages/product_list_page.dart';
import 'package:warehouse/pages/register_order_page.dart';
import 'package:warehouse/pages/view_bill_page.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _summary;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    initSummary();
  }

  initSummary() async {

    setState(() {
      _loading = true;
    });
    ApiResponse response = await postService(URL_SUMMARY, {});
    setState(() {
      _loading = false;
    });

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
      body: !_loading 
      ? Column(
        children: [

          CardWithBadge(name: 'Product List', badge: '${_summary['product_count']}', onCardClicked: openProductList,),
          CardWithBadge(name: 'Registered Orders', badge: '${_summary['registered_orders']}', onCardClicked: openRegisteredOrder,),
          CardWithBadge(name: 'Packed Orders', badge: '${_summary['paked_orders']}', onCardClicked: openPackOrders,),
          CardWithBadge(
                  name: 'Outgoing Orders',
                  badge: '${_summary['outgoing_orders']}',
                  onCardClicked: openProductList,
                ),
                CardWithBadge(name: 'Dashboard', onCardClicked: openDashboardPage,),
          
        ],
      )
      : Column(
        children: [
          addVerticalSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressCircular()
            ],
          ),
        ],
      ),
    );
  }


  openDashboardPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => DashboardPage()),
    );
  }

  moveToDispatch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => DispatchPage()),
    );
    initSummary();
  }

  openPackOrders() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => PackOrdersPage()),
    );
  }

  openProductList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => ProductListPage()),
    );
  }

  openRegisteredOrder() async{
    await Navigator.push(context, MaterialPageRoute(builder: (builder) => RegisterOrderPage()));
  }
}
