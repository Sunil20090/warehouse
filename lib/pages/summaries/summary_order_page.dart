import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/summaries/summary_item_wise_page.dart';
import 'package:warehouse/utils/api_service.dart';

class SummaryOrderPage extends StatefulWidget {
  final int level;
  final String levelName;
  const SummaryOrderPage({super.key, required this.level, required this.levelName});

  @override
  State<SummaryOrderPage> createState() => _SummaryOrderPageState();
}

class _SummaryOrderPageState extends State<SummaryOrderPage> {
  var _summary = [];
  bool _loading = false;
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

    ApiResponse response = await postService(URL_GET_ORDER_SUMMARY, body);

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
      appBar: AppBar(title: Text('${widget.levelName} Summary',), elevation: 0, actions: [
        IconButton(
          onPressed: openSummaryItemWise,
          icon: Icon(Icons.category_outlined))
      ],),
      body: SafeArea(
        child: (!_loading)
        ? Container(
          padding: SCREEN_PADDING,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _summary.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = _summary[index];
          
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Thumbnail
                    Stack(
                      children: [
                        RoundedRectImage(
                          width: 60,
                          height: 60,
                          thumbnail_url: item['thumbnail_url']),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child:
                         Badge(
                          backgroundColor: COLOR_PRIMARY,
                          
                          label: Text('Qty: ${item['quantity']}', style: getTextTheme(color: COLOR_BASE).bodySmall,),))
                      ],
                    ),
                    
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(8),
                    //   child: Image.network(
                    //     item['thumbnail_url'],
                    //     width: 60,
                    //     height: 60,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
          
                    const SizedBox(width: 12),
          
                    /// Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['product_name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'SKU: ${item['sku_name']}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    /// Order Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            item['order_count'].toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const Text(
                            'Orders',
                            style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ) 
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressCircular()
          ],
        ),
      ),
    );
  }


  openSummaryItemWise(){
    Navigator.push(context, MaterialPageRoute(builder: (builder)=> SummaryItemWisePage(level: widget.level, levelName: widget.levelName)));
  }
}
