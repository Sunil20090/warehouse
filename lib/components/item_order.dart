import 'dart:io';
import 'package:flutter/material.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/order_deep_details_page.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class ItemOrder extends StatefulWidget {
  final dynamic order;
  bool isDeletable;
  List<Widget>? children;
  Function(dynamic order)? onDeleteClicked;

  ItemOrder({
    super.key,
    required this.order,
    this.onDeleteClicked,
    this.children,
    this.isDeletable = true,
  });

  @override
  State<ItemOrder> createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) =>
              OrderDeepDetailsPage(order_id: widget.order['id']),
        ),
      ),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------- HEADER ----------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGE + STATUS
                  Column(
                    children: [
                      RoundedRectImage(
                        width: 60,
                        height: 80,
                        thumbnail_url: widget.order['thumbnail_url'],
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  /// DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Customer name + delete
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.order['custumer_name'],
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.isDeletable)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  widget.onDeleteClicked?.call(widget.order);
                                },
                              ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        _infoRow("id", '${widget.order['id']}'),
                        _infoRow("Product", widget.order['product_name']),
                        _infoRow("Quantity", '${widget.order['quantity']}'),
                        _infoRow("Order ID", widget.order['order_number']),
                        _infoRow("Tracking ID", widget.order['tracking_id']),
                        _infoRow("SKU", widget.order['sku_name']),
                        _infoRow(
                          "Delivery prtr",
                          '${widget.order['delivery_partener']}'
                              .toString()
                              .toUpperCase(),
                        ),
                        _infoRow(
                          "Created",
                          standardDate(
                            widget.order['created_on'],
                            timezoneOffset: const Duration(
                              hours: 5,
                              minutes: 30,
                            ),
                          ),
                        ),

                        _infoRow(
                          "Actual Status",
                          widget.order['actual_status'],
                          isSpecial: true,
                        ),

                        _infoRow(
                          "Actual Updated on:",
                          (widget.order['stage_updated_on'] != null)
                              ? timeAgo(widget.order['stage_updated_on'])
                              : '${widget.order['stage_updated_on']}',
                          isSpecial: false,
                        ),

                        if (widget.children != null) ...widget.children!,
                      ],
                    ),
                  ),
                ],
              ),

              /// ---------- ACTIONS ----------
              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.order['is_invoice_available'] == 1)
                    LoadableButton(
                      name: 'Label',
                      isLoading: _loading,
                      onClicked: () => getPdf('label'),
                    ),

                  Container(
                    padding: CONTENT_PADDING,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.1),
                      color: const Color.fromARGB(255, 2, 62, 141),
                    ),
                    height: 40,
                    child: Text(
                      widget.order['stage_name'].toString().toUpperCase(),
                      style: getTextTheme(color: COLOR_BASE).titleMedium,
                    ),
                  ),

                  const Divider(height: 24),
                ],
              ),

              Divider(),

              Row(
                children: [
                  LoadableButton(
                    backgroundColor: COLOR_RED,
                    name: 'Mark Cancel',
                    isLoading: _loading,
                    onClicked: () => updateStage('cancel', widget.order),
                  ),

                  LoadableButton(
                    backgroundColor: COLOR_RED,
                    name: 'Mark Return',
                    isLoading: _loading,
                    onClicked: () => updateStage('return', widget.order),
                  ),

                  LoadableButton(
                    backgroundColor: COLOR_RED,
                    name: 'Mark Used',
                    isLoading: _loading,
                    onClicked: () => updateStage('used', widget.order),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- INFO ROW ----------
  Widget _infoRow(String label, String value, {bool isSpecial = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: getTextTheme(color: Colors.grey).bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              '$value',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (isSpecial)
                  ? getTextTheme(color: COLOR_PRIMARY).titleMedium
                  : getTextTheme().bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- PDF ----------
  getPdf(String type) async {
    var body = {"tracking_id": widget.order['tracking_id'], "type": type};

    setState(() => _loading = true);

    ApiResponse response = await postService(URL_SEE_LABEL, body);

    setState(() => _loading = false);

    if (response.isSuccess) {
      File file = await base64ToPdf(response.body['pdf_base64'], type);
      openPdf(file);
    }
  }

  updateStage(stage, order) {
    showAlert(
      context,
      'Sure!',
      'Are you sure to mark ${order['custumer_name']} as ${stage}',
      onDismiss: () async {
        Navigator.pop(context);
        setState(() {
          _loading = true;
        });
        await postService(URL_UPDATE_STAGE_OF_ORDER, {
          "stage": stage,
          "order_id": order['id'],
        });
        setState(() {
          _loading = false;
        });
      },
    );
  }
}
