import 'package:flutter/material.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
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
                label: Text('${widget.order['stage_name']}'),
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
                  Text("Customer Name"),
                  addHorizontalSpace(),
                  Text(
                    widget.order['custumer_name'],
                    style: getTextTheme(color: COLOR_PRIMARY).titleSmall,
                  ),
                ],
              ),
          
              Row(
                children: [
                  Text("Name"),
                  addHorizontalSpace(),
                  Text(
                    (widget.order['product_name'].length > 20)
                    ? widget.order['product_name'].toString().substring(0, 20)
                    : widget.order['product_name'],
                    maxLines:3,
                    softWrap:true,
                    overflow: TextOverflow.ellipsis,
                    style: getTextTheme().titleSmall,
                  ),
                ],
              ),
          
              
              Row(
                children: [
                  Text("Order Id:"),
                  addHorizontalSpace(),
                  Text(
                    widget.order['order_number'],
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
                    widget.order['sku_name'],
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
              if(widget.children != null)
              ...widget.children!
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
