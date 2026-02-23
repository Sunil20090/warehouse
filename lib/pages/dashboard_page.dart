import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
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

  bool _fetching = false, _filterFetching = false;

  var perProduct;
  var products = [];

  var _filterTypes = [];

  String _choosenFilterType = '';

  List<String> datatype = ['Orders', 'Sales'];
  String _currentDataType = 'Sales';
  @override
  void initState() {
    super.initState();
    initDashboard();
  }

  initDashboard() async {
    var body = {"filter_type": _choosenFilterType};

    setState(() {
      _fetching = true;
    });

    ApiResponse response = await postService(URL_DASHBOARD, body);

    setState(() {
      _fetching = false;
    });

    if (response.isSuccess) {
      setState(() {
        _dashboardData = response.body;
        perProduct = _dashboardData['per_product_sale'];
        products = perProduct['detail'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: (isLandscape(context))
      ? _portraitView() : _landscapeView()
    );
  }

  Widget _portraitView(){
    return (_dashboardData != null)
          ? Container(
              padding: CONTENT_PADDING,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FiltersByUrl(
                    filterFor: "dashboard",
                    onClicked: (choosenValue) {
                      _choosenFilterType = choosenValue;
                      initDashboard();
                    },
                  ),
                  addVerticalSpace(),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addVerticalSpace(),
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

                        const Text(
                          'Profit per Product',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            child: BarChart(
                              BarChartData(
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: true),
                                titlesData: _barTitles(products),
                                barGroups: _barGroups(products),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          height: 40,
                          child: Row(
                            spacing: 6,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: datatype.map((item) {
                              return FilterChip(
                                selected: item == _currentDataType,
                                label: Text(item),
                                onSelected: (value) {
                                  setState(() {
                                    _currentDataType = item;
                                    initDashboard();
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        addVerticalSpace(),
                        Divider(),

                        Text(
                          'Product Details ( ${products.length} )',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          flex: 6,
                          child: ListView.separated(
                            itemCount: products.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final profit = product['profit'];

                              return ListTile(
                                leading: Stack(
                                  children: [
                                     RoundedRectImage(thumbnail_url: product['thumbnail_url'], fit: BoxFit.contain,),
                                    CircleAvatar(
                                      radius:10,
                                      backgroundColor: profit >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      child: Icon(
                                        
                                        profit >= 0
                                            ? Icons.trending_up
                                            : Icons.trending_down,
                                        color: Colors.white, size: 10,
                                      ),
                                    ),

                                  ],
                                ),
                                title: Text(
                                  product['product_name'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sales Count: ${product['sale_count']}',
                                    ),
                                    addHorizontalSpace(),
                                    Text(
                                      'Per pc profit ${(profit / double.parse(product['sale_count']))}',
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Text(
                                      profit >= 0
                                          ? '₹${profit.toStringAsFixed(2)}'
                                          : '-₹${profit.abs().toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: profit >= 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),

                                    addVerticalSpace(),

                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ProgressCircular()],
            );
  }

  Widget _landscapeView() {
  return (_dashboardData != null)
      ? Container(
          padding: CONTENT_PADDING,
          child: Row(
            children: [

              /// LEFT SIDE (Chart + Summary)
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    FiltersByUrl(
                      filterFor: "dashboard",
                      onClicked: (choosenValue) {
                        _choosenFilterType = choosenValue;
                        initDashboard();
                      },
                    ),

                    addVerticalSpace(),

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

                    const SizedBox(height: 16),

                    const Text(
                      'Profit per Product',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Chart
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: true),
                          titlesData: _barTitles(products),
                          barGroups: _barGroups(products),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Chips
                    Wrap(
                      spacing: 6,
                      children: datatype.map((item) {
                        return FilterChip(
                          selected: item == _currentDataType,
                          label: Text(item),
                          onSelected: (value) {
                            setState(() {
                              _currentDataType = item;
                              initDashboard();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const VerticalDivider(),

              /// RIGHT SIDE (Product List)
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Product Details ( ${products.length} )',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                            leading: Stack(
                              children: [
                                RoundedRectImage(
                                  thumbnail_url: product['thumbnail_url'],
                                  fit: BoxFit.contain,
                                ),

                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: profit >= 0
                                      ? Colors.green
                                      : Colors.red,
                                  child: Icon(
                                    profit >= 0
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ),
                              ],
                            ),

                            title: Text(
                              product['product_name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            subtitle: Text(
                              'Sales: ${product['sale_count']}',
                            ),

                            trailing: Text(
                              profit >= 0
                                  ? '₹${profit.toStringAsFixed(2)}'
                                  : '-₹${profit.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: profit >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      : Center(child: ProgressCircular());
}

  List<BarChartGroupData> _barGroups(List products) {
    return List.generate(products.length, (index) {
      final profit = products[index]['profit'];
      final sale_count = products[index]['sale_count'];

      return BarChartGroupData(
        x: index,
        barRods: [
          if (_currentDataType == 'Sales')
            BarChartRodData(
              toY: profit.toDouble(),
              width: 8,
              color: profit >= 0 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          if (_currentDataType == 'Orders')
            BarChartRodData(
              toY: double.parse(sale_count),
              width: 8,
              color: Colors.blue,
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
            if (_currentDataType == 'Orders') {
              return Text('  ${value.toInt()}');
            }
            return Text(' ₹${value.toInt()}');
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
