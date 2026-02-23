import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class SummaryItemWisePage extends StatefulWidget {
  final int level;
  final String levelName;
  const SummaryItemWisePage({
    super.key,
    required this.level,
    required this.levelName,
  });

  @override
  State<SummaryItemWisePage> createState() => _SummaryItemWisePageState();
}

class _SummaryItemWisePageState extends State<SummaryItemWisePage> {
  var _summary = [];
  bool _loading = false;

  double _totalCost = 0.0;
  int _totalCount = 0;
  @override
  void initState() {
    super.initState();
    _initSummary();
  }

  _initSummary() async {
    var body = {"level": widget.level};

    setState(() {
      _loading = true;
    });

    ApiResponse response = await postService(URL_GET_ITEM_WISE_SUMMARY, body);

    setState(() {
      _loading = false;
    });

    if (response.isSuccess) {
      setState(() {
        _summary = response.body['data'];
        _totalCost = _summary
            .map((el) => double.parse(el['cost']))
            .reduce((value, element) => element + value);

         _totalCount = _summary
            .map((el) => int.parse(el['item_required']))
            .reduce((value, element) => element + value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.levelName} Item Summary'),
        elevation: 0,
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: ProgressCircular())
            : Padding(
                padding: SCREEN_PADDING,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      color: COLOR_BASE,
                      padding: CONTENT_PADDING,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Total Cost:',
                                style: getTextTheme().titleSmall,
                              ),
                              Text(
                                '$_totalCost',
                                style: getTextTheme().titleLarge,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Total Count:',
                                style: getTextTheme().titleSmall,
                              ),
                              Text(
                                '$_totalCount',
                                style: getTextTheme().titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _summary.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _summary[index];

                          return Card(
                            elevation: 3,
                            shadowColor: Colors.black.withOpacity(0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {}, // future detail page 👀
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Thumbnail
                                    RoundedRectImage(
                                      width: 64,
                                      height: 64,
                                      thumbnail_url: item['url'],
                                    ),

                                    const SizedBox(width: 14),

                                    /// Product Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['item_name'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Cost: ${item['cost']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// Orders Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue.shade400,
                                            Colors.blue.shade700,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            item['item_required'].toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'Required',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
