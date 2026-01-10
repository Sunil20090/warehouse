import 'package:flutter/material.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';

class ItemOrder extends StatefulWidget {
  final dynamic order;
  bool isDeletable;
  Function(dynamic order)? onDeleteClicked;
  ItemOrder({
    super.key,
    required this.order,
    this.onDeleteClicked,
    this.isDeletable = true,
  });

  @override
  State<ItemOrder> createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Column(
            children: [
              RoundedRectImage(
                thumbnail_url: widget.order['thumbnail_url'],
                fit: BoxFit.contain,
              ),
              addVerticalSpace(),
              Badge(
                padding: CONTENT_PADDING,
                label: Text('${widget.order['status']}'),
              ),
            ],
          ),
          addHorizontalSpace(),
          addHorizontalSpace(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Order Id:"),
                  addHorizontalSpace(),
                  Text(
                    widget.order['order_id'],
                    style: getTextTheme().titleSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Tracking Id:"),
                  addHorizontalSpace(),
                  Text(
                    widget.order['tracking_id'],
                    style: getTextTheme().titleSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Text("SKU Id"),
                  addHorizontalSpace(),
                  Text(
                    widget.order['sku_id'],
                    style: getTextTheme().titleSmall,
                  ),
                ],
              ),

              Row(
                children: [
                  Text("Last update"),
                  addHorizontalSpace(),
                  Text(
                    timeAgo(
                      widget.order['updated_on'],
                      timezoneOffset: Duration(hours: 5, minutes: 30),
                    ),
                    style: getTextTheme().titleSmall,
                  ),
                ],
              ),
            ],
          ),

          addHorizontalSpace(),
          Spacer(),
          if (widget.isDeletable)
            InkWell(
              onTap: () {
                if (widget.onDeleteClicked != null) {
                  widget.onDeleteClicked!(widget.order);
                }
              },
              child: Icon(Icons.delete, size: 30, color: COLOR_PRIMARY),
            ),
        ],
      ),
    );
  }
}
