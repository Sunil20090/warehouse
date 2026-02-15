import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/project_components/filters_by_url.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class OrderShiped extends StatefulWidget {
  const OrderShiped({super.key});

  @override
  State<OrderShiped> createState() => _OrderShipedState();
}

class _OrderShipedState extends State<OrderShiped> {
  

  String _choosenFilterValue = 'Today';

  bool _loading = false;

 List<Map<String, dynamic>> _tableData = [];
  List<String> _statusKeys = [];
  Map<String, int> _columnTotals = {};

  @override
  void initState() {
    super.initState();
    initShippedOrdersSummary();
  }

  initShippedOrdersSummary() async {
    var body = {"filter_type": _choosenFilterValue};

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postService(
      URL_READY_FOR_SHIPPING_SUMMARY,
      body,
    );

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      setState(() {
        prepareTableData(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ready for Shipping')),
      body: Column(
        children: [
          FiltersByUrl(
            filterFor: "shipping",
            onClicked: (choosenValue) {
              _choosenFilterValue = choosenValue;
              initShippedOrdersSummary();
            },
          ),
          addVerticalSpace(DEFAULT_LARGE_SPACE),

          addVerticalSpace(),
          (!_loading)
              ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columnSpacing: 40,
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey.shade200,
                    ),
                    columns: [
                      const DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Partner',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._statusKeys.map(
                        (key) => DataColumn(
                          numeric: true,
                          label: Text(
                            key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      ..._tableData.map((row) {
                        return DataRow(
                          
                          color: MaterialStateProperty.all(COLOR_BASE),
                          cells: [
                            DataCell(
                              Text(standardDate(row['date'], format: 'dd MMM')),
                            ),
                            DataCell(Text(row['delivery_partener'] ?? 'Unknown', style: getTextTheme().titleMedium,)),
                            ..._statusKeys.map(
                              (key) => DataCell(Text((row[key] ?? 0).toString(), style: getTextTheme().titleMedium, textAlign: TextAlign.center,)),
                            ),
                          ],
                        );
                      }).toList(),
                
                      /// TOTAL ROW
                      DataRow(
                        color: MaterialStateProperty.all(COLOR_BASE_SUCCESS),
                        cells: [
                          DataCell(
                            Text(
                              'Grand Total',
                              style: getTextTheme(color: COLOR_WHITE).titleMedium,
                            ),
                          ),
                          const DataCell(Text('')),
                          ..._statusKeys.map((key) {
                            int total = _tableData.fold(
                              0,
                              (sum, row) => sum + (row[key] ?? 0) as int,
                            );
                
                            return DataCell(
                              Text(
                                total.toString(),
                                style: getTextTheme(
                                  color: COLOR_WHITE,
                                ).titleMedium,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
              )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ProgressCircular()],
                ),
        ],
      ),
    );
  }

  void prepareTableData(List<dynamic> apiResponse) {
    Map<String, Map<String, dynamic>> tempMap = {};
    _statusKeys.clear();
    _columnTotals.clear();

    for (var section in apiResponse) {
      String key = section['details']['key'];

      _statusKeys.add(key);
      _columnTotals[key] = section['total'] ?? 0;

      List dataList = section['details']['data'];

      for (var item in dataList) {
        String partner = item['delivery_partener'];
        String date = item['date'];

        if (!tempMap.containsKey(partner)) {
          tempMap[partner] = {'date': date, 'delivery_partener': partner};
        }

        tempMap[partner]![key] = item['count'];
      }
    }

    _tableData = tempMap.values.toList();

    setState(() {});
  }
}
