import 'package:flutter/material.dart';
import 'package:warehouse/components/project_components/card_with_badge.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/add_invoice_page.dart';
import 'package:warehouse/pages/add_orders_payments.dart';
import 'package:warehouse/pages/dashboard_page.dart';
import 'package:warehouse/pages/inventory/inventory_page.dart';
import 'package:warehouse/pages/order_list_page.dart';
import 'package:warehouse/pages/order_shiped.dart';
import 'package:warehouse/pages/order_status_update.dart';
import 'package:warehouse/pages/packing_dashboard/pack_orders_page.dart';
import 'package:warehouse/pages/print_page.dart';
import 'package:warehouse/pages/products/product_list_page.dart';
import 'package:warehouse/pages/search_orders.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Home'),
            addHorizontalSpace(),
            if (_loading) ProgressCircular(),
          ],
        ),
        actions: [
          IconButton(onPressed: initSummary, icon: Icon(Icons.replay_outlined)),
        ],
      ),
      body: (_summary != null)
          ? GridView.count(
              crossAxisCount: (MediaQuery.of(context).size.width / 200).toInt() ,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                CardWithBadge(
                  name: 'Product List',
                  badge: '${_summary['product_count']}',
                  onCardClicked: openProductList,
                  iconType: Icons.category_outlined,
                  iconColor: Colors.deepOrange,
                ),

                CardWithBadge(
                  name: 'Items & Inventory',
                  onCardClicked: openInventoryPage,
                  iconType: Icons.inventory_2_outlined,
                  iconColor: Colors.green,
                ),
                CardWithBadge(
                  name: 'Dashboard',
                  onCardClicked: openDashboardPage,
                  iconType: Icons.bar_chart_outlined,
                  iconColor: Colors.deepPurple,
                ),

                CardWithBadge(
                  name: 'Print Area',
                  onCardClicked: openPrintPage,
                  iconType: Icons.print_outlined,
                  iconColor: Colors.indigoAccent,
                ),

                CardWithBadge(
                  name: 'Global Search',
                  onCardClicked: openGlobalSearch,
                  iconType: Icons.search,
                  iconColor: Colors.orange,
                ),

                CardWithBadge(
                  name: 'Label Created',
                  badge: '${_summary['registered_orders']}',
                  onCardClicked: openRegisteredOrder,
                  iconType: Icons.assignment_outlined,
                  iconColor: Colors.teal,
                ),

                CardWithBadge(
                  name: 'Add Invoices',
                  onCardClicked: openAddInvoicePage,
                  iconType: Icons.receipt_long_outlined,
                  iconColor: Colors.purple,

                ),

                CardWithBadge(
                  name: 'Packed Orders',
                  badge: '${_summary['paked_orders']}',
                  onCardClicked: openPackOrders,
                  iconType: Icons.archive_outlined,
                  iconColor: Colors.pink,
                ),

                 CardWithBadge(
                  name: 'Update Status',
                  onCardClicked: openStatusUpdatePage,
                  iconType: Icons.file_present,
                  iconColor: COLOR_SECONDARY,
                ),

                 CardWithBadge(
                  name: 'Update Payments',
                  onCardClicked: openPaymentScreen,
                  iconType: Icons.money_outlined,
                  iconColor: const Color.fromARGB(255, 73, 94, 0),
                ),

                CardWithBadge(
                  name: 'Scan and Pack',
                  onCardClicked: scanAndPack,
                  iconType: Icons.qr_code_scanner,
                  iconColor: const Color.fromARGB(255, 2, 32, 152),
                ),

                CardWithBadge(
                  name: 'Ready to dispatch',
                  iconType: Icons.local_shipping_outlined,
                  iconColor: Colors.green,
                  onCardClicked: openOrderShippedPage,
                ),
                CardWithBadge(
                  name: 'Cancel Orders',
                  onCardClicked: openCancelOrderPage,
                  badge: '${_summary['cancel_orders']}',
                  iconType: Icons.highlight_off,
                  iconColor: const Color.fromARGB(255, 236, 8, 8),
                ),
                CardWithBadge(
                  name: 'Returned Orders',
                  onCardClicked: openReturnOrderPage,
                  badge: '${_summary['return_orders']}',
                  iconColor: const Color.fromARGB(255, 1, 85, 134),
                  iconType: Icons.assignment_return_outlined,
                ),
                CardWithBadge(
                  name: 'Used Orders',
                  onCardClicked: openUsedOrderPage,
                  badge: '${_summary['return_orders']}',
                  iconColor: const Color.fromARGB(255, 139, 79, 0),
                  iconType: Icons.check_box,
                ),
               
              ],
            )
          : Container(),
    );
  }

  openDashboardPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => DashboardPage()),
    );
  }

  openPackOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => OrderListPage(level: 2, screenName: 'Packed',)),
    );
  }

  openProductList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => ProductListPage()),
    );
  }

  openRegisteredOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => OrderListPage(level: 1, screenName: 'Label Generated'),
      ),
    );
  }

  openStatusUpdatePage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => OrderStatusUpdate()),
    );
  }

  openAddInvoicePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => AddInvoicePage()),
    );
  }

  scanAndPack() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => PackOrdersPage()),
    );
  }

  openReturnOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => OrderListPage(level: 5, screenName: 'Return',)),
    );
  }

  openCancelOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => OrderListPage(level: 4, screenName: 'Cancel',)),
    );
  }

  openUsedOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => OrderListPage(level: 6, screenName: 'Used'),
      ),
    );
  }

  openGlobalSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => SearchOrders()),
    );
  }

  openOrderShippedPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => OrderShiped()),
    );
  }

  openPrintPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => PrintPage()),
    );
  }

  openInventoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => InventoryPage()),
    );
  }

  openPaymentScreen(){
     Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => AddOrdersPayments()),
    );
  }
}
