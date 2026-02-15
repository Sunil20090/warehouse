import 'package:flutter/material.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';

class Item extends StatelessWidget {
  final dynamic item;
  const Item({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedRectImage(thumbnail_url: item['url']),
        addHorizontalSpace(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item['name']}', style: getTextTheme().bodySmall),
              if (item['quantity_used'] != null)
                Text('Quantity: ${item['quantity_used']}'),
            ],
          ),
        ),
      ],
    );
  }
}
