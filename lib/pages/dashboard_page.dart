import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/screen_action_bar.dart';
import 'package:warehouse/components/screen_frame.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _dashboardData;
  @override
  void initState() {
    super.initState();

    initDashboard();
  }

  initDashboard() async {
    var body = {"start_date": "", "end_date": ""};

    ApiResponse response = await postService(URL_DASHBOARD, body);

    if (response.isSuccess) {
      setState(() {
        _dashboardData = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dashboardData == null) {
      return ScreenFrame(

        titleBar: ScreenActionBar(title: 'Sales Dashboard'),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressCircular(width: 32, height: 32, padding: CONTENT_PADDING),
          ],
        ),
      );
      // return Row(children: [ProgressCircular(width: 32, height: 32)]);
    }
    final perProduct = _dashboardData['per_product_sale'];
    final List products = perProduct['detail'];

    return Scaffold(
      appBar: AppBar(title: const Text('Sales Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 SUMMARY
            Row(
              children: [
                _summaryCard(
                  title: 'Total Profit',
                  value: perProduct['total_profit'],
                  isProfit: true,
                ),
                const SizedBox(width: 12),
                _summaryCard(
                  title: 'Total Sales',
                  value: perProduct['total_sale_count'],
                  isProfit: false,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// 🔹 BAR CHART
            const Text(
              'Profit per Product',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  titlesData: _barTitles(products),
                  barGroups: _barGroups(products),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 PRODUCT LIST
            const Text(
              'Product Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final profit = product['profit'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: profit >= 0 ? Colors.green : Colors.red,
                      child: Icon(
                        profit >= 0 ? Icons.trending_up : Icons.trending_down,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      product['product_name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('Sales Count: ${product['sale_count']}'),
                    trailing: Text(
                      profit >= 0
                          ? '₹${profit.toStringAsFixed(2)}'
                          : '-₹${profit.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: profit >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _barGroups(List products) {
    return List.generate(products.length, (index) {
      final profit = products[index]['profit'];

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: profit.toDouble(),
            width: 8,
            color: profit >= 0 ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  FlTitlesData _barTitles(List products) {
    return FlTitlesData(
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text('₹${value.toInt()}');
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= products.length) {
              return const SizedBox.shrink();
            }

            final name = products[index]['short_name'] as String;

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                name.length > 6 ? '${name.substring(0, 6)}…' : name,
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required dynamic value,
    required bool isProfit,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              isProfit
                  ? '₹${(value as num).toStringAsFixed(2)}'
                  : value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isProfit
                    ? (value >= 0 ? Colors.green : Colors.red)
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
